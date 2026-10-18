# pwsh/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every module folder under pwsh/ follows the folder and file conventions.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the module folders of
`<RepositoryRoot>/pwsh` (dot-prefixed folders are infrastructure, not modules). It scans the tree once with `[System.IO]` and collects
every issue ([ADR-REPO-FOLDERS](../../../adr/repository/conventional-folders.md)):

- every module subdirectory is a conventional folder: private, tests, assets, types, configs;
- no test file (`*.Tests.ps1`) sits at the module root or in private/ — tests belong in tests/;
- no public function (a module-root .ps1, named for its function) is exported by more than one module — the last-loaded module would win
  silently;
- configs/ is flat and holds only kebab-case .yml files (dot-prefixed entries are tooling and are skipped);
- no module keeps internal config in assets/config/ (it belongs in configs/) or test fixtures in assets/test/ (they belong in
  tests/assets/).

The folder convention is the module system's own contract (folder = module, location = visibility), so the gate lives with the module system
rather than in .internal, which is the loader and not a module.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-folder-conventions/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Modules }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-FolderConventions
```

### example 2

```powershell
(Test-FolderConventions -PassThru).Issues
```

## comment:1

Above `foreach ($path in ([System.IO.Directory]::EnumerateFiles($moduleDirectory,...`, written with `#`.

```text
Module-root .ps1: a test is misplaced; the rest are public functions whose file basename is the exported
name (one function per file), tracked for the cross-module duplicate-export check.
```

## comment:2

Above `if ($name -match '^\.') {`, written with `#`.

```text
Dot-prefixed entries are tooling (a schema sidecar, an editor dotfile), not module config
([ADR-REPO-FOLDERS-DOTMEANSTOOLING](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)).
```
