# pwsh/Catzc.Tooling.Claude/private/Get-ClaudeWorkerLaunch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds one worker launch: the file path, the argument list and the command line that start `claude --agent` in a terminal.

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
