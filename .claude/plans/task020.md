---
task:
  id: "020"
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: C1 can start after task017; C2 to C6 entirely before or entirely after P4, never inside its window
  targets:
    [
      docs/adr/repository,
      automation/Catzc.Base.Contracts,
      contracts/catzc/0.0.0,
      automation/Catzc.Base.RootConfig,
      automation/Catzc.Base.Languages,
    ]
catzc:
  immutable:
    with_body_sha: "0ea4535b2a27"
    repo_status: clean
    path: ".claude/plans/task020.md"
    folder: plans
    name: task020
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-REPO-CONTRACT#6
---

# task020: command contracts, P7

Decided (Q9, Q-C1 to Q-C6): `<Module>/<Verb-Noun>.command.yml` under `contracts/catzc/0.0.0`, grammar shape A (one string per parameter),
closed type set (string, int, bool, switch, Catzc.* type, []; `path` later), pilot set first, `cats` validation in C5, no `errors:` key in
0.0.0. F6, S5: most of the 439 public functions become internal after the pilot; the pilot contracts are hand-written. A contract asset is
bytes the check compares, marked `catzc-contract` in .gitattributes, never reformatted. Prepare pass first (section 7 of the carried
contracts plan).

## Steps

1. Prepare, read-only: `Get-ContractAssetKind`, `Get-ContractCheckResults`, the `ContractAsset*` types and the Test-Contracts tests; what
   Test-Contracts reports for an unknown suffix today (on a copy under TestDrive); the handlers-by-language decision from task011 step 3.
   Record in the plan. Check: three facts recorded.
2. C1 `docs/adr/repository/command-contracts.md`, ADR-REPO-CMDCONTRACT: rules 1 a command is public exactly when a command contract names
   it; 2 the contract language and its closed types; 3 derived facts (placement says module, version, language; none stored); 4 one checker
   per language; 5 use (reader, reference column, cats validation); 6 version and pinning. Amend ADR-REPO-CONTRACT#6 (fifth kind) and #7
   (direction by kind) and its enforcement list. Glossary: command contract, contract language (command is task017's). `adrs.yml`,
   `Build-AdrIndex`, `Build-Glossary`. Check: Test-AdrRegistry, Test-Glossary, Test-Links clean.
3. C2 `Catzc.Base.Contracts`: `ContractAssetKind.Command`; one branch in `Get-ContractAssetKind`; C# `ContractCommand` and
   `ContractParameter` with defaults on the type (fresh pwsh); L0 tests with widget/gadget fixtures; `Get-ContractCommandFindings` compares
   a contract to a `.ps1` AST with L0 tests over fixture text; `command.schema.json`. Check: each new file's Pester file passes.
4. C3 pilot contracts, proposed to the user first as a list (the cats entry point's commands are the likely answer; the draft's set is the 8
   Catzc.Base.Languages and 5 Catzc.Base.Contracts commands): one `.command.yml` per command, provided; the existing contract L1 test file
   extended so one test per asset enumerates them. Check: Test-Contracts clean; the L1 file passes.
5. C4 `Get-CommandContract` reader; a signature column in `Build-ContractReference`; Test-GeneratedFiles covers the page. Check: both gates.
6. C5 `cats` validation and coercion: generator plus committed lookup, edited through the `importer.sh` source in `Catzc.Base.RootConfig` (a
   generated root file, never by hand); per-engine bats tests under `bash/tests` and the engine-case tables. Check: the bats file passes;
   Test-GeneratedFiles clean.
7. C6 widen: the 15 near-identical tool wrappers as the second batch (one family, one grammar); then the F6 decision applied: every public
   function without a contract becomes internal, one module per step, its `.psd1` export list regenerated. Check: Test-Contracts on the
   frozen set; the module's tests pass.
8. Tick P7 in `plan-layers-vocabulary-rename-contracts.md`; when every phase is ticked the plan is trimmed of its carried drafts and deleted
   in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
