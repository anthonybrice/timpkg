/**
 * A generated module for Timpkg functions
 *
 * This module has been generated via dagger init and serves as a reference to
 * basic module structure as you get started with Dagger.
 *
 * Two functions have been pre-created. You can modify, delete, or add to them,
 * as needed. They demonstrate usage of arguments and return types using simple
 * echo and grep commands. The functions can be called from the dagger CLI or
 * from one of the SDKs.
 *
 * The first line in this comment block is a short description line and the
 * rest is a long description with more detail on the module's purpose or usage,
 * if appropriate. All modules should have a short description.
 */

import {
  dag,
  Container,
  Directory,
  object,
  func,
  field,
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
