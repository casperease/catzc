---
plan:
  status: blocked
  value: low
  reviewed: 2026-10-17
  blocked_on: the editor still reports MSB4025 on Catzc.Types.csproj after a window reload (Q1)
  targets:
    [
      automation/Catzc.Base.TypesSystem/assets/Catzc.Types.csproj.xml,
      automation/Catzc.Base.RootConfig/configs/rootconfig.yml,
      automation/Catzc.Base.Languages/configs/file-carriers.yml,
    ]
---

# Catzc.Types.csproj: a generated file with a head

`automation/.internal/assets/Catzc.Types.csproj` is a generated root-config target, written by `Build-RootConfig` from the authored
`automation/Catzc.Base.TypesSystem/assets/Catzc.Types.csproj.xml`, and it opens with a meta head like every other generated file.

## Landed

- The root-config entry (`rootconfig.yml`, `committed: true`) names the `.xml` source and the carrier `msbuild-project`.
- `file-carriers.yml` holds `msbuild-project`: a comment head whose delimiters are the processing instruction `<?catzc` and `?>`, scoped to
  this one file. An XML comment cannot hold the `---` fence, so a processing instruction carries it.
- `.gitattributes` (from `assets/root/.gitattributes`) marks the file `linguist-generated` and `eol=lf`, which also keeps the file-meta gate
  from reading its `source` key.
- Checked: `Test-FileMeta` on the file, `Test-RootConfigIntegrity`, `Test-GeneratedFileCurrent`, `Test-RootConfigFiles`, and `dotnet
  restore` plus `dotnet build` of the project, 0 warnings and 0 errors.

## Open

- **Q1.** The editor's project loader reported `MSB4025` ("Name cannot begin with the '\n' character", line 1, position 3). `dotnet build`
  and `System.Xml` both load the same file, so a stale copy is the first suspect. Reload the window and see whether it returns.
  - Gone: close this plan.
  - Back: the head moves into the project as a CDATA property (`Project` > `PropertyGroup` > one property), a new XML property carrier in
    `Catzc.Base.CodeMeta` and `Catzc.Base.Languages` with its tests and page, and `msbuild-project` becomes that carrier.
- **Q2.** Four tests in `Build-RootConfig.Tests.ps1` compare an exact head text and fail; they are about fixture files. Run them against
  the tree without this change to learn whether they failed before it.
- The index holds one `automation/.compiled/Catzc.Types.<hash>.dll`; it goes stale at every `types/*.cs` edit, and staging it is the
  user's.
