---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
    kind: comment-page
    body_sha: aae8aec22f58
    adrs:
      - ADR-REPO-OUTDIR#10
      - ADR-REPO-OUTDIR#8
---

# automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$ret.Add('automation/*/*.psd1')`.

```text
Generated module manifests (dynamic-module-manifests; the vendored .psd1 are committed, so they
can never appear among untracked clean candidates).
```

## comment:7

Above `$ret.Add('.cspell')`.

```text
Generated cspell dictionaries, regenerated at the importer tail
([ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)).
```

## comment:8

Above `$ret.Add('out')`.

```text
The output root — transient by contract (dedicated-output-directory) — except the authored plan files,
which are working notes, not output
([ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)).
```

## comment:9

Above `$ret.Add('**/.$*.drawio.png.bkp')`.

```text
drawio editor autosave shadows ('.$<name>.drawio.png.bkp') — disposable copies the editor writes
beside a committed .drawio.png asset (drawio-diagrams-and-cli); regenerable, safe to clean.
```
