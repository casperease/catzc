# pwsh/.scriptanalyzer/NoRawVsoCommand.psm1

The custom analyzer check `Measure-NoRawVsoCommand`: raw `##vso[task.…]` logging commands are forbidden.

## Why

A raw logging command is error-prone (silent name rewrites, forgotten flags), so one validating setter emits it.

## The pattern

The check matches `##vso[task.` with optional whitespace around the bracket, such as `##vso[task.setvariable …]` or
`##vso[task.logissue …]`.
