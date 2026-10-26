# pwsh/Base.Git/types/GitFlowConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public string UserCommandIn(string commandLine)`, written with `//`.

```text
The first user command a shell command line invokes, or null: a name counts only as a word of its own, so a path or file name
that holds it (tests/Sync-Topic.Tests.ps1) is no invocation.
```

## comment:2

Above `public string UserCommandIn(string commandLine)`, written with `//`.

```text
The user command a command line invokes: a name in command position, in the shell or in a pwsh -Command script; a mention in a quoted
argument, a heredoc body or a printf argument is no invocation.
```
