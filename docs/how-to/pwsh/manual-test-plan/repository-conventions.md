# Manual test plan — Repository conventions

Folder, file, and naming conventions, the repository path helpers, the git index, and the managed-GUID registry. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                                             |
| --- | ---- | --------------------------------------------------------------------------------- |
| 1   | L0   | [Folder & file conventions][c1]                                                   |
| 2   | L0   | [Source & test file conventions][c2]                                              |
| 3   | L1   | [Get-TrackedFile (real index)][c3]                                                |
| 4   | L1   | [Test titles use angle-bracket templates only on data-driven tests][c4]           |
| 5   | L1   | [Repository guid integrity][c5]                                                   |
| 6   | L2   | [Checked-in binaries are stored as binary, not text][c6]                          |
| 7   | L2   | [Get-GitTrackedPath (real git)][c7]                                               |
| 8   | L1   | [Get-FileLanguage — the real repository][c8]                                      |
| 9   | L1   | [Get-Contract on the repository][c9]                                              |
| 10  | L1   | [Get-ContractCheckResults on the repository][c10]                                 |
| 11  | L1   | [Test-Contracts on the repository][c11]                                           |
| 12  | L1   | [Binding contract assets][c12]                                                    |
| 13  | L1   | [Released contract version folders][c13]                                          |
| 14  | L1   | [Get-WorldMap — the real repository][c14]                                         |
| 15  | L1   | [Get-WorldMapHighlight — the real repository][c15]                                |
| 16  | L1   | [Export-WorldMapPdf — the real repository][c16]                                   |
| 17  | L1   | [Test-WorldMap on the repository][c17]                                            |
| 18  | L1   | [Build-ContractReference — generated contract reference][c18]                     |
| 19  | L1   | [Test-ValueChainMap on the repository][c19]                                       |
| 20  | L1   | [Get-ValueChainMap — the real registry][c20]                                      |
| 21  | L1   | [Get-ValueChainHighlight — the real registry][c21]                                |
| 22  | L0   | [Parameter consistency of the public functions][c22]                              |
| 23  | L1   | [Get-Track — the real repository][c23]                                            |
| 24  | L0   | [File meta processor coverage][c24]                                               |
| 25  | L1   | [Get-ChildPath (shipped folder-walk.yml)][c25]                                    |
| 26  | L1   | [The provided head contract][c26]                                                 |
| 27  | L1   | [Command contracts][c27]                                                          |
| 28  | L1   | [New-CommandLookup — the real contracts][c28]                                     |
| 29  | L1   | [Test-ParameterConsistency — shipped configs/parameter-consistency.yml][c29]      |
| 30  | L1   | [Test-ManagedGuids — shipped configs/guids.yml][c30]                              |
| 31  | L1   | [Get-GuidScanFiles — shipped configs/guids.yml][c31]                              |
| 32  | L1   | [Get-TrackPlace — the real repository][c32]                                       |
| 33  | L1   | [ConvertTo-NormalName and ConvertFrom-NormalName over the tracked functions][c33] |
| 34  | L1   | [Get-GridMinimapData][c34]                                                        |
| 35  | L1   | [ContractCommand.ToAssetText — every shipped command asset round-trips][c35]      |
| 36  | L1   | [ValidatePathGiven on the whole-tree commands][c36]                               |
| 37  | L0   | [Get-FileKind][c37]                                                               |
| 38  | L2   | [Get-WorldMapHighlight on the working tree][c38]                                  |
| 39  | L1   | [Resolve-ModuleName — the real pwsh track][c39]                                   |

