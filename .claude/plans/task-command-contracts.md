---
task:
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: C1 can start (the layers doctrine landed 2026-10-17); C2 to C6 entirely before or entirely after P4, never inside its window
  targets: [docs/adr/repository, pwsh/Catzc.Base.Contracts, contracts/catzc/0.0.0, pwsh/Catzc.Base.RootConfig, pwsh/Catzc.Base.Languages]
---

# Task: command contracts, P7

Decided (Q9, Q-C1 to Q-C6): `<Module>/<Verb-Noun>.command.yml` under `contracts/catzc/0.0.0`, grammar shape A (one string per parameter),
closed type set (string, int, bool, switch, Catzc.* type, []; `path` later), pilot set first, `cats` validation in C5, no `errors:` key in
0.0.0. F6, S5: most of the 439 public functions become internal after the pilot; the pilot contracts are hand-written. A contract asset is
bytes the check compares, marked `catzc-contract` in .gitattributes, never reformatted. Prepare pass first (section 7 of the carried
contracts plan).

## Steps

1. [x] Prepare, read-only: `Get-ContractAssetKind`, `Get-ContractCheckResults`, the `ContractAsset*` types and the Test-Contracts tests;
       what Test-Contracts reports for an unknown suffix today (on a copy under TestDrive); the handlers-by-language decision from
       task-module-model-closeout step 3. Record in the plan. Check: three facts recorded. Done 2026-10-17: the section "P7 prepare" of
       plan-layers-vocabulary-rename-contracts holds the three facts; the copy read `kind=Fragment direction=DependedOn` and failed with
       `the target 'Get-Thing.command.yml' does not exist` (`out/t020-unknown-suffix.ps1`).
2. [x] C1 `docs/adr/repository/command-contracts.md`, ADR-REPO-CMDCONTRACT: rules 1 a command is public exactly when a command contract
       names it; 2 the contract language and its closed types; 3 derived facts (placement says module, version, language; none stored); 4
       one checker per language; 5 use (reader, reference column, cats validation); 6 version and pinning. Amend ADR-REPO-CONTRACT#6 (fifth
       kind) and #7 (direction by kind) and its enforcement list. Glossary: command contract, contract language (command is layers').
       `adrs.yml`, `Build-AdrIndex`, `Build-Glossary`. Check: Test-AdrRegistry, Test-Glossary, Test-Links clean. Done 2026-10-17:
       `ADRREG issues=0` (`out/test-adr-registry/20261017-190652`), `NEUTRAL issues=0`, Test-Glossary 222 issues none on the touched files
       (`out/test-glossary/20261017-190705`), Test-Links clean on the ADR and `[Untracked]` only on the two pages that link it (the user's
       commit), Test-Markdownlint and Test-Spelling `issues=0` on the three pages after `cmdcontract` joined terminology.yml; the
       `code review` line of ADR-REPO-CONTRACT's enforcement list stands as is since the kind rule covers the asset. Correction recorded in
       the plan: no `command.schema.json`, the ContractCommand type is the one grammar.
