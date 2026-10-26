# pwsh/Base.Docs/tests/Build-Readme.Tests.ps1

The tests of `Build-Readme`: the generator over a fixture tree, and the real `readme.yml` against the repository.

## Isolation

The tests isolate through the seams
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)):
`Get-Config` is mocked and the repository root is redirected to a fixture tree (TestKit), so `Resolve-RepoPath` binds inside it. The fixture
root is not the loaded code root, which the run-mode guard reads as a built package, so the guard is mocked here and asserted separately
below.

## Real registry

This block reads only the repository's `readme.yml`, folders and `.gitignore`, the same answer in both run modes, so the build run skips it.
It proves the registry is consistent with the repository:

- every resolved README's source exists (`Get-ReadmeContent` asserts it);
- every module under `pwsh/` is covered by the pattern;
- the generated and committed split matches `.gitignore`: every mapped README is ignored and none is opted back in.

It resolves through the public generator (`Build-Readme -DryRun -PassThru`), since the pattern expansion (`Get-ReadmeMappings`) is private.
It closes the poka-yoke gap of the two-place "generated vs committed" convention. One `Should` runs over the violating set, since a `Should`
per module would pay Pester's per-assertion cost times the whole `pwsh/` tree.
