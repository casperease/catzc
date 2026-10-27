# pwsh/Tooling.Provisioning/private/Find-ShadowingCommand.ps1

Finds the file a GUI app such as VS Code would run for a command name, by the PATH order it builds: the machine entries first, then the
user's.

## help

### synopsis

Returns the full path of the first file the machine-then-user PATH resolves a command to, or `$null`.

### description

Walks the machine PATH entries and then the user's, expanding each, and tries the bare name and every PATHEXT extension in each folder; the
first file that exists wins. Off Windows a process PATH is not built from a machine and a user part, so nothing shadows by order and it
returns `$null`.

### parameter `Command`

The command name, without an extension.

### outputs

`[string]` the full path of the file found, or `$null`.
