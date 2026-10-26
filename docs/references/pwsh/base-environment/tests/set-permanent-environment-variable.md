# pwsh/Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1

The vertical system test (L3) of the persistent-environment seam, `Set-PermanentEnvironmentVariable` and `Get-PermanentEnvironmentVariable`,
against the real user environment.

## Why it is the one real test

The user environment is state outside the repository that every process and every concurrent run on the machine shares, so the test runs
only in the working folder itself, never in a snapshot location. It is the one test that proves the registry round trip; every caller's
logic is covered at L1 by mocking the two functions.

## Scratch variable

The test owns a scratch variable no tool uses, named per run so two overlapping runs never share it, and removes it whatever happens.
Removed means gone from the registry key: an empty value would read back as `''` and pass a null-or-empty check.
