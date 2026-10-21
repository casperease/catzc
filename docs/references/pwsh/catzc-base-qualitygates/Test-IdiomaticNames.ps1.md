# pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every tracked file and the folders that hold it are named in the idiom of the file's language.

### description

Judges every tracked file of a language that has a `naming:` entry in the languages config (Catzc.Base.Languages configs/languages.yml): its
file name, without its extension, against the language's file cases, and every folder on its path against the language's folder cases
([ADR-AUTO-IDIOM-LANGUAGEIDIOM](../../../adr/automation/idiomatic-names.md#rule-adr-auto-idiom-languageidiom)). Files under an exempt folder
(`naming.exempt_folders`) and the files a language lists as `exempt` keep their source's names. A misnamed folder is one issue per language,
a misnamed file one issue: '`<folder>/`: the folder is not `<case>` (`<language>`)' or '`<file>`: the file name is not `<case>`
(`<language>`)'.

"Tracked" means in the git index (`Get-GitTrackedPath`), so a new file counts only once it is staged; an unstaged new file is not judged,
and the gate stays green over it.

Ends with Write-QualityGateReport: the report lands in out/test-idiomatic-names/, and the gate throws once listing every issue (or returns
the result with -PassThru). Needs the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-idiomatic-names).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-IdiomaticNames
```

### example 2

```powershell
(Test-IdiomaticNames -PassThru).Issues
```