[c1]: #1-folder--file-conventions
[c2]: #2-source--test-file-conventions
[c3]: #3-get-trackedfile-real-index
[c4]: #4-test-titles-use-angle-bracket-templates-only-on-data-driven-tests
[c5]: #5-repository-guid-integrity
[c6]: #6-checked-in-binaries-are-stored-as-binary-not-text
[c7]: #7-get-gittrackedpath-real-git
[c8]: #8-get-filelanguage--the-real-repository
[c9]: #9-get-contract-on-the-repository
[c10]: #10-get-contractcheckresults-on-the-repository
[c11]: #11-test-contracts-on-the-repository
[c12]: #12-binding-contract-assets
[c13]: #13-released-contract-version-folders
[c14]: #14-get-worldmap--the-real-repository
[c15]: #15-get-worldmaphighlight--the-real-repository
[c16]: #16-export-worldmappdf--the-real-repository
[c17]: #17-test-worldmap-on-the-repository
[c18]: #18-build-contractreference--generated-contract-reference
[c19]: #19-test-valuechainmap-on-the-repository
[c20]: #20-get-valuechainmap--the-real-registry
[c21]: #21-get-valuechainhighlight--the-real-registry
[c22]: #22-parameter-consistency-of-the-public-functions
[c23]: #23-get-track--the-real-repository
[c24]: #24-file-meta-processor-coverage
[c25]: #25-get-childpath-shipped-folder-walkyml
[c26]: #26-the-provided-head-contract
[c27]: #27-command-contracts
[c28]: #28-new-commandlookup--the-real-contracts
[c29]: #29-test-parameterconsistency--shipped-configsparameter-consistencyyml
[c30]: #30-test-managedguids--shipped-configsguidsyml
[c31]: #31-get-guidscanfiles--shipped-configsguidsyml
[c32]: #32-get-trackplace--the-real-repository
[c33]: #33-convertto-normalname-and-convertfrom-normalname-over-the-tracked-functions
[c34]: #34-get-gridminimapdata
[c35]: #35-contractcommandtoassettext--every-shipped-command-asset-round-trips
[c36]: #36-validatepathgiven-on-the-whole-tree-commands
[c37]: #37-get-filekind
[c38]: #38-get-worldmaphighlight-on-the-working-tree
[c39]: #39-resolve-modulename--the-real-pwsh-track

## Checks

### 1. Folder & file conventions

**Test file:** `pwsh/.internal/tests/Test-FolderConventions.Tests.ps1` (L0), block `Folder & file conventions`.

**Guards:** the repository's conventional folder structure for automation, naming, and a single global function namespace.

**Checks:**

- Module subdirectories are limited to the conventional names (`private`, `tests`, `assets`, `types`, `configs`).
- `*.Tests.ps1` files live only under `tests/`.
- No public function name is exported by more than one module.
- `configs/` entries are flat kebab-case `.yml` (never `.yaml`, never nested); no legacy `assets/config/` or `assets/test/`.

### 2. Source & test file conventions

**Test file:** `pwsh/Base.QualityGates/tests/Test-Automation.Tests.ps1` (L0), block `Source & test file conventions`.

**Guards:** one-function-per-file, Verb-Noun naming, and a repo-wide unique function namespace.

**Checks:**

- The scan found >100 source and test files (guards against a silent no-op).
- Every source file is Verb-Noun, defines exactly one top-level function, and that function matches the file name.
- Every test file is `Verb-Noun.Tests.ps1`.
- Every function name (public and private) is defined in exactly one file across the repo.

### 3. Get-TrackedFile (real index)

**Test file:** `pwsh/Base.Globs/tests/Get-TrackedFile.Tests.ps1` (L1), block `Get-TrackedFile (real index)`.

**Guards:** The real tracked-file universe comes back repo-relative and /-separated, read in-process from the git index.

### 4. Test titles use angle-bracket templates only on data-driven tests

**Test file:** `pwsh/Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1` (L1), block
`Test titles use angle-bracket templates only on data-driven tests`.

**Guards:** No It/Describe title carries a Pester template token without -ForEach data — the strict-caller name-expansion trap is banned.

### 5. Repository guid integrity

**Test file:** `pwsh/Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1` (L1), block `Repository guid integrity`.

**Guards:** the managed-GUID registry and the tracked tree agree in both directions.

**Checks:**

- Every GUID literal found in tracked text (`Get-RepositoryGuids` over the scan universe) is registered in
  `Catzc.Base.QualityGates/configs/guids.yml`.
- Every registry entry is live — at least one tracked file references its guid.

### 6. Checked-in binaries are stored as binary, not text

**Test file:** `pwsh/Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1` (L2), block
`Checked-in binaries are stored as binary, not text`.

