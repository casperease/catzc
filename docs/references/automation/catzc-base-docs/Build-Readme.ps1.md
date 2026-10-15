---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Build-Readme.ps1.md
    kind: reference
    body_sha: "503265793292"
    adrs: []
---

# automation/Catzc.Base.Docs/Build-Readme.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the README registry (configs/readme.yml, via Get-Config -Config readme), expands its glob patterns
against the filesystem (Get-ReadmeMappings), and for every resulting mapping writes `<folder>/README.md`
as a copy of the authored `source` docs file (Get-ReadmeContent): the source's relative links rebased to
the README's folder, so every link works where the README is opened, under a line naming the source as
the one place to edit.

The READMEs are derived artifacts: gitignored (like the generated .psd1 manifests) and excluded from the
markdown quality gate — the authored source under docs/references/ is what is checked. Idempotent and fast by
construction, so the importer runs it on every load (see importer.ps1): Write-FileIfChanged rewrites a
README only when its composed content differs (EOL-insensitively), and a rewrite is delete-then-write, so a
README that is a filesystem link is severed and never written through into its source. It writes into the
catzc source tree, so it runs in source mode only (Assert-SourceTree); a session running a built package
stops with a named error.

See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md) and
[ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md).
```

## comment:2

Section `.PARAMETER Folder` of the comment-based help.

```text
Generate only the mapping whose target folder equals this repo-relative path (e.g.
'automation/Catzc.Azure.DevOps'). Throws when it matches no mapping. Default: every mapping.
```

## comment:3

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report what would change without touching the filesystem. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:4

Section `.PARAMETER Silent` of the comment-based help.

```text
The per-README status lines are verbose-level — shown only when this function is run with -Verbose.
-Silent suppresses them entirely, even under -Verbose (used by the importer tail so a session with
-Verbose on does not chatter during import).
```

## comment:5

Above `$changed = Write-FileIfChanged -Path $readmePath -Content (Get-ReadmeContent...`.

```text
Delete-then-write on a change (Write-FileIfChanged): a README that is still a filesystem link to its
source is severed, never written through.
```
