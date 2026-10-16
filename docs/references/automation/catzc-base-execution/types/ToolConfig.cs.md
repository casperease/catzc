---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "85598377da57"
    adrs:
      - ADR-AUTO-DEPS#1
      - ADR-AUTO-PKGMGR#6
---

# automation/Catzc.Base.Execution/types/ToolConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One tool's locked definition from configs/tools.yml — its required version, how to detect it, and the
per-manager install metadata for each platform. Mirrors a tools.yml entry (snake_case keys); each tool
carries only the install metadata its supported platforms need, so most fields are optional. ToolsConfig
builds one per entry and prefixes every violation with the tool's name.

Constructing an instance validates the entry, collecting every violation into one ArgumentException:
  - only the known keys below (an unknown key would be silently invisible to every caller);
  - version, command, version_command and version_pattern are required
    ([ADR-AUTO-DEPS#1](/docs/adr/automation/controlling-systemwide-deps.md#rule-adr-auto-deps1));
  - version_pattern captures the version as the named group (?<ver>...);
  - every session_host_probes entry ends with the {version} segment;
  - msys2_url and msys2_sha256 are declared together or not at all, and msys2_sha256 is 64 lowercase hex
    digits ([ADR-AUTO-PKGMGR#6](/docs/adr/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr6)).

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties and its constructor uses the base's OptStr/StrArr/Flag extraction helpers.
```

## comment:2

Above `public string devbox_version { get; }`, written with `//`.

```text
Devbox lever: outside a CI pipeline, an installed version starting with this prefix is also accepted
(Assert-ToolVersion, Test-Tool). A pipeline ignores it and enforces `version` alone. Null when the tool has
no lever.
```

## comment:3

Above `public string uv_tool { get; }`, written with `//`.

```text
uv tool/package name — installed with `uv tool install <uv_tool>` into an isolated env (e.g. az_cli,
poetry). Null when uv-tool is not an install path.
```

## comment:4

Above `public bool uv_allow_prerelease { get; }`, written with `//`.

```text
True to pass `--prerelease=allow` to the uv install — needed when the package's dependency tree pins a
pre-release (e.g. azure-cli depends on an azure-batch beta), which uv otherwise refuses.
```

## comment:5

Above `public string uv_venv { get; }`, written with `//`.

```text
pip package installed into a DEDICATED uv venv (not the shared managed Python, not an isolated uv tool).
For CLIs whose own launcher expects python.exe adjacent to it (azure-cli's az.bat), which a uv-tool shim
in ~/.local/bin breaks. Null when venv install is not the path.
```

## comment:6

Above `public string max_python { get; }`, written with `//`.

```text
Highest Python version this tool supports (runs under). ToolsConfig rejects a toolchain whose python pin
exceeds it — keeping Python off a bleeding-edge release a dependent cannot use.
```

## comment:7

Above `public bool system_provided { get; }`, written with `//`.

```text
True when the tool is provided by the operating system (e.g. winget/App Installer on Windows). The
toolchain asserts it and keeps it on PATH via session_path_hints, but never installs it.
```

## comment:8

Above `public bool admin_only { get; }`, written with `//`.

```text
True when the tool has only a machine-scope installer, so installing it requires Administrator. Install
asserts elevation; the provisioning loops skip and report it when not elevated.
```

## comment:9

Above `public bool linux_admin_only { get; }`, written with `//`.

```text
True when only the Linux install needs root (apt-get), while the Windows and macOS installs are user-space.
Test-ToolRequiresElevation honours it only on Linux.
```

## comment:10

Above `public string msys2_url { get; }`, written with `//`.

```text
The MSYS2 package installed on Windows into the Git for Windows tree, so the tool runs on Git Bash's own MSYS2
runtime: its download URL, and the SHA-256 the download is verified against before anything is extracted. On
other platforms an msys2 tool takes the manager its entry declares there (apt_package on Linux); with none it is
the system's, asserted and never installed. Null when MSYS2 is not an install
path; the two are declared together.
```

## comment:11

Above `public string windows_install_dir { get; }`, written with `//`.

```text
The install directory on Windows, relative to LOCALAPPDATA (Get-ScriptInstallDir): a script-installed tool's
home, or the tree an msys2 tool installs into. Null when not applicable.
```

## comment:12

Above `public string depends_on { get; }`, written with `//`.

```text
The name of a tool that must be installed first. Null when the tool has no prerequisite. ToolsConfig checks
it names a declared tool.
```

## comment:13

Above `public string[] session_path_hints { get; }`, written with `//`.

```text
Extra directories the session janitor (Sync-SessionTools) prepends to PATH to point THIS session at
a tool installed outside the installer layer (e.g. nvm-managed node under %ProgramFiles%\nodejs) when
it is otherwise unresolvable. Environment variables are expanded. Empty when the tool has no hints.
```

## comment:14

Above `public string[] session_host_probes { get; }`, written with `//`.

```text
Ordered probes the session janitor (Sync-SessionTools) uses to pick WHICH install home of the command this
session runs, when several exist (the managed home, then every PATH directory holding the command). Each
probe is a path relative to a home whose last segment carries `{version}` (replaced by the locked version):
a home satisfies it when that folder holds a directory named the version or starting with "<version>."
(dotnet: `sdk/{version}` matches sdk/10.0.201). The first probe ANY home satisfies wins — so for dotnet an
SDK at the locked version beats a runtime-only host. Empty when the tool has a single obvious install.
```

## comment:15

Above `public string[] windows_probes { get; }`, written with `//`.

```text
The candidate executable paths, in order, that locate the tool without starting a process (Test-Tool
-PassThru): each is a full path to the executable, with %VAR% environment variables expanded. The first
candidate that exists wins; when none does, PATH is searched. A devbox session (actor Person or Agent)
reads the plain list, a pipeline session (actor Pipeline) reads the pipeline list, and Windows and Unix
each have their own pair. A tool with no candidates on the running platform is located on PATH alone.
```

## comment:16

Above `public string[] probe_excludes { get; }`, written with `//`.

```text
Executable paths (%VAR% expanded) that never count as the tool, as a candidate or on PATH: for bash, the WSL
launcher %SystemRoot%\System32\bash.exe, which is not Git Bash. Empty when nothing is excluded.
```

## comment:17

Above `public bool HasProbes()`, written with `//`.

```text
True when the entry declares candidate paths or exclusions, so the tool is located by the probe (Test-Tool,
Assert-Tool) rather than by the bare command name on PATH.
```

## comment:18

Above `public bool HasInstallMechanism()`, written with `//`.

```text
True when the entry declares how the toolchain gets it: a package-manager id, script_install, a uv shape, an
MSYS2 package, or system_provided (asserted, never installed). ToolsConfig requires it of every shipped entry.
```
