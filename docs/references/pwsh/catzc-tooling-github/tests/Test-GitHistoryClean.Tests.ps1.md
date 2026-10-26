# pwsh/Tooling.Github/tests/Test-GitHistoryClean.Tests.ps1

The L0 tests of `Test-GitHistoryClean`, run against a real git repository rather than mocks.

## Fixture

The tests build a throwaway git repository in the temp folder whose history plants the token on all three surfaces: a blob (file content), a
path (file name) and a commit message. Each surface is then found, and a clean history is reported clean.
