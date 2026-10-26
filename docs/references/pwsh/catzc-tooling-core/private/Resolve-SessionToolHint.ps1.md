# pwsh/Tooling.Core/private/Resolve-SessionToolHint.ps1

The private resolver that points the session at a tool installed outside the installer layer, using the `session_path_hints` of `tools.yml`.
It changes the session PATH only and returns the resolved command.

## help

### synopsis

Points the current session at a tool installed outside the installer layer, using its declared hints.

### description

When a configured tool is not resolvable on PATH but tools.yml gives it session_path_hints (e.g. node's nvm-for-windows symlink
%ProgramFiles%\nodejs), this appends the first hint directory that actually contains the command to
$env:PATH for THIS session only, then returns the resolved command. Session-only,
never persistent — the installer layer owns the registry PATH. Returns $null
when the tool has no hints or none resolve.

### parameter `Config`

The tool's ToolConfig (from Get-ToolConfig).

## Which directory

A hint directory counts when the command actually lives in it. The probe tries the bare name plus the Windows executable extensions;
`PATHEXT` is empty on Unix, so only the bare name is probed there.

## Appending

The directory is appended to PATH for this session. A hint only fires when the command is otherwise unresolvable, so nothing conflicts, and
appending keeps a hint directory that also holds a `python.exe`, such as an az uv-venv Scripts directory, from shadowing the managed
`python` on `~/.local/bin`.

## First match

The command may now resolve in more than one PATH directory, so the lookup takes the first: an array's `.Source` would break the `[string]`
`-Location` binding downstream.
