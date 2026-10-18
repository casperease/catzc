# automation/Catzc.Tooling.Toolchain/tests/Install-Uv.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:newAsset = {`, written with `#`.

```text
A release fixture the resolver walks: newest first (the GitHub API order), one release per line of
the matching logic — off-pin newer, two on-pin (newest wins), off-pin older. Both architectures
carry assets so the test is agnostic to the machine it runs on.
```

## comment:2

Above `$script:savedHome = $env:HOME`, written with `#`.

```text
The helper reads $env:HOME (the uv tool-bin anchor) and prepends to $env:PATH — snapshot both and
restore after each test
([ADR-PWSH-ENV#4](/docs/adr/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env4)).
```

## comment:3

Above `Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter {...`, written with `#`.

```text
The tar boundary: plant the extracted tree (a versioned folder holding uv and uvx) into the -C
directory the command names, as the real tar would.
```
