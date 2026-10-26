# pwsh/Base.Execution/configs/tools.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `system_provided: true`, written with `#`.

```text
OS-provided (Windows App Installer) — asserted and kept on PATH, never installed by the toolchain. It is
the install-time prerequisite for the winget-based tools (node_js, java, terraform, and uv's bootstrap).
The hint lets Sync-SessionTools recover it when %LOCALAPPDATA%\Microsoft\WindowsApps drops off PATH.
```

## comment:2

Above `version: "5"`, written with `#`.

```text
Bash 5. Platform-provided — asserted, never installed by the toolchain, so it has no Install-/Uninstall- pair:
Linux ships it as /bin/bash; on Windows it is Git Bash from Git for Windows, which Install-Git
(Catzc.Tooling.Provisioning) provides user-space. macOS ships bash 3.2 as /bin/bash, so a Mac devbox needs
brew's bash 5 (`brew install bash`), which the candidates below find first.
```

## comment:3

Above `windows_probes:`, written with `#`.

```text
Located by these candidate paths (no process start), then PATH — never by the bare name alone: on Windows
`bash` on PATH is usually the WSL launcher, which probe_excludes rules out. A devbox prefers a user-scope Git
for Windows (winget's --scope user home, then Install-Git's PortableGit home) over the machine-wide one; a
pipeline reads the hosted-agent locations.
```

## comment:4

Above `version: "5"` (occurrence 2), written with `#`.

```text
zsh 5 — the third execution engine ([ADR-AUTO-ENGINE](/docs/drs/automation/execution-engines.md)) and the checker of
the repository's *.zsh scripts (Test-ShellScripts runs `zsh -n`,
[ADR-AUTO-BASH-SHELLSCRIPTSCHECKED](/docs/drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-shellscriptschecked)).
```

## comment:5

Above `depends_on: bash`, written with `#`.

```text
Windows: Install-Zsh installs the MSYS2 zsh package pinned below, verified against its SHA-256 before anything is
extracted, into the Git for Windows tree Install-Git provides (windows_install_dir: %LOCALAPPDATA%\Git), user-space;
it runs on Git Bash's own MSYS2 runtime. Install-Git -Force replaces that tree, so Install-Zsh runs after it, and
depends_on bash (Git Bash) orders it there. macOS ships zsh as /bin/zsh, which Install-Zsh asserts. Linux: the
distribution's package named by apt_package, which Install-Zsh installs through Install-Tool (apt-get) when zsh is
missing and which needs root; Get-ToolsStatus reports it under apt.
```

## comment:6

Above `windows_probes:` (occurrence 2), written with `#`.

```text
Located by these candidate paths (no process start), then PATH: Install-Zsh leaves PATH alone. A devbox prefers
Install-Zsh's home in Install-Git's tree, then a user-scope winget Git for Windows; a pipeline reads the hosted-agent
locations.
```

## comment:7

Above `version: "3.13"`, written with `#`.

```text
3.13, not the latest (3.14): stay one release behind the bleeding edge so dependents that lag the newest
Python still work. The az_cli venv runs on this interpreter and azure-cli supports only up to 3.13 — the
max_python gate on az_cli (the ToolsConfig type) fails the build if this is bumped past what a dependent allows.
```

## comment:8

Above `depends_on: uv`, written with `#`.

```text
Provisioned by uv (`uv python install <version> --default`) — user-space, cross-platform, installing a
global python/python3 shim into uv's bin (~/.local/bin). depends_on uv so uv is present first.
```

## comment:9

Above `script_install: true`, written with `#`.

```text
Installed via vendored install scripts — no package manager, no admin.
Install dir defaults: Windows = LOCALAPPDATA\<command>, Unix = HOME/.<command>.
Override per platform with windows_install_dir / unix_install_dir if needed.
```

## comment:10

Above `session_host_probes:`, written with `#`.

```text
Which dotnet home this session runs when several exist (the managed home, then every PATH dir holding
dotnet — on Windows a machine-wide C:\Program Files\dotnet precedes the user PATH): an SDK at the locked
version first, else a runtime at the locked version. A runtime-only or off-version host never wins.
```

