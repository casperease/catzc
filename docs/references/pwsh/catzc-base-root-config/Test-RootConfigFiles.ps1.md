# pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every managed root config file agrees with rootconfig.yml on git tracking, .gitignore, and link mechanism.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the opted-in
entries of rootconfig.yml ([ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md)), resolved exactly as Build-RootConfig
resolves them (Get-RootConfigTargets). A wildcard entry (e.g. `go/tests/*/go.mod`) is checked per file its generator renders
(Get-RootConfigRenderedFile). Per file, the entry's `committed` decides git membership, and the registry, .gitignore, and git's tracked set
must agree. It collects an issue for:

- a committed:false target no .gitignore rule ignores, or that git tracks (a derived artifact; remove it with `git rm --cached <path>`);
- a committed:true target git does not track (it is needed before the importer runs), or that an ignore rule matches;
- a target that is a link — every managed target must be a real, independent file (a link reads the same bytes as the file it points at, so
  a content compare alone would call it current);
- a `source` target that is missing, or that differs from its template under the generated head once the line endings are LF
  (Get-RootConfigCopyContent composes what Build-RootConfig writes).

Ignore rules are evaluated with `git check-ignore --no-index`, the rules alone: the default consults the index and would call a wrongly
tracked file "not ignored", masking the tracking check. Re-running the importer (Build-RootConfig) repairs the link issues. It drives the
git CLI, so it needs a git work tree.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-root-config-files/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Files }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-RootConfigFiles
```
