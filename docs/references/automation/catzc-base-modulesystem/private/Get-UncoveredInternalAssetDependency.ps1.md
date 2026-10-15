---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-UncoveredInternalAssetDependency.ps1.md
    kind: reference
    body_sha: ee02af0083b1
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-AUTO-TEST#13
      - ADR-PWSH-PESTER#5
---

# automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Takes the inventory (Get-InternalAssetDependency) and, for every function in it, looks for a test that
satisfies [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3). The
function's test files are the ones in its own module's tests/ folder
named for it: <Function>.Tests.ps1, or <Function>.<suffix>.Tests.ps1 for a cross-cutting test file
([ADR-PWSH-PESTER#5](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester5)). Each file is parsed,
never run: every It block's tags are the union of its own -Tag
values and those of each enclosing Describe and Context (the block chain,
[ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13)/27). A test
qualifies when its chain carries the citation 'ADR-AUTO-ASSETDEP#3' and does not carry 'source-only' —
so it runs in both the source run and the build run.

Returns one record per uncovered function: { Module; Function; ChildPath; TestFile; Reason }, where Module
is the module that defines the function, ChildPath the child paths its calls read (sorted, unique; '.'
for a call that names the module folder itself), and
TestFile the repository-relative test files that were inspected (empty when none exists). Returns nothing
when every function is covered.
```
