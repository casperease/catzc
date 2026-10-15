# docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md

`automation/Catzc.Base.Docs/Build-GitKeep.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The folder is the registration: every .gitkeep in the repository (found by a filesystem walk that skips
`.git` and the vendored modules) is a managed copy of this module's assets/gitkeep (located through
Get-CatzcModuleRoot, so it resolves inside the loaded module in both run modes) — a generic text saying the file
keeps its folder tracked and that the folder's story lives in its README.md. That pointer is honest
because an integrity test requires every .gitkeep folder to be a readme-mapped target (a docs/references
article Build-Readme copies in), so adding a .gitkeep anywhere demands its reference article — the gap
finder for the reference docs.

Idempotent and fast by construction, so the importer runs it on every load beside Build-Readme: writes go
through Write-FileIfChanged (canonical output, EOL-insensitive compare, write only on drift). .gitkeep
files are committed — tracking the folder is their whole job — so a source change lands as a reviewable
diff across every location. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:2

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report what would change without writing any file. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:3

Section `.PARAMETER Silent` of the comment-based help.

```text
The per-file status lines are verbose-level — -Silent suppresses them entirely, even under -Verbose
(used by the importer tail).
```

## comment:4

Above `$outputRoot = [System.IO.Path]::Combine($repositoryRoot, 'out')`.

```text
Walk the tree for .gitkeep files, skipping git's own store and the vendored modules (not ours to
manage). The output root's own .gitkeep is checked, but its contents — transient artifacts that may
carry fixture copies — are never descended into. [System.IO] over cmdlets on this hot path
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)); sorted for deterministic
output.
```
