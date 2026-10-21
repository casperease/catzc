# pwsh/Catzc.Base.QualityGates/types/TestPolicyConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
What a test may do to the environment it reaches (configs/test-policy.yml,
[ADR-AUTO-TEST-TESTINGINPRODUCTION](/docs/adr/automation/test-automation.md#rule-adr-auto-test-testinginproduction)), and the single declaration of its sensible
defaults ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)):
  l4_mutation — per target environment, how far an L4 test (the released system, after final approval) may change it:
                read-only (probes and observations only) or synthetic (transactions the system is built to accept and
                clean up). An environment not listed is read-only.
Property names mirror the YAML keys (snake_case,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
