# pwsh/Azure.DevOps/tests/Set-AdoPipelineVariable.Tests.ps1

The L0 tests of the command that sets a pipeline variable through the `##vso` logging command.

## The writer guard

The `##vso` line goes through the writer chokepoint, which a test run silences. The tests lift that guard so they can capture the line, and
every call captures with `6>&1`, so nothing reaches a real pipeline log. The guard exists only under `Test-Automation`, so it is read
strict-clean and, when it was absent, removed again.
