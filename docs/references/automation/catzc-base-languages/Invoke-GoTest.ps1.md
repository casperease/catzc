---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
    kind: comment-page
    body_sha: da481fe42112
    adrs:
      - ADR-AUTO-ENVVAR#1
      - ADR-AUTO-GO#6
---

# automation/Catzc.Base.Languages/Invoke-GoTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:7

Above `$goPath = if ($GoExecutable) {`.

```text
The managed go, by its path: the caller's, already located and checked, or located here from its tools.yml entry
(Resolve-ToolExecutable); never a bare go off PATH.
```

## comment:8

Above `$environment = Get-EngineContract -Engine $Engine -EngineExecutable...`.

```text
How the tests start the engine (Get-EngineContract) is an external contract with the go test processes
([ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1)): set for these
commands only, then restored. GOTOOLCHAIN=local keeps go on the managed binary just checked: without it, go
reads go.work's go directive and silently downloads that toolchain instead
([ADR-AUTO-GO#6](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go6)).
```
