# pwsh/.internal/tests/Import-CSharpTypes.Shipped.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (-not (Get-Command Test-Formatting -ErrorAction Ignore)) {`, written with `#`.

```text
The loader enforces this at import (it throws on a missing/mismatched namespace); this asserts the same
invariant through Test-Formatting's Format-Types check, the authored quality gate, so a drift is a named
failure, not a load-time throw. The namespace rule is what this test is about, so the gate's layout engine
(dotnet format over every C# file, seconds of a real tool) stays out of it: the real engine's run over the
repository is the L2 integrity test in Test-Formatting.Tests.ps1.
```

## comment:2

Above `Describe 'combined types surface matches its contract'`, written with `#`.

```text
Mixed tiers: the git-status drift guard and the dotnet-build stamp check drive CLIs (L2 — process startup
well over the L0 limit), while the hash check is pure filesystem (L0). Tier is tagged per It.
```

## comment:3

Above `$script:currentHash = (Get-CombinedTypeHash (Get-CatzcModulesRoot)).CombinedHash`, written with `#`.

```text
The current combined hash comes from the ONE shared implementation (Get-CombinedTypeHash, loaded by the
importer that ran before this test file) — the same function the loader and the janitor call, so there is no
separate PowerShell mirror to keep in step. The independent oracle that would catch a bug IN that
function is the cross-language MSBuild stamp checked by the 'IDE project build stamps …' test below (a
genuinely separate C# implementation of the same hash; see native-csharp-types).
```

## comment:4

Above `It 'commits the current build''s types surface as its contract...`, written with `#`.

```text
Drift guard: the importer (which ran before this test file) builds the current sources into the shadow root
and rewrites the types contract when their surface moved. Test-BuildArtifact's types facet checks that the
committed contract is that surface, with no pending git change (a forgotten commit of the regenerated
contract stays red until it is committed). source-only: it reads the repository's own contract.
```

## comment:5

Above `It 'the IDE project build stamps its version to the current committed hash...`, written with `#`.

```text
The IDE project (Catzc.Types.csproj) stamps its version from the committed .compiled DLL and FAILS its
build when that DLL is stale or missing (see native-csharp-types ADR). Drive the real dotnet build and
assert the deps.json project entry carries the CURRENT hash — so a drift between the committed assembly
and the stamp, or a broken stamping target, is caught automatically here rather than only at IDE-build
time. The stamping algorithm is a mirror of the loader's; this build proves it still agrees.
```

## comment:6

Above `if (-not (Test-Tool 'dotnet')) {`, written with `#`.

```text
Test-Tool, not Get-Command: a machine can carry the dotnet host with no SDK, and `dotnet build` needs the
SDK — Test-Tool probes the pinned version, which only an installed SDK answers (as Invoke-Dotnet's L2 does).
```

## comment:7

Above `It 'registers the [Catzc.Module.Depm] accelerator for the decorated enum' {`, written with `#`.

```text
A [Catzc.Base.Objects.PSTypeAlias("Name")] on a type publishes a PowerShell type-accelerator at load, so
[Name] resolves to it. This asserts the real registration on the shipped ModuleDependencyFormat (the
importer ran, and so registered it, before Pester started).
```
