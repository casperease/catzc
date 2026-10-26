# pwsh/Base.QualityGates/private/Get-TestDiscovery.ps1

Runs one discovery-only Pester pass over the given test paths and returns the result. Test-Automation shares that single pass between its
pre-run inspections, so the files are loaded once.

## help

### synopsis

Runs a discovery-only Pester pass over the given test paths and returns the result.

### description

The single discovery pass Test-Automation shares between its pre-run inspections: Get-TestTagViolations (the mandatory tier/category check)
and Split-TestAutomationFiles (the phase split) both consume the one result, so the tree is discovered once per run, not once per question.
Run.SkipRun makes it inspect every test regardless of tag filters — nothing executes. A Go test folder is discovered through the Go bridge
(ConvertTo-PesterRunTarget), which reads its Go tests from the source without running go. Pester must already be loaded (Test-Automation
lazy-loads it before calling this).

### parameter `TestPath`

One or more 'tests' folders, or Go test folders, to discover.

### outputs

The Pester run object of the discovery pass (every discovered test, none run).
