# pwsh/Base.Languages/types/PythonWorkspaceFile.cs

One file `New-PythonProject` renders: the uv workspace root `<root>/pyproject.toml`, or a member `<root>/tests/<folder>/pyproject.toml`. A
result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
renderer only composes content; `Build-RootConfig` owns the write
([ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)).
