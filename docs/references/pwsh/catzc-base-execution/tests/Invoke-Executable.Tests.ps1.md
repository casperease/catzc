# pwsh/Base.Execution/tests/Invoke-Executable.Tests.ps1

The tests of `Invoke-Executable`, running real executables on every platform.

## Test commands

The commands are `where.exe` on Windows and `which` elsewhere, because `echo` is a shell builtin on Windows (there is no `echo.exe`) and
breaks Stream mode. `where.exe /?` prints help, which proves the argument arrived intact, and a quoted argument holding a space must not be
split.

## A leaver at L2

The child exits at once, but the grandchild it starts inherits the output pipe and holds it for 20 seconds, as a dotnet build server does.
The run must not wait out the grandchild.

## macOS paths

macOS resolves `/var` and `/tmp` to `/private/var` and `/private/tmp`, so the child's reported working directory carries a `/private` prefix
that `[IO.Path]::GetTempPath()` does not. Both sides are normalised.
