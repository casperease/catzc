# pwsh/Tooling.Core/private/Resolve-SessionToolHost.ps1

The private resolver that points the session at the best install home of a tool declared with `session_host_probes`, for a tool installed
more than once on one machine. It moves the chosen home to the front of the session PATH and changes nothing else.

## help

### synopsis

Points the current session at the best install home of a tool, chosen by its session_host_probes.

### description

Some tools can be installed more than once on one machine, and the first one on PATH is not always usable — on Windows a machine-wide,
runtime-only C:\Program Files\dotnet precedes the user PATH and shadows the managed SDK. When tools.yml gives the tool
`session_host_probes`, this considers every candidate home in order — the installer layer's own home first (Get-ScriptInstallDir, for a
script-installed tool), then the directory of every PATH match — and takes the FIRST probe that ANY home satisfies (Test-ToolHomeProbe): for
dotnet an SDK at the locked version, else a runtime at the locked version. The chosen home moves to the front of
$env:PATH for THIS session only, announced on the information stream because it changes what the
session runs. No other install is removed and the registry PATH is never written. Returns the resolved
command, or $null
when the tool declares no probes or no home satisfies any of them (PATH is then left exactly as it was). Filesystem checks only — no process
is started.

### parameter `Config`

The tool's ToolConfig (from Get-ToolConfig).

## First match

The command may still resolve in more than one PATH directory, so the lookup takes the first: an array's `.Source` would break the
`[string]` `-Location` binding downstream.
