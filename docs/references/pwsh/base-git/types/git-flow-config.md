# pwsh/Base.Git/types/GitFlowConfig.cs

The typed record of the git topic flow's settings, including the finder of the flow's user commands in a shell command line.

## UserCommandIn

`UserCommandIn(commandLine)` returns the first user command a shell command line invokes, or null. A name counts only as a word of its own
and in command position, in the shell or in a `pwsh -Command` script: a path or file name that holds it (`tests/Sync-Topic.Tests.ps1`) is no
invocation, and neither is a mention in a quoted argument, a heredoc body or a printf argument.