**Guards:** checked-in binaries are stored without EOL conversion.

**Checks:**

- Checked-in binaries are found (guards against a vacuous pass).
- Each is stored with no EOL conversion (git index `-text`) and carries an explicit binary `.gitattributes` rule.

**Prerequisite:** git.

### 7. Get-GitTrackedPath (real git)

**Test file:** `pwsh/Base.Files/tests/Get-GitTrackedPath.Tests.ps1` (L2), block `Get-GitTrackedPath (real git)`.

**Guards:** The in-process git index reader answers exactly what `git ls-files` prints for this repository, whole and pathspec-limited.

### 8. Get-FileLanguage — the real repository

**Test file:** `pwsh/Base.Languages/tests/Get-FileLanguage.Tests.ps1` (L1), block `Get-FileLanguage — the real repository`.

**Guards:** Every root folder git tracks a file under is a declared track, each track's file languages are registered, and every live file
of a track is in one of its declared file languages (DDR-TRACK-ONETECHSTACK, DDR-TRACK-FILELANGUAGE).

### 9. Get-Contract on the repository

**Test file:** `pwsh/Base.Contracts/tests/Get-Contract.Repository.Tests.ps1` (L1), block `Get-Contract on the repository`.

**Guards:** The repository's contracts/ tree lists every version of every unit without error, each asset under contracts/
(ADR-REPO-CONTRACT-LAYOUT).

### 10. Get-ContractCheckResults on the repository

**Test file:** `pwsh/Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1` (L1), block
`Get-ContractCheckResults on the repository`.

**Guards:** Checking every asset of every unit's draft returns one result per asset, without error (ADR-REPO-CONTRACT-PROVENBYTESTS).

### 11. Test-Contracts on the repository

**Test file:** `pwsh/Base.Contracts/tests/Test-Contracts.Tests.ps1` (L1), block `Test-Contracts on the repository`.

**Guards:** The `Test-Contracts` quality gate reports 0 issues: every asset of each unit's draft and the provided assets of every released
version folder hold against the real tree, and every released folder matches its `.frozen` record (ADR-REPO-CONTRACT-PROVENBYTESTS,
ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).

### 12. Binding contract assets

**Test file:** `pwsh/Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1` (L1), block `Binding contract assets`.

**Guards:** One generated test per binding asset — every asset of each unit's draft, and the provided assets of every released version
folder — each passing its kind's check; no assets discovers no test (ADR-REPO-CONTRACT-PROVENBYTESTS).

### 13. Released contract version folders

**Test file:** `pwsh/Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1` (L1), block `Released contract version folders`.

**Guards:** One generated test per released version folder (any version but 0.0.0), each unchanged since its release against its `.frozen`
record; no released folder discovers no test (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).

### 14. Get-WorldMap — the real repository

**Test file:** `pwsh/Base.Maps/tests/Get-WorldMap.Tests.ps1` (L1), block `Get-WorldMap — the real repository`.

**Guards:** Every tracked file lands in exactly one world-map cell, and no cell is a stack violation (DDR-TRACK-ONETECHSTACK,
DDR-TRACK-FILELANGUAGE).

### 15. Get-WorldMapHighlight — the real repository

**Test file:** `pwsh/Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` (L1), block `Get-WorldMapHighlight — the real repository`.

**Guards:** A decision record's highlight lights at least one cell, and as a record file only the requested record's own file.

### 16. Export-WorldMapPdf — the real repository

**Test file:** `pwsh/Base.Maps/tests/Export-WorldMapPdf.Tests.ps1` (L1), block `Export-WorldMapPdf — the real repository`.

**Guards:** The real map exports non-empty grid and tree PDFs that parse.

### 17. Test-WorldMap on the repository

**Test file:** `pwsh/Base.Maps/tests/Test-WorldMap.Tests.ps1` (L1), block `Test-WorldMap on the repository`.

**Guards:** The `Test-WorldMap` quality gate reports 0 issues: no world-map cell is a stack violation, every root folder holding a tracked
file but `out/` is a declared track, and every printed label (maps.yml labels, track and file-language names) names a glossary term
(DDR-TRACK-ISPLACEDCLUSTER, DDR-TRACK-ONETECHSTACK).

