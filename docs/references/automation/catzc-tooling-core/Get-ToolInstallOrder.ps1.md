---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4ada3e88778b"
---

# automation/Catzc.Tooling.Core/Get-ToolInstallOrder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$dependency = $allTools[$name]['depends_on']`, written with `#`.

```text
depends_on is optional: index it (a dotted read of an absent key throws under strict), and keep the
value an array — an if-expression would unroll a one-item list to a scalar
```

## comment:2

Above `$inDegree = @{}`, written with `#`.

```text
Kahn's algorithm for install order: if A depends on B, B must be installed first, so the edge runs B → A.
A tool's in-degree is therefore the number of edges pointing at it, which is the count of its own depends_on
entries, and a tool with no dependencies starts in the ready queue.
```
