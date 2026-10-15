---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
    kind: comment-page
    body_sha: ccf93815669a
---

# automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$entries = [System.Collections.Generic.List[hashtable]]::new()`.

```text
1) Resolve every channel into a flat list of env-var assignments. Each entry:
   @{ Name; Value; Secret; Origin; Address }  (Address is $null unless address-sourced).
```

## comment:5

Above `$scoped = -not $Persist`.

```text
3) Apply. Scoped snapshots each target's current value, sets all, invokes the block, and restores in a
   finally; Persist just sets all and leaves them. Both share one set+log loop.
```