### 18. Build-ContractReference — generated contract reference

**Test file:** `pwsh/Base.Contracts/tests/Build-ContractReference.Tests.ps1` (L1), block
`Build-ContractReference — generated contract reference`.

**Guards:** Each unit's committed contract page, `docs/references/contracts/<unit>.md`, is current with the contract assets
(ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS).

### 19. Test-ValueChainMap on the repository

**Test file:** `pwsh/Base.Maps/tests/Test-ValueChainMap.Tests.ps1` (L1), block `Test-ValueChainMap on the repository`.

**Guards:** The `Test-ValueChainMap` quality gate reports 0 issues: the value-chain map's rows and columns are the value-chain stack and the
value-chain concerns DrsConfig declares, in order, every decision record of drs.yml sits in at least one cell, and every value_chain_ label
of maps.yml names a glossary term (ADR-REPO-VALUECHAIN-STACK, ADR-REPO-VALUECHAIN-CONCERN, ADR-REPO-VALUECHAIN-MAP).

### 20. Get-ValueChainMap — the real registry

**Test file:** `pwsh/Base.Maps/tests/Get-ValueChainMap.Tests.ps1` (L1), block `Get-ValueChainMap — the real registry`.

**Guards:** Every decision record sits in exactly its value-chain concerns' cells on its domain's value-chain stack row
(ADR-REPO-VALUECHAIN-CONCERN).

### 21. Get-ValueChainHighlight — the real registry

**Test file:** `pwsh/Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` (L1), block `Get-ValueChainHighlight — the real registry`.

**Guards:** Every decision record's `#1` citation lights its row crossed with its value-chain concerns (DDR-TRACK-LITCELL).

### 22. Parameter consistency of the public functions

**Test file:** `pwsh/Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1` (L0), block
`Parameter consistency of the public functions`.

**Guards:** One parameter name carries one type across the public functions, apart from the names parameter-consistency.yml exempts with a
reason; an exemption that no longer conflicts is reported (ADR-PWSH-PARAM).

### 23. Get-Track — the real repository

**Test file:** `pwsh/Base.Variants/tests/Get-Track.Tests.ps1` (L1), block `Get-Track — the real repository`.

**Guards:** The unordered track is declared in the registry with its own class, and a path under it resolves to it
(DDR-TRACK-UNORDEREDTRACK).

### 24. File meta processor coverage

**Test file:** `pwsh/Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1` (L0), block `File meta processor coverage`.

**Guards:** Every kind of the shipped file-meta registry has its processor function and every processor function has its kind
(ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION).

### 25. Get-ChildPath (shipped folder-walk.yml)

**Test file:** `pwsh/Base.Folders/tests/Get-ChildPath.Tests.ps1` (L1), block `Get-ChildPath (shipped folder-walk.yml)`.

**Guards:** `Get-ChildPath` defaults to two levels, so the third is never loaded, and prunes the vendor folder by default from the registry
value (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER).

### 26. The provided head contract

**Test file:** `pwsh/Base.QualityGates/tests/Format-FileMeta.Contract.Tests.ps1` (L1), block `The provided head contract`.

**Guards:** The provided head contract lists exactly the place facts and edges the meta kinds and the generated-file head write, holds a
sample of only written keys, binds a code file to nothing outside its module and docs section, and requires the two keys no head is without
(ADR-REPO-CONTRACT-PROVENBYTESTS).

### 27. Command contracts

**Test file:** `pwsh/Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1` (L1), block `Command contracts`.

**Guards:** Every command asset of every contract unit reads as one typed record through Get-CommandContract, and the pilot set is all
there.

### 28. New-CommandLookup — the real contracts

**Test file:** `pwsh/Base.Contracts/tests/New-CommandLookup.Tests.ps1` (L1), block `New-CommandLookup — the real contracts`.

**Guards:** The command lookup that `cats` reads before pwsh starts is one quoted shell variable with a row per contracted parameter of
every command contract, and no row holds a quote that would end it (ADR-REPO-CMDCONTRACT-CONTRACTONEREADER).

