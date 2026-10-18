---
task:
  status: open
  plans: [plan-fast-push-followups, plan-csproj-xml-head]
  value: medium
  blocked_on: nothing; step 5 is the user's by hand
  targets:
    [
      automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1,
      automation/Catzc.Base.CodeMeta,
      docs/references/automation/catzc-base-codemeta,
      automation/Catzc.Base.Git/Push-Dirty.ps1,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task-root-config-fixtures.md"
    folder: plans
    name: task-root-config-fixtures
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Task: the root-config fixture tests and the PropertyHead docs

Two plans share one failure: four tests in `Build-RootConfig.Tests.ps1` (lines 66, 71, 189, 206) compare an exact generated head and now see
`with_body_sha` and `repo_status` lines. Not caused by either plan's work; the generated-head config was changed by another session. The
csproj plan also leaves the PropertyHead page and two help blocks describing a JSON-only head. The fast-push plan's remaining items are the
user's.

## Steps

1. Run the four tests against a tree without the csproj change (`git stash` is the user's; instead read `git log -p` of `generated-head.yml`
   and `Format-GeneratedFileHead.ps1` since 2026-10-16 to find the change that added the two keys). Record which change moved the head in
   both plans. Check: the commit or change is named.
2. Fix one side: if the head is right (body-sha Phase 0 makes `with_body_sha` required on generated files), the four fixture expectations
   gain the keys; if the head is wrong for fixture files, the generator is fixed. One file. Check: `Build-RootConfig.Tests.ps1` passes.
3. `docs/references/automation/catzc-base-codemeta/types/PropertyHead.md` (or its generated source): describe the XML form (a CDATA property
   `CatzcMeta` in the first `PropertyGroup Label="catzc"`) beside the JSON form. If the page is generated from the type's comments, edit the
   comment in `PropertyHead.cs` and regenerate. Check: Test-Links, Test-GeneratedFiles clean.
4. `Format-PropertyMetaHead` and `Get-PropertyMetaState` help: the head block names both carriers. Check: Test-Links on their pages;
   Test-Help clean.
5. By hand, the user's: a keybinding for the "Push dirty" task (`workbench.action.tasks.runTask`, args `Push dirty`) in the user
   keybindings; one real `Push-Dirty` run against the remote (the tests mock every git call). Check: the user reports the run.
6. The Test-AdrRegistry ADR-AI finding closes with the ADR-AI registration; the Test-Glossary findings in plans are D15 and the folder
   hygiene's step 10. Record both pointers in `plan-fast-push-followups.md`. Check: the lines exist.
7. Tick both plans' steps; both are deleted in task-closing-sweep. Check: grep `- [ ]` in both counts zero.

## Report

As report-fixed.
