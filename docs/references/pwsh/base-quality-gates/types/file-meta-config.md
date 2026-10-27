# pwsh/Base.QualityGates/types/FileMetaConfig.cs

The typed record of the meta-kind registry `file-meta.yml`: which kinds of derived fact and of config contribution exist is data, never a
list in an engine ([ADR-REPO-FILEMETA-METAKIND](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind),
[ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)). It
holds the kinds and the head policy per file class.

## Which kinds apply

`Selects` is true when the kind applies to a file, by the file's class (its kind, or kind/subkind, from the file-kinds registry) and its
language, which is null when no language claims the file.

## Engine inputs

`EngineInputs` names the files that decide every head, read under the modules root the run loaded from, so a fixture tree hashes the code
and registries the run uses: the two registries, the engine, every fact processor found by its name as the engine finds it
(`Get-*FileMetaFact.ps1`), and the registry's types (`FileMeta*.cs`, `*HeadPolicy.cs`).
