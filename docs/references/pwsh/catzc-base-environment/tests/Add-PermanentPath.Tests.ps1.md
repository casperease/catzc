# pwsh/Base.Environment/tests/Add-PermanentPath.Tests.ps1

The L0 logic tests of `Add-PermanentPath`, which add a directory to the session and the persistent PATH.

## In-memory persistent PATH

The persistent Windows User-registry PATH lives in memory behind the `Get-EnvironmentPath` and `Set-EnvironmentPath` seam, so no run mutates
the machine's PATH or broadcasts `WM_SETTINGCHANGE`. Every Windows run of `Add-PermanentPath` reaches that branch, not only the persistence
context, so the mocks are global.

## Skipping a present entry

A case seeds the in-memory PATH with the entry already there, and `Add-PermanentPath` must skip the registry write entirely. The case
asserts that `Set-EnvironmentPath` is never called, so it never leans on state passed between two mocks, which hits a Pester `$script:`
scope surprise.
