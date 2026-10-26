# pwsh/Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1

The tests of `Sync-GeneratedFile`. The commit is limited by pathspec inside `Invoke-GitCommit`, so a dirty or staged tree never holds the
stamp commit back and never leaks into it, and the tests pin that.
