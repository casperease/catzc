# pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Shipped template integrity' -Tag 'L0', 'integrity' {`, written with `#`.

```text
Integrity for the SHIPPED bicep templates (infrastructure/templates/): that they are NAMED so discovery
finds them, and that their CONTENTS meet easily-verifiable structural constraints — WITHOUT building them.
Actually compiling a production template is the PIPELINE'S build step, not an integrity test; e2e build
coverage lives in the FIXTURE-based L2 'real az' logic tests (Build-Bicep.*.Tests.ps1, which mock
Get-BicepTemplatesRoot to tests/assets/templates/ and build a sample-* asset). This file binds to the real
infrastructure/templates/ + configs (it does NOT mock the Get-BicepTemplatesRoot / Resolve-ConfigEntry
seams — binding to the real assets is the whole point of an integrity test,
[ADR-AUTO-TEST-ONECATEGORY](/docs/drs/automation/test-automation.md#rule-adr-auto-test-onecategory)) and is generic: it
DISCOVERS the set and asserts invariants that hold for EVERY shipped template, binding to no template name
and no production-derived value ([ADR-AUTO-TEST-GENERICTEMPLATETESTS](/docs/drs/automation/test-automation.md#rule-adr-auto-test-generictemplatetests)).

One read-only scan in BeforeAll; each It block asserts one facet of it
([ADR-AUTO-TEST-INTEGRITYREADSFILES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-integrityreadsfiles)/18/20). Both validators run here:
Get-BicepTemplates (discovery — folders/files named right, options schema, identity references) and
Assert-BicepTemplate (the consolidated validator, every problem in one message). Neither builds.
NB: Get-BicepTemplates returns a comma-wrapped array — assign it (an @()-wrap nests it one level) and
iterate with foreach (test-automation Gotchas).
```

## comment:2

Above `$script:discoveryError = $null`, written with `#`.

```text
Discovery is itself a check: it enforces the naming conventions, options.yml schema, and the
cross-layer identity references, throwing on violation. Capture the outcome rather than let a
failure abort the whole block, so each facet below reports cleanly.
```

## comment:3

Above `$script:validationError = $null`, written with `#`.

```text
Full structural validation WITHOUT building (no -Build): main.bicep present, options.yml schema +
short_name, env-class, identity references, and parameter alignment — every problem in one message.
```

## comment:4

Above `$validationError | Should -BeNullOrEmpty -Because "shipped templates must...`, written with `#`.

```text
Deliberately no -Build: this validates the files (main.bicep, options schema, identity references,
parameter alignment); it does NOT compile production bicep. Compiling production templates is the
pipeline's build step; e2e build is covered by the fixture-based L2 'real az' logic tests.
```
