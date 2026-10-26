# pwsh/Base.QualityGates/tests/Format-FileMeta.Contract.Tests.ps1

The test of the provided head contract: the contract names the keys of a file's meta head, and this proves they are the keys the code
writes, so neither can drift.

## What it compares

The generated-file head holds place facts only, under `immutable`; the imprint kinds write the edges at the block's first level beside its
parts. The test compares the schema and the sample of the contract against those two sets of keys, in the part the code writes each.
