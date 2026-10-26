# pwsh/Base.QualityGates/private/Get-NeutralCodeFinding.ps1

Lists every real ADR code that a test file uses as fixture data inside an L0 block. Logic tests use neutral fixtures, so a real code there
is a finding.

## help

### synopsis

Lists every real ADR code one test file uses as fixture data inside an L0 block.

### description

The neutral-code check of Test-SourceConventions
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): a
logic test owns its inputs and uses identities that cannot collide with the real ones, so an L0 test's fixture data names neutral codes (a
widget or gadget code), never a code the ADR index declares. The real codes come from the caller, read from the ADR registry, so nothing
here names one.

It reads the file's syntax tree, never runs Pester. A string literal is checked when the nearest Describe, Context, or It around it that
carries a tier tag carries L0 — or, outside every tier-tagged block, when L0 is the only tier the file carries. The values of a -Tag
argument are citations, not data, and are never checked; the title of a Describe, Context, or It (its -Name, given by name or by position)
is a name, not data, so it is never checked either; comments (code links included) are not part of the syntax tree, so they never are.

### parameter `Path`

The test file's repository-relative, '/'-separated path, which leads each finding.

### parameter `Ast`

The test file's syntax tree (parsed once by the caller).

### parameter `Code`

The real ADR codes, from the ADR registry (Get-DrsCitationMap).

### outputs

`[string[]]` One '`<path>:<line>`: `<message>`' per real code used, in line order.

## Values

A value in a test's argument list belongs to the parameter before it (`-Tag 'x'` or `-Tag:'x'`), or it is positional. The first positional
value is the title.
