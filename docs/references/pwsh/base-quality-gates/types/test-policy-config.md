# pwsh/Base.QualityGates/types/TestPolicyConfig.cs

The typed record for `configs/test-policy.yml`: what a test may do to the environment it reaches
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../../drs/automation/test-automation.md#rule-adr-auto-test-testinginproduction)), how greedy test
files share the pool, and the single declaration of the sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). Property
names mirror the YAML keys, snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). An
unknown key throws.

## Keys

- **`l4_mutation`** — per target environment, how far an L4 test (the released system, after final approval) may change it: `read-only`
  (probes and observations only) or `synthetic` (transactions the system is built to accept and clean up). Each mode allows every mode
  before it. An environment not listed is `read-only`.
- **`greedy_group_size`** — how many greedy files run at once in the pool: 1 runs them one after another, 2 two at a time. Default 2, at
  most 64.
- **`greedy_apart`** — the greedy files that each run real builds, named by their test file without `.Tests.ps1`. At most one of them runs
  at a time. The default names five such files.
- **`duration_decay`** — the share of a file's stored duration a faster run keeps, so a cold-cache spike fades over about twenty runs. 0
  trusts the last run. Default 0.9.
