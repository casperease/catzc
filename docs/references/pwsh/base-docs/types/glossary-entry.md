# pwsh/Base.Docs/types/GlossaryEntry.cs

One concept of the merged controlled vocabulary ([ADR-REPO-VOCAB](../../../../drs/repository/controlled-vocabulary.md)) as `Get-Glossary`
returns it. It holds the `GlossaryConcept` itself, the module whose glossary source declares it (`Owner`), that source's repo-relative path
(`SourcePath`), and the source's defaulted `GlossaryOptions`, so a gate or a reader knows where each term lives and which checks it takes
part in without going back to the source.

It is a result type, not a YAML mirror, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
