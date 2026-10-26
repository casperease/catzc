# pwsh/Base.Execution/configs/tools.yml

The tool lock file: one entry per managed tool, with the version the repository pins, how to detect it and how each platform installs it.
`Get-Config -Config tools` reads it into the typed `ToolsConfig`, whose entries are `ToolConfig` records that reject unknown keys; the
types' pages describe each key. This page holds the reasons behind the values a reader would otherwise have to dig out.

## winget

The OS-provided Windows App Installer, asserted and kept on PATH, never installed by the toolchain (`system_provided`). It is the
install-time prerequisite for the winget-based tools (`node_js`, `java`, `terraform`, and uv's bootstrap). Its hint lets `Sync-SessionTools`
recover it when `%LOCALAPPDATA%\Microsoft\WindowsApps` drops off PATH.

## bash

Bash 5, platform-provided: asserted, never installed by the toolchain, so it has no Install and Uninstall pair. Linux ships it as
`/bin/bash`. On Windows it is Git Bash from Git for Windows, which `Install-Git` (`Catzc.Tooling.Provisioning`) provides in user space.
macOS ships bash 3.2 as `/bin/bash`, so a Mac devbox needs brew's bash 5 (`brew install bash`), which the candidates find first.

The tool is located by candidate paths (no process start), then PATH, never by the bare name alone: on Windows `bash` on PATH is usually the
WSL launcher, which `probe_excludes` rules out. A devbox prefers a user-scope Git for Windows (winget's `--scope user` home, then
`Install-Git`'s PortableGit home) over the machine-wide one, and a pipeline reads the hosted-agent locations.

## zsh

zsh 5 is the third execution engine ([ADR-AUTO-ENGINE](../../../../drs/automation/execution-engines.md)) and the checker of the repository's
`*.zsh` scripts (`Test-ShellScripts` runs `zsh -n`,
[ADR-AUTO-BASH-SHELLSCRIPTSCHECKED](../../../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-shellscriptschecked)).

- **Windows.** `Install-Zsh` installs the MSYS2 zsh package pinned in the entry, verified against its SHA-256 before anything is extracted,
  into the Git for Windows tree `Install-Git` provides (`windows_install_dir: %LOCALAPPDATA%\Git`), in user space. It runs on Git Bash's own
  MSYS2 runtime. `Install-Git -Force` replaces that tree, so `Install-Zsh` runs after it, and `depends_on: bash` orders it there.
- **macOS.** zsh ships as `/bin/zsh`, which `Install-Zsh` asserts.
- **Linux.** The distribution's package named by `apt_package`, which `Install-Zsh` installs through `Install-Tool` (apt-get) when zsh is
  missing and which needs root. `Get-ToolsStatus` reports it under apt.

Candidates are probed first, then PATH, since `Install-Zsh` leaves PATH alone. A devbox prefers `Install-Zsh`'s home in `Install-Git`'s
tree, then a user-scope winget Git for Windows, and a pipeline reads the hosted-agent locations.

## python

The pin is 3.13, not the latest (3.14): the repository stays one release behind the bleeding edge so dependents that lag the newest Python
still work. The `az_cli` venv runs on this interpreter and azure-cli supports only up to 3.13, so the `max_python` gate on `az_cli`
(enforced by `ToolsConfig`) fails the build if the pin is bumped past what a dependent allows.

uv provisions it (`uv python install <version> --default`) in user space on every platform, installing a global `python` and `python3` shim
into uv's bin (`~/.local/bin`). `depends_on: uv` puts uv in place first.

## dotnet

Installed through the vendored install scripts, with no package manager and no admin. The install directory defaults to
`LOCALAPPDATA\<command>` on Windows and `HOME/.<command>` on Unix, and `windows_install_dir` or `unix_install_dir` override it per platform.

`session_host_probes` decides which dotnet home this session runs when several exist: the managed home, then every PATH directory holding
dotnet (on Windows a machine-wide `C:\Program Files\dotnet` precedes the user PATH). An SDK at the locked version wins first, else a runtime
at the locked version, and a runtime-only or off-version host never wins.

## az_cli

- **`devbox_version`** is a local-only relaxation. Outside a CI pipeline, `Assert-ToolVersion` also accepts an installed az whose version
  starts with this prefix, so a devbox can run a functional off-pin az for local pre-commit tooling without an immediate upgrade. A pipeline
  session (`Test-IsRunningInPipeline`: `TF_BUILD` or `GITHUB_ACTIONS`) ignores it and enforces `version` alone, so main and master builds
  stay deterministically locked. It is a team-tuned balancing lever, not a second pin; raise it toward `version` once devbox upgrades land.
- **Install.** It goes into a dedicated uv venv (`uv venv` plus `uv pip install azure-cli`), with no admin on any platform. az's own
  launcher (`az.bat`) runs the `python.exe` sitting next to it, so it must live in a venv with its own interpreter; a `uv tool` shim in
  `~/.local/bin` would instead grab uv's `--default` python, which has no azure. `depends_on: uv` provisions uv first.
- **`max_python: "3.13"`** records that azure-cli 2.87 supports Python only up to 3.13. Its venv runs on the toolchain's `python` pin, so
  this caps how far Python may be bumped.

## poetry

Installed in user space through uv (`uv tool install poetry`) in an isolated env with uv's own Python, so it depends on `uv`, not on
`python`, which uv brings itself.

## node_js

Node 24 is the current LTS. winget has no versioned `OpenJS.NodeJS.24`, since its versioned packages stop at 23, so the entry uses the
`OpenJS.NodeJS.LTS` alias, currently 24.x. The alias moves with each LTS: when the LTS advances past 24, bump `version` to match (and
revisit brew's `node@24`), or the installed version fails the pin.

On Linux the distribution's `nodejs` package lags the pin badly (Ubuntu jammy ships Node 12), so `Install-NodeJs` configures the NodeSource
apt repository for the locked major inline, as `Install-Terraform` does for HashiCorp, and then installs `apt_package`, which stays the
package name that uninstall, status and the expected manager use.

`linux_admin_only` is set because apt-get needs root while the Windows (winget `--scope user`) and macOS (brew) installs are user space. The
elevation requirement is therefore Linux-only (`Test-ToolRequiresElevation`), and a non-elevated Linux provision skips and reports it
instead of failing the whole run. nvm-for-windows exposes the active node through the symlink under `%ProgramFiles%\nodejs`, which the
janitor points the session at when winget node is absent, so an nvm devbox keeps a working `node` and its shims on PATH.

## markdownlint

`markdownlint-cli2 --version` prints a banner (`markdownlint-cli2 v0.22.1 (markdownlint v0.40.0)`), so the pattern captures the digits after
the first `v` (`Get-ToolVersion` matches unanchored).

## typescript

The TypeScript compiler is the js track's types check (`Test-JavaScriptTypes`). It and the type declarations it checks against are each
installed by `Install-TypeScript` into npm's global root, which the generated `jsconfig.json` names as its type roots; nothing lands in the
repository.

## terraform

On Linux the HashiCorp apt repository must be configured first, which `Install-Terraform` does inline. That inline apt path needs root,
while the Windows (winget `--scope user`) and macOS (brew) installs are user space, hence `linux_admin_only`.

## java

`Microsoft.OpenJDK.25` ships only a machine-scope (wix) installer. There is no user-scope installer, so a `--scope user` install finds none.
It installs machine-scope and therefore requires Administrator (`admin_only`), and the provisioning loops skip and report it when not
elevated.

## go

Go 1.27 is the current stable minor, and `Install-Go` takes its newest patch. Go in this repository is test artifacts only
(`<root>/tests/<module>/`, the root `go/` or `.go/` per `go.yml`), and it never ships.

`Install-Go` installs from the official go.dev archive, verified against the SHA-256 the go.dev release feed publishes, into a user-space
home: no package manager, no admin, the same on every platform. The home is the script-install default (Windows `%LOCALAPPDATA%\go`, Unix
`~/.go`), kept apart from `GOPATH` (`~/go`). The tool is located by the managed home's binary first, then PATH. A pipeline declares no
candidates: its Go comes from the hosted agent's tool cache, which the native Go task puts on PATH.

## shellcheck

ShellCheck 0.11 is the analyzer for the repository's shell scripts (`*.sh`, the `importer.sh` dispatcher), run by the `Test-ShellScripts`
quality gate ([ADR-AUTO-ENGINE](../../../../drs/automation/execution-engines.md): bash scripts take the checks that read them).

- **Windows.** winget `koalaman.shellcheck` as a user-scope portable, with no admin. It lands in its package folder, which winget adds to
  the user PATH; that folder is probed first, so a fresh install is found before the shell is restarted.
- **macOS.** brew.
- **Linux.** The distribution's package, which needs root (`Install-Shellcheck`).

## bicep

The Bicep CLI 0.48 is the bicep formatter engine `Format-Code` runs over the infrastructure templates (`bicep format`, `languages.yml`).
`bicep format` writes LF on every platform, so its output does not depend on the machine.

- **Windows.** winget `Microsoft.Bicep` as a user-scope portable, with no admin. The package folder is probed first, as for shellcheck.
- **macOS.** brew, from Microsoft's tap.
- **Linux.** There is no distribution package, so `Install-Bicep` installs the release binary for the machine's architecture into
  `~/.local/bin`, verified against the SHA-256 GitHub publishes for it, with no root.

## uv

Astral's uv is the standard Python handler: it provisions Python and runs Python-based CLIs in isolated environments, in user space
everywhere. Windows uses winget `astral-sh.uv` (a portable zip, user scope, no admin) and macOS uses brew. Linux uses Astral's standalone
installer (user space, `~/.local/bin`), not the generic apt path.

## py_spark

PySpark is installed with `uv pip install --python <pin> pyspark` into the uv-managed Python, so it stays importable; `depends_on: python`
orders the install. Its `pyspark` launcher lives inside the package, not as an exe on PATH, so presence is verified by the import-metadata
version probe and not by `Assert-Command`. That probe reads the version from package metadata (`importlib.metadata`, standard library since
3.8) and never imports `pyspark`, which would spin up the JVM gateway.

Its runtime needs Java, which is `admin_only`, so PySpark is provisioned in the same elevated run as Java, and the non-elevated provision
skips and reports it rather than installing a runtime that cannot start.
