# automation/Catzc.Base.QualityGates/Test-Links.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The link quality gate: fails on any off-form, dangling, or dead link or citation.

### description

Runs the same engine as Format-Links, read-only, and reports every violation: a code link not yet in canonical repository-rooted form, a
markdown link that is rooted or climbs above the repository root, a rule citation spelled `ADR-X:n` in prose, a comment, or a code string
literal, a link target or #fragment that does not exist, an unknown citation code or rule, an absolute URL into this repository outside
.github/, and a docs path in a PowerShell string that names no file. A fixable violation is fixed by running Format-Links, and its issue
says so; the rest need a person. Informational findings (a comment line that stays over its limit) are counted but never fail the gate.

The string-citation check (`ADR-X:n` in a string literal, [ADR-REPO-LINK#5](../../../adr/repository/markdown-links.md#rule-adr-repo-link5))
takes its mode and exempt globs from links.yml's string_citations: in gate mode its findings are issues; in report mode they are printed as
its work list and counted (ReportedCount), and never fail the gate.

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)): it ends through
Write-QualityGateReport, which writes out/test-links/, prints every issue, and throws once listing them all. Each issue reads
'`<file>:<line>:<column>` `[<type>]` `<message>`'. It needs the source tree: it throws in build mode.

### parameter Path

Files or folders to check. Default: every git-tracked file.

### parameter Kind

Which link kinds to check: Code, Markdown, or Both (default).

### parameter RepositoryRoot

The repository root links resolve against. Default: the loaded repository root.

### parameter OutputFolder

The report base folder. Defaults to `<out>/test-links`.

### parameter PassThru

Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, FixableCount, InformationCount, ReportedCount, Reported })
instead of throwing.

### outputs

Throws on any violation; with -PassThru, returns the result object.

### example 1

```powershell
Test-Links
```

### example 2

```powershell
(Test-Links -Kind Code -PassThru).Issues
```
