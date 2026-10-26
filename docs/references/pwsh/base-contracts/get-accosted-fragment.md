# pwsh/Base.Contracts/Get-AccostedFragment.ps1

The renderer that turns an accosted file into the PowerShell text an article shows. It reads through the one reader, so a rendered command
is always a checked one.

## help

### synopsis

Renders the commands of an accosted file as a PowerShell fragment for an article, through the one reader.

### description

The file is read and checked by Get-AccostedFile, the one reader
([ADR-AUTO-ACCOSTED-ONEREADER](../../../drs/automation/accosted-language.md#rule-adr-auto-accosted-onereader)), and each command is written
the way the pwsh engine runs it (ConvertTo-AccostedCallText), so the text in an article is a rendering of the contract form and never
hand-written. One line per command, `Get-FileLanguage -Path 'README.md'`; the commands of a run stay together and a blank line separates
runs. Without -RunNumber every run is rendered, with -RunNumber one run, with -RunNumber and -CommandNumber one command.

### parameter `Path`

The accosted file, repository-relative or rooted.

### parameter `RunNumber`

The 1-based run to render. Default: every run.

### parameter `CommandNumber`

The 1-based command of that run to render. Needs -RunNumber. Default: every command of the run.

### parameter `RepositoryRoot`

The root a relative path and the command contracts resolve against. Default: the repository root.

### outputs

`[string]` The PowerShell fragment.

### example 1

```powershell
Get-AccostedFragment -Path pwsh/Base.Contracts/accosted/contracts.accosted.yml -RunNumber 3
```
