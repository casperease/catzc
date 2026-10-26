# pwsh/.internal/tests/Import-CSharpTypes.Shipped.Tests.ps1

The tests of the shipped combined types: their namespaces, their contract, the IDE project's stamp and the type accelerators.

## The namespace rule

The loader enforces the rule at import and throws on a missing or mismatched namespace. This test asserts the same invariant through
`Test-Formatting`'s `Format-Types` check, so a drift is a named failure, not a load-time throw. The namespace rule is what the test is
about, so the layout engine (`dotnet format` over every C# file, seconds of a real tool) stays out of it; the real engine's run over the
repository is the L2 integrity test in `Test-Formatting.Tests.ps1`.

## The combined types surface

The tiers are mixed: the git-status drift guard and the dotnet-build stamp check drive CLIs (L2, process startup well over the L0 limit),
while the hash check is pure file system (L0). The tier is tagged per `It`.

The current combined hash comes from the one shared implementation, `Get-CombinedTypeHash`, loaded by the importer that ran before the test
file. The loader and the janitor call the same function, so there is no separate PowerShell mirror to keep in step. The independent oracle
for a bug in that function is the cross-language MSBuild stamp, checked by the IDE project test below: a genuinely separate C#
implementation of the same hash.

The drift guard relies on the importer having built the current sources into the shadow root and rewritten the types contract when their
surface moved. `Test-BuildArtifact`'s types facet checks that the committed contract is that surface, with no pending git change, so a
forgotten commit of the regenerated contract stays red until it is committed. It is source-only: it reads the repository's own contract.

## The IDE project stamp

The IDE project (`Catzc.Types.csproj`) stamps its version from the committed `.compiled` DLL and fails its build when that DLL is stale or
missing. The test drives the real `dotnet build` and asserts that the `deps.json` project entry carries the current hash, so a drift between
the committed assembly and the stamp, or a broken stamping target, is caught here rather than only at IDE-build time. The stamping algorithm
mirrors the loader's, and this build proves it still agrees.

It probes with `Test-Tool 'dotnet'`, not `Get-Command`: a machine can carry the dotnet host with no SDK, and `dotnet build` needs the SDK.
`Test-Tool` probes the pinned version, which only an installed SDK answers.

## Accelerators

A `[Catzc.Base.Objects.PSTypeAlias("Name")]` on a type publishes a PowerShell type accelerator at load, so `[Name]` resolves to it. The test
asserts the real registration of `[Catzc.Module.Depm]` on the shipped `ModuleDependencyFormat`; the importer ran, and so registered it,
before Pester started.
