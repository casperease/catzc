---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Test-PrePost.Tests.ps1.md
    kind: comment-page
    body_sha: e74c29a00d1a
---

# automation/Catzc.Azure.Templates/tests/Test-PrePost.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Tests for the PrePost starter (Catzc.Azure.Templates/assets/PrePost.psm1) — the copy-in template that
authors clone into infrastructure/templates/<name>/PrePost.psm1. Production code does NOT load it;
these tests import it explicitly to verify the starter is a working no-op baseline.
```

## comment:2

Above `{ Invoke-BicepPrepareParameterSet -BuildInvocation $null -TemplateDescriptor...`, written with `#`.

```text
Null the parameter under test (supplying the others) so mandatory binding THROWS rather than
PROMPTS — omitting a mandatory param entirely hangs an interactive host waiting for input.
```

## comment:3

Above `{` (occurrence 3), written with `#`.

```text
Pass DeploymentOutput explicitly as $null (rather than omitting it) so mandatory binding
throws instead of prompting for the missing value.
```
