# pwsh/Tooling.Claude/private/Get-ClaudeDroneLaunch.ps1

The private helper of `Start-ClaudeDrone` that turns one drone's settings into the file path, argument list and command line of a terminal
launch. It starts nothing itself, so the caller can print the plan under `-DryRun`.

## Quoting

Each value of the `claude --agent` call is single-quoted for pwsh, a single quote doubled, so a prompt keeps its spaces and quotes. The
whole call then becomes one double-quoted argument for the outer command line, its own double quotes escaped. The windows-terminal form
also escapes each semicolon, because `wt.exe` reads an unescaped one as the start of its next command.

## help

### synopsis

Builds one drone launch: the file path, the argument list and the command line that start `claude --agent` in a terminal.

### description

Every value of the claude call is single-quoted for pwsh, so a prompt keeps its spaces and quotes. The windows-terminal launcher wraps the
call in `wt.exe -d <directory> new-tab`, escaping each semicolon, which wt reads as the start of its next command; the pwsh launcher runs it
in a `pwsh -NoExit` window.

### parameter `Agent`

The agent the session starts as.

### parameter `Model`

The model to pass with `--model`; none when omitted.

### parameter `Prompt`

The session's first prompt; none when omitted.

### parameter `Launcher`

The terminal: windows-terminal or pwsh.

### parameter `WorkingDirectory`

The directory the session starts in.

### parameter `Index`

The launch's number, which titles a windows-terminal tab.

### outputs

`[pscustomobject]` with Index, Agent, Model, Launcher, FilePath, ArgumentList, WorkingDirectory and CommandLine.
