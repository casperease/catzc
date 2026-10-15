---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
    kind: comment-page
    body_sha: "245890f19896"
    adrs:
      - ADR-CONF-LOADING#6
      - ADR-REPO-OUTDIR#10
      - ADR-REPO-OUTDIR#8
---

# automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The auto-controlled set Reset-GitCleanFxd deletes against — derived fresh on every call, held in
memory only, never persisted, so it cannot drift from what the owners actually generate. It is the
union of:

- the managed root-config registry's gitignored targets (rootconfig.yml entries with optIn and
  committed false — .editorconfig, the .vscode/ files, cspell.yml, catzc.sln, …), read through
  Get-Config (reading a config is global access, never limited by the dependency graph —
  [ADR-CONF-LOADING#6](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading6));
- the conventional generated-artifact classes: the dynamic module manifests
  (automation/<Module>/<Module>.psd1), the generated READMEs (every gitignored README.md is a
  generated copy by the generated-readmes contract — a hand-authored README is only safe once
  opted in and committed), the generated cspell dictionaries (.cspell/), the transient output root (out/ — disposable by the
  dedicated-output-directory contract), the IDE-only C# project's build output (bin/obj under
  automation/.internal/assets), the compiled-type *.tmp scratch, and the drawio editor's autosave
  shadows ('.$*.drawio.png.bkp' beside a committed .drawio.png asset).

Minus the exclusions, written gitignore-style with a leading '!': a path matching an exclusion is
never auto-controlled, whatever else it matches (the authored out/plan-*.md files,
[ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)).

Patterns are repo-relative, '/'-separated -like globs; a directory is listed both bare and with a
trailing /* so a whole-folder candidate from `git clean` matches too.
```

## comment:2

Above `$ret.Add('automation/*/*.psd1')`.

```text
Generated module manifests (dynamic-module-manifests; the vendored .psd1 are committed, so they
can never appear among untracked clean candidates).
```

## comment:3

Above `$ret.Add('.cspell')`.

```text
Generated cspell dictionaries, regenerated at the importer tail
([ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)).
```

## comment:4

Above `$ret.Add('out')`.

```text
The output root — transient by contract (dedicated-output-directory) — except the authored plan files,
which are working notes, not output
([ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)).
```

## comment:5

Above `$ret.Add('**/.$*.drawio.png.bkp')`.

```text
drawio editor autosave shadows ('.$<name>.drawio.png.bkp') — disposable copies the editor writes
beside a committed .drawio.png asset (drawio-diagrams-and-cli); regenerable, safe to clean.
```

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
