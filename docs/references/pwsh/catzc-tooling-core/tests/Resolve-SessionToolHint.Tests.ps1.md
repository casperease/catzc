# pwsh/Tooling.Core/tests/Resolve-SessionToolHint.Tests.ps1

The L0 tests of `Resolve-SessionToolHint`.

## Windows fixture

The fixture is a `.cmd` shim resolved through `PATHEXT`, a Windows shape; the Unix path is analogous. `Set-ItResult` is legal only per test,
so the non-Windows skip lives in `BeforeEach`, not `BeforeAll`: calling it in `BeforeAll` throws and fails the whole `Describe` off-Windows.
The original PATH is captured first, so `AfterEach` restores it even on the skipped path.
