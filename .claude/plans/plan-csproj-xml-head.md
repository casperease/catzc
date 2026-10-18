---
plan:
  status: active
  value: low
  reviewed: 2026-10-17
  targets:
    [
      automation/Catzc.Base.TypesSystem/assets/Catzc.Types.csproj.xml,
      automation/Catzc.Base.RootConfig/configs/rootconfig.yml,
      automation/Catzc.Base.Languages/configs/file-carriers.yml,
      automation/Catzc.Base.CodeMeta/types/PropertyHead.cs,
    ]
---

# Catzc.Types.csproj: a generated file with a head

`automation/.internal/assets/Catzc.Types.csproj` is a generated root-config target, written by `Build-RootConfig` from the authored
`automation/Catzc.Base.TypesSystem/assets/Catzc.Types.csproj.xml`, and it opens with a meta head like every other generated file.

## Landed

- The root-config entry (`rootconfig.yml`, `committed: true`) names the `.xml` source and the carrier `msbuild-project`.
- `file-carriers.yml` holds `msbuild-project`: a property carrier (`property: CatzcMeta`) scoped to this one file. A processing-instruction
  head was tried first and the editor's project loader refused it (`MSB4025`), so the block is a CDATA property of the first
  `PropertyGroup Label="catzc"` of the project. An XML comment cannot hold the `---` fence.
- `PropertyHead` (`Catzc.Base.CodeMeta`) reads and writes that form beside its JSON form, with six L0 tests in `PropertyHead.Tests.ps1`.
- `.gitattributes` (from `assets/root/.gitattributes`) marks the file `linguist-generated` and `eol=lf`.
- Checked: `PropertyHead.Tests.ps1` (20), `Test-FileMeta` on the file, `Test-RootConfigIntegrity`, `Test-GeneratedFileCurrent`,
  `FileCarriersConfig.Tests.ps1`, `Test-RootConfigFiles`, and `dotnet build` of the project (succeeds), and the project opens in the editor
  with no load error (2026-10-17 screenshot).

## Open steps

- [x] The `PropertyHead` page under `docs/references/automation/catzc-base-codemeta/types/` and the `Format-PropertyMetaHead` and
      `Get-PropertyMetaState` help still describe a JSON-only head; bring them to the XML form (check: `Test-Links` clean on the
      `PropertyHead` page and the two help pages, and each names the CDATA property form). Done 2026-10-18: the page, generated from the
      type's comments, already named the CDATA property of the labelled first PropertyGroup; the two help heads now name both carriers and
      `CatzcMeta` as the project's property. Format-Code's help step left both unchanged, `ANALYZER issues=0`, `FILEMETA issues=0`; the two
      functions have no comment page of their own.
- [x] Four tests in `Build-RootConfig.Tests.ps1` compare an exact head text and fail; they are about fixture files. Run them against the
      tree without this change to learn whether they failed before it (check: the four tests run against a tree without the change and the
      result is recorded here). 2026-10-18: they pass on the tree as it is (`out/test-file/20261018-120150-e2c30e`), so the run against an
      older tree is not needed; plan-fast-push-followups records the same verdict.
- Context: the index holds one `automation/.compiled/Catzc.Types.<hash>.dll`; it goes stale at every `types/*.cs` edit, and staging it is
  the user's.
