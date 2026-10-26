# pwsh/Tooling.Toolchain/tests/Install-Uv.Tests.ps1

The tests of `Install-Uv` and its standalone helper.

## The release fixture

The resolver walks a release fixture, newest first as the GitHub API orders it, with one release per line of the matching logic: an off-pin
newer one, two on-pin ones (the newest wins) and an off-pin older one. Both architectures carry assets, so the test does not depend on the
machine it runs on.

## The environment

The helper reads `$env:HOME`, the anchor of the uv tool-bin, and prepends to `$env:PATH`. The tests snapshot both and restore them after
each test
([ADR-PWSH-ENV-NOPESTERISOLATION](../../../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-nopesterisolation)).

## The tar boundary

The `Invoke-Executable` mock plants the extracted tree, a versioned folder holding `uv` and `uvx`, into the `-C` directory the command
names, as the real tar would.
