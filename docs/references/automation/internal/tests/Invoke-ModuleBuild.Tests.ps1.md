---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Invoke-ModuleBuild.Tests.ps1.md
    kind: test-asset
    body_sha: "4ff5a0d83631"
---

# automation/.internal/tests/Invoke-ModuleBuild.Tests.ps1

<!-- cspell:ignore nfunction -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above ``$script:helpText = "<#`r`n.SYNOPSIS`r`n    Returns the...``.

```text
A neutral fixture source tree: two selectable modules (widget, gadget), one that is never selected (gizmo,
which also carries every merge-precondition violation), and stand-ins for the infrastructure the build ships.
```

## comment:2

Above ``'Get-GadgetWidget.ps1' = "function Get-GadgetWidget {`n    Get-Widget`n...``.

```text
Reaches into widget twice: a call and a config read — what the closure check follows. The
owner-scoped read (-ListOwners) reads only the owners present, so it is not a third gap.
```

## comment:3

Above `foreach ($gitCommand in @(`.

```text
The build ships what git tracks, so the fixture is a committed repository. core.autocrlf=true is a Windows
checkout: the CRLF fixture files (the help text, the initializer) are stored LF, as git stores them in the
real repository, and the checkout keeps them CRLF on disk.
```

## comment:4

Above `Mock Assert-SourceTree { } -ModuleName Catzc.Internal.Builder`.

```text
Boundaries: the source-tree guard (the fixture root is not the session's code root), the profile/closure
resolver and the asset inventory (both read the real configs/tree), and git.
```
