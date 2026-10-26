# pwsh/Azure.Cli/tests/Invoke-AzCli.L2.Tests.ps1

The L2 test that proves `Invoke-AzCli` shells out to a working `az`.

## The skip gate

The test gates on the presence of `az`, not on the locked version. It does not assert the version lock of `tools.yml`, so a functional
az of another version must still run, matching the Build-Bicep L2 skeleton. The skip key is the constrained `tool_az_missing` grammar.
