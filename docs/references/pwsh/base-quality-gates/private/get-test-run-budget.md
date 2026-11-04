# pwsh/Base.QualityGates/private/Get-TestRunBudget.ps1

Picks the time roof a test run is held to. The post-build run has its own roof, so it is told apart from the ordinary run here, once, and
the verdict and the over-budget check read the pair it returns.

## help

### synopsis

The time roof of a test run, in seconds, with the `timeouts.yml` key that declares it.

### description

The ordinary run takes `tests.run_seconds`; the post-build run
([ADR-AUTO-TEST-POSTBUILDTAG](../../../../drs/automation/test-automation.md#rule-adr-auto-test-postbuildtag)) takes
`tests.post_build_seconds`. The key is returned beside the seconds so a report names the entry a slow run must be fixed against, never
raised.

### parameter `TimeLimits`

The resolved test time limits, with `RunSeconds` and `PostBuildSeconds`.

### parameter `PostBuild`

Selects the post-build roof instead of the ordinary run roof.

### outputs

`[pscustomobject]` with `Seconds` (the roof) and `Key` (the `timeouts.yml` entry that declares it).
