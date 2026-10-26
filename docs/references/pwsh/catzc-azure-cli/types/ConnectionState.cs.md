# pwsh/Azure.Cli/types/ConnectionState.cs

The typed record of the az CLI session's connection state, measured against an expected tenant and/or subscription. It pairs what was asked
for (`expected_*`) with what the active session actually has (`actual_*`) and the verdict. It is a point-in-time probe of the CLI session,
not a config record.
