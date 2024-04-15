import { dag, Container, Directory, object, func } from "@dagger.io/dagger"
import { v4 } from "uuid"
import { maxSatisfying, inc } from "semver"
import * as semver from "semver"

@object()
// eslint-disable-next-line @typescript-eslint/no-unused-vars
class Timpkg {
  isDev = false

  @func()
  withDev(): Timpkg {
    this.isDev = true
    return this
  }

  /**
   * Push all modules in the directory to the registry.
   */
  @func()
  async pushDirs(dir: Directory, token?: string): Promise<string> {
    const modules = await dir.entries()

    const results = await Promise.all(
      modules.map((m) => this.pushDir(dir.directory(m), token)),
    )

    return results.join("\n")
  }

  /**
   * Push module at directory to the registry.
   */
  @func()
  async pushDir(dir: Directory, token?: string): Promise<string> {
    const tim = timoni().withDirectory("/tmp/timoni", dir)
    const moduleName = (await dir.file("cue.mod/module.cue").contents())
      .split("/")
      .slice(1)[0]
      .replace(/[^a-z0-9]+$/i, "")

    const realModuleUrl = `oci://ghcr.io/anthonybrice/modules/${moduleName}`
    const imageUrl = this.isDev ? `oci://ttl.sh/${v4()}` : realModuleUrl
    const versions = (await modList(tim, realModuleUrl))
      .split("\n")
      .slice(1)
      .map((x) => semver.coerce(x))
    const current = maxSatisfying(versions, "*")
    const next = inc(current, "patch")

    return modPush(tim, `/tmp/timoni/`, imageUrl, next, token)
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

function modPush(
  ctr: Container,
  path: string,
  url: string,
  version: string,
  token?: string,
) {
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