3. [x] C2 `Catzc.Base.Contracts`: `ContractAssetKind.Command`; one branch in `Get-ContractAssetKind`; C# `ContractCommand` and
       `ContractParameter` with defaults on the type (fresh pwsh); L0 tests with widget/gadget fixtures; `Get-ContractCommandFindings`
       compares a contract to a `.ps1` AST with L0 tests over fixture text; `command.schema.json`. Check: each new file's Pester file
       passes. Done 2026-10-17: kind, types, `Read-CommandSignature` (the AST side), `Get-ContractCommandRoot` (the module root from
       Get-CatzcModule, a new dependency in dependencies.yml; NotImplemented for a non-PowerShell module),
       `Resolve-ContractAsset -CommandRoot`, the enumerators pass `-RepositoryRoot`, `Get-ContractCheckResult` dispatches the kind. No
       schema file (see the plan's correction). Verdicts: `[Invoke-TestFile] Passed` for ContractCommand.Tests
       (`out/test-file/20261017-192710-111858`), Read-CommandSignature.Tests (`20261017-192719-3acd6b`), Get-ContractCheckResults.Tests
       (`20261017-192726-123593`), Get-Contract.Tests (`20261017-192238-cd3760`), Get-ContractCommandRoot.Tests (`20261017-192226-d5b9bd`),
       Get-ContractAssetKind.Tests (`20261017-191657-e624f4`), the L1 Get-ContractCheckResults.Assets.Tests and Test-Contracts.Tests;
       `CONTRACTS issues=0`; `ANALYZER issues=0` on every touched file.
4. [x] C3 pilot contracts, the draft's set (D19, 2026-10-18): the 8 Catzc.Base.Languages and 5 Catzc.Base.Contracts commands; one
       `.command.yml` per command, provided; the existing contract L1 test file extended so one test per asset enumerates them. Check:
       Test-Contracts clean; the L1 file passes. Done 2026-10-18: 12 assets under `contracts/catzc/0.0.0`, each with its header comment.
       Correction from the tree: the two modules hold 15 public commands today, and three sit outside the contract language
       (ADR-REPO-CMDCONTRACT#2), so they stay uncontracted and internal until C6 decides their signatures: `Format-GeneratedFileHead` (an
       `object` parameter), `Get-Contract` (an `IDictionary` parameter) and `Test-Contracts` (a `pscustomobject` output). The 8 Languages
       commands are every other Languages command; the 4 Contracts commands are Build-ContractReference, Get-CommandContract,
       Get-ContractCheckResults and Publish-ContractRelease. Verdicts: `CONTRACTS issues=0` (`out/test-contracts/20261018-104227`),
       `GENERATED issues=0` after Build-ContractReference (`out/test-generated-files/20261018-104233`), `[Invoke-TestFile] Passed` for
       Get-ContractCheckResults.Assets.Tests with one case per command asset and the pilot count (`out/test-file/20261018-104359-b45947`),
       `ANALYZER issues=0`.
5. [x] C4 `Get-CommandContract` reader; a signature column in `Build-ContractReference`; Test-GeneratedFiles covers the page. Check: both
       gates. Done 2026-10-17: `Get-CommandContract` (public, the one reader; `ContractCommand` gained `asset`, `name` and `signature`), the
       Signature column with `none` for every other kind and `not readable (Test-Contracts reports it)` for a command contract that does not
       parse, the module's reference article lists the reader. Verdicts: `[Invoke-TestFile] Passed` for Get-CommandContract.Tests
       (`out/test-file/20261017-192734-5a36e9`) and Build-ContractReference.Tests (`20261017-192958-3a9d1c`); after Build-ContractReference
       and Build-Readme, `GENERATED issues=0`, `CONTRACTS issues=0`, `LINKS article issues=0`, `MDLINT article issues=0`,
       `ANALYZER issues=0`.
6. [x] C5 `cats` validation and coercion: generator plus committed lookup, edited through the `importer.sh` source in
       `Catzc.Base.RootConfig` (a generated root file, never by hand); per-engine bats tests under `bash/tests` and the engine-case tables.
       Check: the bats file passes; Test-GeneratedFiles clean. Done 2026-10-18: `New-CatsCommandLookup` (public, Contracts) renders the
       lookup from `Get-CommandContract`, one tab-separated row per contracted parameter with its type, list, mandatory and pipeline flags
       and the asset; Build-RootConfig writes it to the committed root file `importer-commands.sh` (a new rootconfig.yml entry with the
       contracts folder as its source; the RootConfig input stamp also covers the Contracts module, so a generator change re-renders it;
       RootConfig gained the Contracts dependency). `cats` in the importer.sh source checks a contracted command before pwsh starts: an
       unknown parameter, a missing mandatory one and an int that is not a whole number fail with the asset named, a switch passes as a
       flag, an int unquoted and a bool as `$true` or `$false`; a value passed by position skips the mandatory check; an uncontracted
       command passes as before; `CATZC_COMMAND_LOOKUP` names another lookup for a test. Verdicts: `[Invoke-TestFile] Passed` for
       New-CatsCommandLookup.Tests (`out/test-file/20261018-125505-204835`), Build-RootConfig.Tests and Get-RootConfigInputStamp.Tests; the
       six cats.bats cases pass under bash, three of them new; `SHELL issues=0`, `GENERATED issues=0`, `MODDEP issues=0`,
       `ANALYZER issues=0`; 34 lookup rows for the 12 contracts. Not covered: the zsh run of the bats file, since the bridge runs Bash tests
       under bash only; the check code avoids arrays and bash-only syntax for zsh.
7. C6 widen: the 15 near-identical tool wrappers as the second batch (one family, one grammar); then the F6 decision applied: every public
   function without a contract becomes internal, one module per step, its `.psd1` export list regenerated. Check: Test-Contracts on the
   frozen set; the module's tests pass. The widening done 2026-10-18. The list in `out/plan-help-registry-options.md` is gone (never
   tracked), so the family was read from the tree: the fifteen installers with the one signature `[string] $Version [switch] $Force` and no
   output (Install-AzCli, -Bicep, -Dotnet, -Go, -Java, -Shellcheck, -Terraform and -Uv in Toolchain; -Cspell, -Markdownlint, -NodeJs and
   -Prettier in Node; -Poetry, -PySpark and -Python in Python), each `Version` defaulting to its tools.yml lock, a computed default the
   contract leaves out. Verdicts: `CONTRACTS issues=0`, 27 contracted commands, the lookup regenerated to 64 rows,
   `[Invoke-TestFile] Passed` for Get-ContractCheckResults.Assets.Tests (`out/test-file/20261018-125926-c4bfcd`) and
   New-CatsCommandLookup.Tests, `GENERATED issues=0`. F6 under D21 (2026-10-18, the user: internal means internal to its module, as C#'s
   `internal` scopes to an assembly; a Catzc.Internal module is another thing): ADR-REPO-CMDCONTRACT#1 reworded to say so, a function other
   modules call stays exported with no promise. The inventory (`out/inventory-f6.sh`, one grep pass, `out/f6-inventory.tsv`) read the 457
   public functions: 27 contracted, 244 named by code outside their module, 139 named only in docs, 47 named nowhere outside it. Of the 47,
   the console commands are public and were contracted, the counterpart family of the installers: 20 `Uninstall-<Tool>` and 5
   `Remove-<Tool>` in Node, Provisioning, Python and Toolchain (52 contracted commands, `CONTRACTS issues=0`, the lookup and the reference
   regenerated, both contract test files passed). Two helpers only their own module calls moved to `private/` with their comment pages,
   their article rows and a test through `InModuleScope`: Get-WorldMapOutputRoot (Maps) and Get-ManagedGuids (QualityGates); each is
   unexported, its tests and the module's callers' tests pass, Test-Links, Test-Comments, Test-GeneratedFiles, Test-FileMeta and
   Test-ManagedGuids clean. Left exported, by the pair convention or as a module's own responsibility: Test-VendorModuleAvailable,
   Get-PermanentEnvironmentVariable, the Asserts and Files Test/Assert pairs, Assert-GitHubPurgeReady, New-SyntheticHistory,
   Set-CurrentAzSubscription and Save-PSReadLineKeyHandlerSet. The two questions the user delegated (2026-10-18, D26 and D27): of the twelve
   exported functions nothing calls, five were dead code and left the tree with their tests, pages and article rows (Assert-Null,
   Assert-PipelineEmpty, Get-LastExitCode, Wait-Mutex, ConvertTo-Dictionary); Assert-IsGuidInRange, Assert-FileIsLocked and
   Test-IsTimeoutExempt stay as halves of a Test/Assert pair, Write-CallStack and Write-CmdletParameterSet as debug writers,
   Get-FunctionDependencyTree with no contract (a `PSObject[]` parameter), and Remove-TokenFromHistory got its contract. Of the 139
   functions only docs name, 38 are named by a how-to; the 12 of them the closed language expresses got hand-written contracts
   (Clear-GlobSetProtection, Test-GlobSetAffected, Build-EnglishDictionary, Export-SpellingTriage, Format-MarkdownTitle,
   Install-DevBoxTools, Assert-DevBoxToolsStatus, Register-AdoBuildValidation, Invoke-Poetry, Get-RepositoryFile, Get-BicepTemplateNames,
   Get-BicepParameterModel); the rest stay exported with no promise: the gates return a `pscustomobject` under `-PassThru`, and
   Get-Inspiration and Export-WorldMapPdf use parameter sets, which the grammar cannot state. Verdicts: `CONTRACTS issues=0`, 65 contracted
   commands, `[Invoke-TestFile] Passed` for Get-ContractCheckResults.Assets.Tests and New-CatsCommandLookup.Tests
   (`out/test-file/20261018-135212-cc0b32`, `-135236-24560e`). Open, for a later language step: a type for gate results and a way to state
   parameter sets, which together would let the gates and the two set-based commands be contracted.
8. Tick P7 in `plan-layers-vocabulary-rename-contracts.md`; when every phase is ticked the plan is trimmed of its carried drafts and deleted
   in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
