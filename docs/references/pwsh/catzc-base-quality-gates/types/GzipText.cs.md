# pwsh/Base.QualityGates/types/GzipText.cs

Gzip compress and decompress for UTF-8 text payloads, using only the BCL
([ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies)).
`Build-EnglishDictionary` writes the committed `english.txt.gz` with it and `SpellingOracle` reads it. The container handling lives in one
place, so the writer and the reader cannot drift.
