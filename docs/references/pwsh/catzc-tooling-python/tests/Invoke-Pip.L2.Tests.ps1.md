# pwsh/Tooling.Python/tests/Invoke-Pip.L2.Tests.ps1

The L2 tests of `Invoke-Pip`, which run the real chain `Invoke-Pip` to `Invoke-Uv` to `uv pip <args>`. uv is the tool that must exist, and it
needs a discoverable interpreter. There is no `uv pip --version`, since `uv pip` is a subcommand group, so the end-to-end contract is carried
by a real subcommand, listing the packages as JSON.
