# automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Says why an L4 test must skip against its target environment, or nothing when it may run.

### description

An L4 test checks the released system itself, after final approval
([ADR-AUTO-TEST#41](../../../adr/automation/test-automation.md#rule-adr-auto-test41)). It may run anywhere, a devbox included: the only
limit is the security context of the console running it. So each L4 test asks here first and self-skips with the answer
([ADR-AUTO-TEST#8](../../../adr/automation/test-automation.md#rule-adr-auto-test8)):

- `target_<environment>_unreachable` — the probe says this console's identity cannot reach the environment (or the probe throws);
- `target_<environment>_readonly` — the test needs synthetic transactions, but test-policy.yml lets the environment take read-only probes
  only (the default for an environment it does not list).

The answer is a constrained skip key: the environment name is lowercased with every character but a letter or digit dropped (pre-prod ->
preprod). A console run of L4 tests is a run of that gate outside its pipeline: information, never a gate verdict.

### parameter Environment

The target environment the test reaches, e.g. pre-prod or production.

### parameter Mode

How far the test changes the target: ReadOnly (probes and observations) or Synthetic (transactions the system accepts and cleans up).

### parameter Probe

Answers whether this console's identity can reach the environment: a script block returning $true when it can. A probe that throws counts as
unreachable.

### outputs

`[string]` the skip key, or nothing when the test may run.

### example 1

```powershell
It 'answers on its health endpoint' -Tag 'L4', 'integrity' {
    $skip = Get-TestTargetSkipReason -Environment production -Mode ReadOnly -Probe { Test-WidgetEndpoint }
    if ($skip) { Set-ItResult -Skipped -Because $skip; return }
    ...
}
```
