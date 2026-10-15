---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
    kind: comment-page
    body_sha: "073d9a83f258"
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-ASSETDEP#2
---

# automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one sanctioned way for module code to locate content that ships with it — its configs/ and assets/, or
another module's
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)). Resolves
against Get-CatzcModulesRoot, so the answer is correct in
both run modes
([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)): <RepositoryRoot>/automation/<Module> in source mode, and
<build>/<version>/<Module> in build mode, where the merged <Module>.ps1 sits beside the same configs/ and
assets/ folders.

-Module defaults to the module of the calling function, so module code writes only the child path. Pass
-ChildPath as a string literal at every call site: Get-InternalAssetDependency derives the inventory of
internal asset dependencies from those literals
([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)).

Asserts the module folder exists; the child path is not asserted, so a caller may name a file it is about to
create, or test for an optional one.

In build mode a consumer overlay may replace a module's asset: when <overlay root>/<Module>/<ChildPath> is a
file under assets/, that path is returned instead of the bundled one
([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). Only assets/ is looked up there — configs merge
through Get-Config, and the registry and other module files are never replaced wholesale. A consumer's local
module — an overlay folder that names no bundled module — resolves to its overlay folder.
```

## comment:2

Section `.PARAMETER ChildPath` of the comment-based help.

```text
A path below the module folder, '/'-separated (e.g. 'assets/gitkeep', 'configs/configs.yml'). Omit for the
module folder itself.
```

## comment:3

Section `.PARAMETER Module` of the comment-based help.

```text
The module whose folder to resolve. Defaults to the module of the calling function; required when called
from outside a module (a script or the console).
```
