---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyMap.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9bd38d6287bb"
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$dependencyMap = @{}`, written with `#`.

```text
module -> the set of modules it depends on. The loop variable must NOT be named $module: it would
collide (names are case-insensitive) with the [string[]] $Module parameter, whose type constraint
persists on the shared variable and would coerce each scalar element back into a 1-element array.
```

## comment:2

Above `foreach ($moduleName in $allowed.Keys) {`, written with `#`.

```text
2) Per-module allowed deps. A specific-module target is a direct edge. A GROUP target adds every member
   of that group — EXCEPT when the module is itself a member of that group (see .DESCRIPTION).
```
