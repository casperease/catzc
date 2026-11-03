# pwsh/Base.Exporter/private/Get-LanguageModuleIssue.ps1

The check of a build root's language modules against the languages list its build.json records.

## help

### synopsis

Returns the issues in the language modules of a build root, one sentence each.

### description

Walks the build root once and compares it with the languages entries. It reports a folder under a language place that no entry names, an
entry whose folder is missing, and, by the form the handler recorded, what that form lacks: a source module's executables.json or file
count, a vsix module's single extension file, a binary module's binaries.json and listed binaries, a wheels module's wheels.json and listed
wheels. An unknown form is an issue too. An empty result means the root is consistent.

### parameter `BuildRoot`

The build root folder to check.

### parameter `Languages`

The languages entries of the build record, each with its path, form and handler record; null or empty means no language modules.

### outputs

`[string[]]` The issues, empty when there are none.

### example 1

```powershell
Get-LanguageModuleIssue -BuildRoot $buildRoot -Languages $build.languages
```
