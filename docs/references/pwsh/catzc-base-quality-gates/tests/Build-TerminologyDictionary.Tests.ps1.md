# pwsh/Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1

The tests of `Build-TerminologyDictionary`, which turns the terminology registry into the generated `.cspell/` dictionaries.

## Fixture registry

The logic cases mock `Get-Config` with a tiny registry that spans all three categories. The product category holds a duplicate and mixed
case, which proves the per-category grouping, the lower-casing and the de-duplication.

## Real registry

The real-registry case is source-only. It compares the repository's generated `.cspell/` dictionaries with the registry, which gives the same
answer in both run modes.
