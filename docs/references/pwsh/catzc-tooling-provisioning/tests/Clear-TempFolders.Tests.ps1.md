# pwsh/Tooling.Provisioning/tests/Clear-TempFolders.Tests.ps1

The tests of `Clear-TempFolders`.

## The locked-file case

`FileShare.None` is a mandatory lock only on Windows; on Unix it is advisory and does not block a delete, so the locked file would be removed
and the case cannot be set up. The case is skipped off Windows.

## The folder list

The third entry of the folder list is the same folder with a trailing separator, which the command's de-duplication must canonicalize away.
The test builds it with the platform separator: a hardcoded `\` is a literal filename character on Unix, which makes it a different path.
