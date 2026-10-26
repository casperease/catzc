# pwsh/Base.Execution/types/ToolConfig.cs

One tool's locked definition from `configs/tools.yml`: its required version, how to detect it, and the per-manager install metadata for each
platform. It mirrors a `tools.yml` entry with snake_case keys. Each tool carries only the install metadata its supported platforms need, so
most fields are optional, and `ToolsConfig` builds one per entry and prefixes every violation with the tool's name. It derives from
`Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties.

## Validation

Constructing an instance validates the entry and collects every violation into one `ArgumentException`:

- only the known keys, since an unknown key would be silently invisible to every caller;
- `version`, `command`, `version_command` and `version_pattern` are required
  ([ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS](../../../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions));
- `version_pattern` captures the version as the named group `(?<ver>...)`;
- every `session_host_probes` entry ends with the `{version}` segment;
- `msys2_url` and `msys2_sha256` are declared together or not at all, and `msys2_sha256` is 64 lowercase hex digits
  ([ADR-AUTO-PKGMGR-VERIFYDOWNLOADS](../../../../drs/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr-verifydownloads)).

## Version keys

- **`devbox_version`** — a devbox lever: outside a CI pipeline, an installed version starting with this prefix is also accepted
  (`Assert-ToolVersion`, `Test-Tool`). A pipeline ignores it and enforces `version` alone. Null when the tool has no lever.
- **`max_python`** — the highest Python version the tool runs under. `ToolsConfig` rejects a toolchain whose `python` pin exceeds it,
  keeping Python off a release a dependent cannot use.

## Install keys

- **`uv_tool`** — the uv tool or package name, installed with `uv tool install <uv_tool>` into an isolated env (`az_cli`, `poetry`).
- **`uv_allow_prerelease`** — passes `--prerelease=allow` to the uv install, needed when the package's dependency tree pins a pre-release,
  which uv otherwise refuses.
- **`uv_venv`** — a pip package installed into a dedicated uv venv, for CLIs whose own launcher expects `python.exe` adjacent to it
  (azure-cli's `az.bat`), which a uv-tool shim in `~/.local/bin` breaks.
- **`msys2_url`, `msys2_sha256`** — the MSYS2 package installed on Windows into the Git for Windows tree, so the tool runs on Git Bash's own
  MSYS2 runtime: its download URL and the SHA-256 the download is verified against before anything is extracted. On other platforms an msys2
  tool takes the manager its entry declares there (`apt_package` on Linux); with none it is the system's, asserted and never installed.
- **`windows_install_dir`** — the install directory on Windows, relative to `LOCALAPPDATA` (`Get-ScriptInstallDir`): a script-installed
  tool's home, or the tree an msys2 tool installs into.
- **`depends_on`** — the name of a tool that must be installed first; `ToolsConfig` checks it names a declared tool.
- **`system_provided`** — the operating system provides the tool (winget and App Installer on Windows). The toolchain asserts it and keeps
  it on PATH via `session_path_hints`, but never installs it.

## Elevation keys

- **`admin_only`** — the tool has only a machine-scope installer, so installing it requires Administrator. Install asserts elevation, and
  the provisioning loops skip and report it when not elevated.
- **`linux_admin_only`** — only the Linux install needs root (apt-get), while the Windows and macOS installs are user-space.
  `Test-ToolRequiresElevation` honours it only on Linux.

## Session keys

- **`session_path_hints`** — extra directories the session janitor (`Sync-SessionTools`) prepends to PATH to point this session at a tool
  installed outside the installer layer (nvm-managed node under `%ProgramFiles%\nodejs`) when it is otherwise unresolvable. Environment
  variables are expanded.
- **`session_host_probes`** — ordered probes the janitor uses to pick which install home of the command this session runs, when several
  exist (the managed home, then every PATH directory holding the command). Each probe is a path relative to a home whose last segment
  carries `{version}`, replaced by the locked version. A home satisfies it when that folder holds a directory named the version or starting
  with `<version>.` (dotnet: `sdk/{version}` matches `sdk/10.0.201`). The first probe any home satisfies wins, so for dotnet an SDK at the
  locked version beats a runtime-only host.

## Existence-check keys

- **`windows_probes`** and its pairs — the candidate executable paths, in order, that locate the tool without starting a process
  (`Test-Tool -PassThru`): each is a full path with `%VAR%` variables expanded, and the first that exists wins; when none does, PATH is
  searched. A devbox session (actor Person or Agent) reads the plain list, a pipeline session (actor Pipeline) reads the pipeline list, and
  Windows and Unix each have their own pair. A tool with no candidates on the running platform is located on PATH alone.
- **`probe_excludes`** — executable paths (`%VAR%` expanded) that never count as the tool, as a candidate or on PATH: for bash, the WSL
  launcher `%SystemRoot%\System32\bash.exe`, which is not Git Bash.

## Predicates

`HasProbes()` is true when the entry declares candidate paths or exclusions, so the tool is located by the probe (`Test-Tool`,
`Assert-Tool`) rather than by the bare command name on PATH. `HasInstallMechanism()` is true when the entry declares how the toolchain gets
it: a package-manager id, `script_install`, a uv shape, an MSYS2 package, or `system_provided`. `ToolsConfig` requires it of every shipped
entry.