## comment:11

Above `devbox_version: "2.84"`, written with `#`.

```text
Devbox lever (local-only version relaxation). OUTSIDE a CI pipeline, Assert-ToolVersion also accepts an
installed az whose version starts with this prefix — so a devbox can run a functional off-pin az for local
pre-commit tooling without an immediate upgrade. A pipeline session (Test-IsRunningInPipeline: TF_BUILD /
GITHUB_ACTIONS) IGNORES this and enforces `version` alone, so main/master builds stay deterministically
locked. This is a team-tuned balancing lever, not a second pin — raise it toward `version` once devbox upgrades land.
```

## comment:12

Above `depends_on: uv` (occurrence 2), written with `#`.

```text
Installed user-space into a DEDICATED uv venv (uv venv + uv pip install azure-cli) — no admin on any
platform. az's own launcher (az.bat) runs the python.exe sitting next to it, so it must live in a venv with
its own interpreter; a `uv tool` shim in ~/.local/bin would instead grab uv's --default python (no azure).
depends_on uv so uv is provisioned first.
```

## comment:13

Above `max_python: "3.13"`, written with `#`.

```text
azure-cli 2.87 supports Python only up to 3.13. Its venv runs on the toolchain's `python` pin, so this caps
how far Python may be bumped — the ToolsConfig type fails the build if python's version exceeds this.
```

## comment:14

Above `depends_on: uv` (occurrence 3), written with `#`.

```text
Installed user-space via uv (`uv tool install poetry`) in an isolated env with uv's own Python —
depends_on uv (not python), which uv brings itself.
```

## comment:15

Above `version: "24"`, written with `#`.

```text
Node 24 (current LTS). winget has no versioned OpenJS.NodeJS.24 — its versioned packages stop at 23 — so
this uses the OpenJS.NodeJS.LTS alias, currently 24.x. That alias MOVES with each LTS: when the LTS advances
past 24, bump `version` to match (and revisit brew's node@24), or the installed version fails the pin.
```

## comment:16

Above `apt_package: "nodejs"`, written with `#`.

```text
Linux: the distro `nodejs` package lags the pin badly (Ubuntu jammy ships Node 12), so Install-NodeJs
configures the NodeSource apt repo for the locked major inline (as Install-Terraform does for HashiCorp)
and then installs this package. `apt_package` stays the package name uninstall/status/expected-manager use.
```

## comment:17

Above `linux_admin_only: true` (occurrence 2), written with `#`.

```text
apt-get needs root; the Windows (winget --scope user) and macOS (brew) installs are user-space, so the
elevation requirement is Linux-only (Test-ToolRequiresElevation) — a non-elevated Linux provision skips
and reports it instead of failing the whole run.
```

## comment:18

Above `session_path_hints:` (occurrence 3), written with `#`.

```text
nvm-for-windows exposes the active node via this symlink; the janitor points the session at it when
winget node is absent, so an nvm devbox keeps a working `node` (and node-based shims) on PATH.
```

## comment:19

Above `version_command: "markdownlint-cli2 --version"`, written with `#`.

```text
markdownlint-cli2 --version prints a banner ("markdownlint-cli2 v0.22.1 (markdownlint v0.40.0)"),
so the pattern captures the digits after the first 'v' (Get-ToolVersion matches unanchored).
```

## comment:20

Above `linux_admin_only: true` (occurrence 3), written with `#`.

```text
Linux: HashiCorp apt repo must be configured first.
Install-Terraform handles this inline. That inline apt path needs root, while the Windows
(winget --scope user) and macOS (brew) installs are user-space — Linux-only elevation.
```

## comment:21

Above `admin_only: true`, written with `#`.

```text
Microsoft.OpenJDK.25 ships only a machine-scope (wix) installer — there is no user-scope installer, so a
`--scope user` install finds none. It installs machine-scope and therefore requires Administrator; the
provisioning loops skip and report it when not elevated.
```

