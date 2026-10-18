# automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every generated README is gitignored, untracked, and current with its source.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the generated READMEs
([ADR-REPO-README](../../../adr/repository/generated-readmes.md)). readme.yml, expanded by Get-ReadmeMappings exactly as Build-Readme
expands it, lists the folders whose README.md is generated from a docs/ source — a derived artifact, never authored in place. For each, it
collects an issue when the README is:

- not matched by a .gitignore rule (`git check-ignore --no-index` evaluates the rules alone; the default would consult the index and call a
  wrongly tracked file "not ignored", masking the next check);
- tracked in git (remove it with `git rm --cached <path>`; the file stays on disk, ignored);
- missing or stale: not what Build-Readme would write now (Get-ReadmeContent, compared EOL-insensitively by Write-FileIfChanged -DryRun) —
  re-run the importer, which regenerates it.

Hand-authored READMEs are the folders not in readme.yml and are out of scope. It reads the repository's files, .gitignore, and git index,
which exist only in a git work tree of the source tree (Get-ReadmeMappings).

### parameter OutputFolder

The report base folder. Defaults to out/test-generated-readmes/ (Write-QualityGateReport).

### parameter PassThru

Return the result ({ Subject; IssueCount; Issues; ReportPath; Readmes }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-GeneratedReadmes
```
