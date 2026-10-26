# pwsh/Base.ModuleSystem/Test-FolderConventions.ps1

A quality gate that checks every module folder of the modules track against the folder and file conventions. The convention is the module
system's own contract (folder is module, location is visibility), so the gate lives here rather than in `.internal`.

## help

### synopsis

Checks that every module folder of the modules track follows the folder and file conventions.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the module
folders of `<RepositoryRoot>/pwsh` (dot-prefixed folders are infrastructure, not modules). It walks each module folder with the bounded
`Get-ChildPath` walker and a `PathSet`, and collects every issue ([ADR-REPO-FOLDERS](../../../drs/repository/conventional-folders.md)):

- every module subdirectory is a conventional folder: private, tests, assets, types, configs;
- no test file (`*.Tests.ps1`) sits at the module root or in private/ — tests belong in tests/;
- no public function (a module-root .ps1, named for its function) is exported by more than one module — the last-loaded module would win
  silently;
- configs/ holds only kebab-case .yml files, or a split config, a kebab-case folder of kebab-case .yml files one level deep (dot-prefixed
  entries are tooling and are skipped);
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

## Module-root scripts

A `.ps1` at a module root is a public function whose file basename is the exported name (one function per file). A test there is misplaced.
The others are tracked, so the same name in two modules is reported as a cross-module duplicate export.

## Dot-prefixed entries

Dot-prefixed entries in `configs/` are tooling, such as a schema sidecar or an editor dotfile, not module config
([ADR-REPO-FOLDERS-DOTMEANSTOOLING](../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)).
