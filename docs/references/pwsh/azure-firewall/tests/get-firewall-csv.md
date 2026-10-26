# pwsh/Azure.Firewall/tests/Get-FirewallCsv.Tests.ps1

<!-- cspell:ignore etwork -->

The L0 tests of the download command, with every az call mocked so nothing ever reaches the cloud.

## The blob listing

The fixture listing is realistic. Its `dd-MM-yyyy` names do not sort chronologically by string: `ApplicationRules-30-01-2026-...` is
lexically the largest but is January, older than June. Only a pick by the timestamp inside each name finds the newest, so a correct pick
must return the June blobs.

## The az mock

The default happy-path mock returns the listing JSON for a list call. For a download call it copies the matching fixture to the requested
`--file`, so the emitted path points at a real CSV.
