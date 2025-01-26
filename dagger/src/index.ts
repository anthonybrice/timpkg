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

  @func()
  async publishModuleFromTag(dir: Directory, tag: string, password?: string): Promise<string> {
    let [module, version] = tag.replace(/^refs\/tags\//, '').split('@')
    version = version.replace(/^v/, '')

    return this.pushDir(dir.directory(`modules/${module}`), version, password);
  }

  /**
   * Publish all modules in the directory to the container registry.
   */
  @func()
  async pushDirs(dir: Directory, password?: string): Promise<string> {
    const modules = await dir.entries()

    const results = await Promise.all(
      modules.map((m) => this.pushDir(dir.directory(m), password)),
    )

    return results.join("\n")
  }

  /**
   * Publish module at directory to the container registry.
   */
  @func()
  async pushDir(dir: Directory, version?: string, password?: string): Promise<string> {
    let tim = timoni()
      .withDirectory("/tmp/timoni", dir)
    if (password)
      tim = tim
        .withExec([
          "timoni",
          "registry",
          "login",
          "--username=antbrice1_publicis",
          `--password=${password}`,
          "ghcr.io"
        ])

    const moduleName = (await dir.file("cue.mod/module.cue").contents())
      .split("\n")[0]
      .split("/")
      .slice(1)[0]
      .replace(/[^a-z0-9]+$/i, "")

    const realModuleUrl = `oci://ghcr.io/anthonybrice/modules/${moduleName}`
    const imageUrl = this.isDev ? `oci://ttl.sh/${v4()}` : realModuleUrl

    if (!version) {
      const versions = (await modList(tim, realModuleUrl))
        .split("\n")
        .slice(1)
        .map((x) => semver.coerce(x))
      const current = maxSatisfying(versions, "*")
      version = inc(current, "patch")
    }


    return modPush(tim, "/tmp/timoni/", imageUrl, version)
  }
}

function timoni() {
  return dag
    .container()
    .from("golang:latest")
    .withExec([
      "go",
      "install",
      "github.com/stefanprodan/timoni/cmd/timoni@v0.23.0",
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
