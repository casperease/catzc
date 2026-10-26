# pwsh/Base.Docs/Build-Readme.ps1

The writer of the generated READMEs: for each mapping of the [readme registry](configs/readme.yml.md) it composes the README from its
authored article and writes it into the mapped folder. It writes only when the composed content differs.

## Writing

A change is written delete-then-write (`Write-FileIfChanged`), so a README that is still a filesystem link to its source is severed and
never written through.

## help

### synopsis

Generates each conventional folder's README.md from its authored docs source — the writer behind the "READMEs are generated" contract.

### description

Reads the README registry (configs/readme.yml, via Get-Config -Config readme), expands its glob patterns against the filesystem
(Get-ReadmeMappings), and for every resulting mapping writes `<folder>/README.md` as a copy of the authored `source` docs file
(Get-ReadmeContent): the source's relative links rebased to the README's folder, so every link works where the README is opened, under a
line naming the source as the one place to edit.

The READMEs are derived artifacts: gitignored (like the generated .psd1 manifests) and excluded from the markdown quality gate — the
authored source under docs/references/ is what is checked. Idempotent and fast by construction, so the importer runs it on every load (see
importer.ps1): Write-FileIfChanged rewrites a README only when its composed content differs (EOL-insensitively), and a rewrite is
delete-then-write, so a README that is a filesystem link is severed and never written through into its source. It writes into the catzc
source tree, so it runs in source mode only (Assert-SourceTree); a session running a built package stops with a named error.

See [ADR-REPO-README](../../../drs/repository/generated-readmes.md) and
[ADR-CONF-LOADING](../../../drs/configuration/module-config-loading.md).

### parameter `Folder`

Generate only the mapping whose target folder equals this repo-relative path (e.g. 'pwsh/Azure.DevOps'). Throws when it matches no mapping.
Default: every mapping.

### parameter `DryRun`

Report what would change without touching the filesystem. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `Silent`

The per-README status lines are verbose-level — shown only when this function is run with -Verbose. -Silent suppresses them entirely, even
under -Verbose (used by the importer tail so a session with -Verbose on does not chatter during import).

### parameter `PassThru`

Return one result object per README ({ Folder, Source, Readme, Changed, DryRun }) instead of the paths.

### outputs

`[string[]]` The paths to the READMEs (with -PassThru, one result object per README instead).

### example 1

```powershell
Build-Readme
Brings every mapped README up to date with its docs source.
```

### example 2

```powershell
Build-Readme -DryRun -PassThru
Reports which mapped READMEs are stale without touching them.
```

### example 3

```powershell
Build-Readme 'pwsh/Azure.DevOps'
Generates only that folder's README.
```
