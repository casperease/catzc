---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Invoke-ModuleBuild.Tests.ps1.md
    kind: comment-page
    body_sha: e4528a41d626
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/.internal/tests/Invoke-ModuleBuild.Tests.ps1

<!-- cspell:ignore nfunction -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above ``$script:helpText = "<#`r`n.SYNOPSIS`r`n    Returns the...``, written with `#`.

```text
A neutral fixture source tree: two selectable modules (widget, gadget), one that is never selected (gizmo,
which also carries every merge-precondition violation), and stand-ins for the infrastructure the build ships.
```

## comment:2

Above ``'Get-GadgetWidget.ps1' = "function Get-GadgetWidget {`n    Get-Widget`n...``, written with `#`.

```text
Reaches into widget twice: a call and a config read — what the closure check follows. The
owner-scoped read (-ListOwners) reads only the owners present, so it is not a third gap.
```

## comment:3

Above `foreach ($gitCommand in @(`, written with `#`.

```text
The build ships what git tracks, so the fixture is a committed repository. core.autocrlf=true is a Windows
checkout: the CRLF fixture files (the help text, the initializer) are stored LF, as git stores them in the
real repository, and the checkout keeps them CRLF on disk.
```

## comment:4

Above `Mock Assert-SourceTree { } -ModuleName Catzc.Internal.Builder`, written with `#`.

```text
Boundaries: the source-tree guard (the fixture root is not the session's code root), the profile/closure
resolver and the asset inventory (both read the real configs/tree), and git.
```

## comment:5

Above `foreach ($file in Get-ChildPath $Root -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a snapshot
compares every file of a build, so nothing is pruned.
```

## comment:6

Above `$script:files = @(foreach ($file in Get-ChildPath $root -File -Depth 64...`, written with `#`.

```text
A whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
assertions cover every file of the build, so nothing is pruned.
```
