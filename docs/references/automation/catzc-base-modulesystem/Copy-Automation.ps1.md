---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md
    kind: reference
    body_sha: "9ba5e9ab045c"
    adrs:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The source is always this repository (Get-RepositoryRoot). What to copy is chosen off the typed module
model (Get-BaseModule):

  -ModuleNames      which disk modules to copy (named + hidden folders). Default: all.
  -ExcludePackages  a global list of package names to drop. A package is a named group of extra file
                    artifacts a module owns (configs/files.yml) — e.g. the repository module's
                    'root_configs' and 'gitignore', or the types module's 'csproj'. Default: none.

Each selected module copies its folder plus each of its packages whose name is not excluded, to the SAME
repository-root-relative path under -Destination, so the destination becomes a new root mirroring ours. A
source that is selected but absent from this tree (e.g. .compiled before a first build) is skipped.

Conflict handling is a fast pre-scan (fast / faster / fastest):
  - default          full pre-scan; if any file it would write already exists, throw and list them —
                     nothing is written (never clobbers).
  - -EmptyDestination require the target to be empty (or absent); throw otherwise. The pristine-copy
                     contract used by Pester against a fresh tmp directory.
  - -Force           skip the pre-scan and overwrite.

The copy is of the source tree (per-function files, tests/, root packages), so it stops with a named error
in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).

See [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md) (files.yml),
[ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9), and
[ADR-AUTO-PATH](/docs/adr/automation/path-representation.md).
```

## comment:2

Section `.PARAMETER ModuleProfile` of the comment-based help.

```text
A named module profile from configs/profiles.yml (minimal, azure, …), resolved to its dependency closure +
infrastructure via Get-ModuleProfile. Alternative to -ModuleNames.
```
