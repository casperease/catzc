# pwsh/.scriptanalyzer/NoRawVsoCommand.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoRawVsoCommand {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid raw ##vso[task.…] logging commands.
.DESCRIPTION
    A raw logging command is error-prone (silent name rewrites, forgotten flags), so one validating setter emits it.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NoRawVsoCommand.psm1.md#comment1)
```

## comment:2

Above `$vsoPattern = '##vso\s*\[\s*task\.'`, written with `#`.

```text
Pattern for the raw logging command. Matches '##vso[task.' with optional
whitespace, e.g. ##vso[task.setvariable …] or ##vso[task.logissue …].
```
