# pwsh/Base.Languages/types/GoWorkspaceFile.cs

One file `New-GoWorkspace` renders: the root `go.work`, or a `go/tests/<folder>/go.mod`. A result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
renderer only composes content; `Build-RootConfig` owns the write
([ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)).
