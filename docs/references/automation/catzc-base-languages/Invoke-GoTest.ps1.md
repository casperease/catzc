---
catzc:
  immutable:
    with_body_sha: e81718986e90
    path: docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
    folder: docs/references/automation/catzc-base-languages
    name: invoke-go-test-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-ENVVAR#1
      - ADR-AUTO-GO#6
---

# automation/Catzc.Base.Languages/Invoke-GoTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$goPath = if ($GoExecutable) {`, written with `#`.

```text
The managed go, by its path: the caller's, already located and checked, or located here from its tools.yml entry
(Resolve-ToolExecutable); never a bare go off PATH.
```

## comment:2

Above `$environment = Get-EngineContract -Engine $Engine -EngineExecutable...`, written with `#`.

```text
How the tests start the engine (Get-EngineContract) is an external contract with the go test processes
([ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1)): set for these
commands only, then restored. GOTOOLCHAIN=local keeps go on the managed binary just checked: without it, go
reads go.work's go directive and silently downloads that toolchain instead
([ADR-AUTO-GO#6](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go6)).
```
