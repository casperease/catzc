---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/types/FunctionCallCollector.Tests.ps1.md
    kind: comment-page
    body_sha: "35be3a091768"
---

# automation/Catzc.Base.ModuleSystem/tests/types/FunctionCallCollector.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'FunctionCallCollector' -Tag 'L0', 'logic' {`, written with `#`.

```text
FunctionCallCollector attributes every statically named call in a file to the top-level function whose body holds
it, and lists the functions nested inside each — the walk Test-FunctionDependency resolves calls from. Each case
parses the source of a small widget/gadget script.
```
