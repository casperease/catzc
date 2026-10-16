---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-DevBoxTools.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "473684e50363"
---

# automation/Catzc.Tooling.Provisioning/tests/Uninstall-DevBoxTools.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Pure orchestration: assert it delegates to the per-tool uninstallers. Get-ToolInstallOrder is mocked to a
small, realistic order — a single-word key (python) and a multi-word key (node_js) — and the real per-tool
uninstallers are mocked so the dynamic-dispatch loop is exercised without touching the machine. The
multi-word case is the regression guard: the key must be mapped through Get-ToolCommandSuffix to its
PascalCase command suffix (node_js -> Uninstall-NodeJs), or it silently never dispatches.
```