### 29. Test-ParameterConsistency — shipped configs/parameter-consistency.yml

**Test file:** `pwsh/Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1` (L1), block
`Test-ParameterConsistency — shipped configs/parameter-consistency.yml`.

**Guards:** Test-ParameterConsistency finds the exemption list it names in the loaded module (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 30. Test-ManagedGuids — shipped configs/guids.yml

**Test file:** `pwsh/Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1` (L1), block `Test-ManagedGuids — shipped configs/guids.yml`.

**Guards:** Test-ManagedGuids finds the guid registry it names in the loaded module, with the denied all-zero guid
(ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 31. Get-GuidScanFiles — shipped configs/guids.yml

**Test file:** `pwsh/Base.QualityGates/tests/Get-GuidScanFiles.Tests.ps1` (L1), block `Get-GuidScanFiles — shipped configs/guids.yml`.

**Guards:** Get-GuidScanFiles finds the guid registry it leaves out of the scan in the loaded module (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 32. Get-TrackPlace — the real repository

**Test file:** `pwsh/Base.Variants/tests/Get-TrackPlace.Tests.ps1` (L1), block `Get-TrackPlace — the real repository`.

**Guards:** `Get-TrackPlace` places the three infrastructure kinds on their shipped folders.

### 33. ConvertTo-NormalName and ConvertFrom-NormalName over the tracked functions

**Test file:** `pwsh/Base.Languages/tests/ConvertTo-NormalName.Tests.ps1` (L1), block
`ConvertTo-NormalName and ConvertFrom-NormalName over the tracked functions`.

**Guards:** Every tracked PowerShell function name round-trips through the repository normal form.

### 34. Get-GridMinimapData

**Test file:** `pwsh/Base.Maps/tests/Get-GridMinimapData.Tests.ps1` (L1), block `Get-GridMinimapData`.

**Guards:** The world map grid of the tree, lit with reasons by the files that cite a code, meets the minimap contract.

### 35. ContractCommand.ToAssetText — every shipped command asset round-trips

**Test file:** `pwsh/Base.Contracts/tests/types/ContractCommand.Tests.ps1` (L1), block
`ContractCommand.ToAssetText — every shipped command asset round-trips`.

**Guards:** Every shipped command contract, written back by `ContractCommand.ToAssetText` with its names unchanged, reads back to the same
signature.

### 36. ValidatePathGiven on the whole-tree commands

**Test file:** `pwsh/Base.Asserts/tests/types/ValidatePathGivenAttribute.Tests.ps1` (L1), block
`ValidatePathGiven on the whole-tree commands`.

**Guards:** Every command that runs over the whole tree when -Path is left out carries ValidatePathGiven, so an empty -Path is refused
before its body runs.

### 37. Get-FileKind

**Test file:** `pwsh/Base.Globs/tests/Get-FileKind.Tests.ps1` (L0), block `Get-FileKind`.

**Guards:** the shipped file-kinds registry gives every kind of file its role (ADR-REPO-FILEMETA-METAKIND).

**Checks:**

- `Get-FileKind` resolves a real path of each kind, such as a function, a gate, a writer, an assert, a type, a config, a fixture, a diagram,
  a slide and a reference, to its role.

### 38. Get-WorldMapHighlight on the working tree

**Test file:** `pwsh/Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` (L2), block `Get-WorldMapHighlight — the real working tree`.

**Guards:** the highlight of the working tree's changes, read with git.

**Checks:**

- The zero-argument `Get-WorldMapHighlight` returns a `WorldMapHighlight` of kind `path` without error.

**Prerequisite:** git.

### 39. Resolve-ModuleName — the real pwsh track

**Test file:** `pwsh/.internal/tests/Resolve-ModuleName.Tests.ps1` (L1), block `Resolve-ModuleName — the real pwsh track`.

**Guards:** the pwsh track declares the `Catzc` namespace, the bootstrap reads the same namespace before the types load, and every module
folder resolves to its own full name through both `Resolve-ModuleName` and `VariantTrack.FullNameOf` (DDR-TRACK-MODULENAMESPACE).
