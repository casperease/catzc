# pwsh/Base.Environment/tests/Remove-PermanentPath.Tests.ps1

The L0 logic tests of `Remove-PermanentPath`, which remove a directory from the session and the persistent PATH.

## In-memory persistent PATH

The persistent Windows User-registry PATH lives in memory behind the `Get-EnvironmentPath` and `Set-EnvironmentPath` seam, so no run mutates
the machine's PATH or broadcasts `WM_SETTINGCHANGE`. Every Windows run of `Remove-PermanentPath` reaches that branch, not only the
persistence context, so the mocks are global.
