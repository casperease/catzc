---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
    folder: docs/references/automation/catzc-base-git/private
    name: get-auto-controlled-globs-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e4018128b6cc
    adrs:
      - ADR-REPO-OUTDIR#{8,10}
---

# automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$ret.Add('automation/*/*.psd1')`, written with `#`.

```text
Generated module manifests (dynamic-module-manifests; the vendored .psd1 are committed, so they
can never appear among untracked clean candidates).
```

## comment:2

Above `$ret.Add('.cspell')`, written with `#`.

```text
Generated cspell dictionaries, regenerated at the importer tail
([ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)).
```

## comment:3

Above `$ret.Add('out')`, written with `#`.

```text
The output root — transient by contract (dedicated-output-directory) — except the authored plan files,
which are working notes, not output
([ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)).
```

## comment:4

Above `$ret.Add('**/.$*.drawio.png.bkp')`, written with `#`.

```text
drawio editor autosave shadows ('.$<name>.drawio.png.bkp') — disposable copies the editor writes
beside a committed .drawio.png asset (drawio-diagrams-and-cli); regenerable, safe to clean.
```