## comment:22

Above `version: "1.27"`, written with `#`.

```text
Go 1.27, the current stable minor; Install-Go takes its newest patch. Go in this repository is test artifacts
only (<root>/tests/<module>/, the root go/ or .go/ per go.yml), and it never ships.
```

## comment:23

Above `script_install: true` (occurrence 2), written with `#`.

```text
Installed by Install-Go from the official go.dev archive, verified against the SHA-256 the go.dev release feed
publishes, into a user-space home: no package manager, no admin, the same on every platform. The home is the
script-install default — Windows %LOCALAPPDATA%\go, Unix ~/.go — kept apart from GOPATH (~/go).
```

## comment:24

Above `windows_probes:` (occurrence 3), written with `#`.

```text
Located by the managed home's binary first, then PATH. A pipeline declares no candidates: its Go comes from
the hosted agent's tool cache, which the native Go task puts on PATH.
```

## comment:25

Above `version: "0.11"`, written with `#`.

```text
ShellCheck 0.11 — the analyzer for the repository's shell scripts (*.sh, the importer.sh dispatcher), run by the
Test-ShellScripts quality gate
([ADR-AUTO-ENGINE](/docs/drs/automation/execution-engines.md): bash scripts take the checks that read them). Windows: winget
koalaman.shellcheck as a user-scope portable (no admin). macOS: brew. Linux: the distribution's package, which needs
root (Install-Shellcheck).
```

## comment:26

Above `windows_probes:` (occurrence 4), written with `#`.

```text
The user-scope winget portable lands in its package folder, which winget adds to the user PATH; probed first, so a
fresh install is found before the shell is restarted.
```

## comment:27

Above `version: "0.48"`, written with `#`.

```text
The Bicep CLI 0.48 — the bicep formatter engine Format-Code runs over the infrastructure templates (`bicep format`,
languages.yml). Windows: winget Microsoft.Bicep as a user-scope portable (no admin). macOS: brew, from
Microsoft's tap. Linux has no distribution package: Install-Bicep installs the release binary for the machine's
architecture into ~/.local/bin, verified against the SHA-256 GitHub publishes for it (no root). `bicep format`
writes LF on every platform, so its output does not depend on the machine.
```

## comment:28

Above `windows_probes:` (occurrence 5), written with `#`.

```text
The user-scope winget portable lands in its package folder, which winget adds to the user PATH; probed first, so a
fresh install is found before the shell is restarted.
```

## comment:29

Above `winget_id: "astral-sh.uv"`, written with `#`.

```text
Astral's uv — the standard Python handler: it provisions Python and runs Python-based CLIs in isolated
environments. Windows: winget astral-sh.uv (portable zip → user scope, no admin). macOS: brew. User-space
everywhere. Linux uses Astral's standalone installer (user-space, ~/.local/bin) — not the generic apt path.
```

## comment:30

Above `depends_on: python`, written with `#`.

```text
Installed with `uv pip install --python <pin> pyspark` INTO the uv-managed Python, so it stays importable;
depends_on python for install ordering. Its `pyspark` launcher lives inside the package (not a PATH exe),
so presence is verified by the import-metadata version probe, not Assert-Command.
```

## comment:31

Above `admin_only: true` (occurrence 2), written with `#`.

```text
Runtime needs Java, which is admin_only — so PySpark is provisioned in the same elevated run as Java, and
the non-elevated provision skips and reports it rather than installing a runtime that cannot start.
```

## comment:32

Above `version_command: 'python -c "from importlib.metadata import version;...`, written with `#`.

```text
Read the version from package metadata — no heavy `import pyspark` (which spins up the JVM gateway),
just the installed dist-info. importlib.metadata is stdlib since 3.8.
```

## comment:33

Above `typescript:`, written with `#`.

```text
The TypeScript compiler, the js track's types gate (Test-JavaScriptTypes), and the type declarations it checks against, each installed by
Install-TypeScript into npm's global root, which the generated jsconfig.json names as its type roots; nothing lands in the repository.
```
