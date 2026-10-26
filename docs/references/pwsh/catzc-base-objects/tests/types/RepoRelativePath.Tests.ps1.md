# pwsh/Base.Objects/tests/types/RepoRelativePath.Tests.ps1

The L0 logic tests of `RepoRelativePath`, the path value that stores the repository-relative form.

## Fixture segments

The fixtures use neutral, non-reserved path segments only. `out` is deliberately avoided: it is the reserved output anchor
(`Get-OutputRoot`, `{root}/out` locally and the external staging directory in a pipeline), a different anchor from repository-root-relative,
so it does not belong in a test of generic repository-relative normalization.
