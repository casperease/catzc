# pwsh/Base.QualityGates/types/LinkEngineResult.cs

The outcome of one link-engine run (`LinkEngine.Run`): every finding in file and line order, the aligned text of each file the aligner would
change (repository-relative path to new text), and how many files were read. The engine does no writing: `Format-Links` writes `Changed`,
and `Test-Links` reports `Findings`.
