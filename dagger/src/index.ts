import {
  dag,
  Container,
  Directory,
  object,
  func,
} from "@dagger.io/dagger"
import { v4 } from "uuid"
import { maxSatisfying, inc } from "semver"
import * as semver from "semver"

@object()
// eslint-disable-next-line @typescript-eslint/no-unused-vars
class Timpkg {
  isDev = false

  @func()
  withDev(isDev: boolean = true): Timpkg {
    this.isDev = isDev
    return this
  }

  /**
   * Pushes all modules in the directory to the registry.
   */
  @func()
  async onPush(dir: Directory, token?: string): Promise<string> {
    const tim = timoni().withDirectory("/tmp/timoni", dir)
    const modules = await dir.entries()

    const results = await Promise.all(
      modules.map(async (m) => {
        const imageUrl = this.isDev
          ? `oci://ttl.sh/${v4()}`
          : `oci://ghcr.io/anthonybrice/modules/${m}`
        const realModuleUrl = `oci://ghcr.io/anthonybrice/modules/${m}`
        const vs = (await modList(tim, realModuleUrl))
          .split("\n")
          .slice(1)
          .map((x) => semver.coerce(x))
        const current = maxSatisfying(vs, "*")
        const next = inc(current, "patch")

        return modPush(tim, `/tmp/timoni/${m}/`, imageUrl, next, token)
      }),
    )

    return results.join("\n")
  }
}

function timoni() {
  return dag
    .container()
    .from("golang:latest")
    .withExec([
      "go",
      "install",
      "github.com/stefanprodan/timoni/cmd/timoni@latest",
    ])
}

function modList(ctr: Container, url: string) {
  return ctr
    .withExec(["timoni", "mod", "list", url, "--with-digest=false"])
    .stdout()
}

function modPush(ctr: Container, path: string, url: string, version: string, token?: string) {
  return ctr
    .withExec([
      "timoni",
      "mod",
      "push",
      path,
      url,
      `--version=${version}`,
      "--latest=true",
      ...(token ? [`--creds=timoni:${token}`] : []),
    ])
    .stdout()
}
