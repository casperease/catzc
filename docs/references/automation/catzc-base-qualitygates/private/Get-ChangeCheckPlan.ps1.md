# automation/Catzc.Base.QualityGates/private/Get-ChangeCheckPlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Maps changed repository files to the quality gates that check them, by file language.

### description

The checks half of Test-Change's plan, read from configuration, not code
([ADR-PRIN-CONFIG](../../../../adr/principles/configure-not-program.md)): each changed file that exists is looked up in the
file-language registry (Get-FileLanguage -Path), and its language's `checks` list (languages.yml) names the gates.
Returns one entry per gate, in the order a gate first appears, each with the changed files it applies to. A file with
no file language, or whose language names no check, contributes nothing; a deleted file is skipped.

### parameter Path

The changed repo-relative, '/'-separated paths.

### parameter RepositoryRoot

The repository root the paths are relative to.

### outputs

`[pscustomobject]` { Check; Path } — Path the changed files the gate applies to, in the order given.

### example 1

```powershell
Get-ChangeCheckPlan -Path 'docs/index.md' -RepositoryRoot (Get-RepositoryRoot)
```
