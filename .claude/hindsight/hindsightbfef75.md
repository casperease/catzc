# Hindsight

Started 2026-10-27T19:34:23.5689120+01:00.

- 2026-10-27 Jack: If only the config walker had read past Get-Config, it would know a config may be a folder of merged parts: half,
  `pwsh/Base.Config/Get-Config.ps1:58` reads a folder entry and `docs/drs/automation/consumer-overlay.md:166` names the merge, but no skill
  or how-to warns a gate that walks configs/.
- 2026-10-27 Jack: If only the contract tester had looked at the checker before matching on AssetPath alone: half,
  `pwsh/Base.Contracts/private/Get-ContractCheckResult.ps1:33` yields per-asset findings, and the one-record-per-Target rule lives in code,
  nowhere a session starts.
- 2026-10-27 Jack: If only the rename author had known git keeps the old case: half, `pwsh/Base.Git/tests/New-RepositorySnapshot.Tests.ps1:139`
  knows it and plan-idiomatic-names waits on the user's git mv, but no skill or how-to says a case-only rename is the user's.
- 2026-10-27 Jack: If only the GUID minter had read the managed-guids record: half, `docs/drs/automation/managed-guids.md:30` names
  SentenceGuid, which a session finds only by grepping the DRS.
- 2026-10-27 Jack: If only the types debugger had read the native-csharp-types record before chasing ghosts: half,
  `docs/drs/automation/BCL/native-csharp-types.md:218` explains -OutputAssembly, and the side-by-side-builds trap is nowhere a session
  starts.
- 2026-10-27 Jack: If only the session had checked git before blaming the tracked DLL: declared,
  `docs/drs/automation/BCL/native-csharp-types.md:196` says git keeps no file under pwsh/.compiled, git ls-files lists none, and plan-master
  says no step depends on it.
- 2026-10-27 Jack: If only the line-number tourist had known line numbers rot: half, the types-changed branch is explained only in comments
  of `pwsh/.internal/assets/bootstrap/Import-CSharpTypes.ps1`, and the CI throw ordering has no rule a session reads.
- 2026-10-27 Jack: If only the cache worrier had read the pipeline: automated, `.ado/pipelines/steps/cache-types.yaml:11` keys on
  `pwsh/**/types/**/*.cs` and the csproj, so neither the DLL nor its json manifest is tracked or keyed any more.
- 2026-10-27 Jack: If only the comment-page rewriter had read the engine page: half,
  `docs/references/pwsh/base-quality-gates/types/comment-engine.md` documents FreshPage and Page.Parse keeping prose above the first comment
  section, and no skill line points there.
- 2026-10-27 Jack: If only the comment mover had read its own run skill: declared, `.claude/skills/catzc-run/SKILL.md:34` says a moved code
  line edits its page's Above line too, which is what Test-Comments counts.
- 2026-10-27 Jack: If only the prose folder had read the verify skill: declared, `.claude/skills/catzc-verify/SKILL.md:41` says Test-Links
  rejects repository-rooted links in docs prose.
- 2026-10-27 Jack: If only the plan writer had let New-Plan write the plan: automated, `pwsh/Base.QualityGates/New-Plan.ps1:126` writes the
  Open steps section and `pwsh/Base.QualityGates/Test-Plans.ps1:287` demands a check on every open step, with its master line and value row.
- 2026-10-27 Jack: If only someone had counted the fresh-page leftovers before planning a sweep: half, `CommentEngine.FreshPage` still
  writes the opening (`docs/references/pwsh/base-quality-gates/types/comment-engine.md:8`), and no plan owns the 1,789 pages.
- 2026-10-27 Jack: If only the gate script author had read the type: half, QualityGateResult is described per gate on reference pages
  (`docs/references/pwsh/azure/test-azure-network-plan.md:32`), and no skill says it has Subject, Issues, ReportPath and Facts but no
  Passed.
- 2026-10-27 Jack: If only the config author had been warned that a file and a same-named folder clash: gap, nothing in the tree,
  `Get-Config.ps1:58` simply prefers the folder and no gate refuses the pair.
- 2026-10-27 Jack: If only the C# splitter had been told one public class per types file and no partial classes: gap, nothing in the tree,
  no loader message, skill or record says it.
- 2026-10-27 Jack: If only the bundle builder had trusted the closure check: automated, `pwsh/.internal/Catzc.Internal.Builder.psm1:235`
  throws on a missing internal asset dependency and `Test-InternalAssetDependency` gates it; the Invoke-ModuleBuild.Tests fixture list is
  still kept by hand.
- 2026-10-27 Jack: If only the new-file author had known the accosted word is reserved by scope: half, Test-Terminology refuses it through
  `pwsh/Base.QualityGates/configs/terminology/reserved.yml`, but no skill or brief template says to add the scope line up front.
- 2026-10-27 Jack: If only the code mover had remembered that pages anchor on code text: declared, `.claude/skills/catzc-run/SKILL.md:34`
  ties the page's Above line to the code line and Format-Code regenerates the page.
- 2026-10-27 Jack: If only the orchestrator had read the drone file: declared, `.claude/agents/drone-opus.md` step 4 sends a one-line
  message per landed file, so a turn roof loses one file, not three.
- 2026-10-27 Jack: If only the plan editor had listened to the hook: automated, `pwsh/Base.QualityGates/configs/edit-reminders.yml:6`
  reminds that Format-Code on a plan rewraps plan-master.md.
- 2026-10-27 Jack: If only the icon painter had found the reference page: half, `docs/references/pwsh/base-vs-code/configs/file-icons.md:1`
  describes file-icons.yml, but the glyph folder and the missing folder icons are nowhere a session starts.
- 2026-10-27 Jack: If only the plan author had run New-Plan: automated, it writes the master line and the value row together, and
  ADR-REPO-PLANS-THREEPARTS makes a missing one a Test-Plans finding.
- 2026-10-27 Jack: If only the script author had read catzc-run before writing out/ scripts: declared, `.claude/skills/catzc-run/SKILL.md:17`
  runs a cats command through the entry script, never an out/*.ps1 of its own, which settles every 'one out/ script' tip.
- 2026-10-27 Jack: If only the namespace hunter had found the resolver: automated,
  `pwsh/.internal/assets/bootstrap/Resolve-ModuleName.ps1:2` and VariantTrack.FullNameOf/FolderNameOf map folder and full name, and
  `.claude/CLAUDE.md` says module folders drop the prefix.
- 2026-10-27 Jack: If only a peer's half-done C# had stayed in a burst: declared, `.claude/skills/catzc-run/SKILL.md:34` parks a types/*.cs
  edit in out/ during a peer's burst and lands it staged.
- 2026-10-27 Jack: If only bash had been told to leave $p alone: declared, `.claude/skills/catzc-run/SKILL.md:19` puts every cats command in
  single quotes.
- 2026-10-27 Jack: If only the burst had trusted the XML over the console: automated, Invoke-CatzcCommand wraps a bare Tests.ps1 step in
  Invoke-TestFile and `.claude/skills/catzc-run/SKILL.md:29` reads the verdict from the results XML.
- 2026-10-27 Jack: If only the session had known the type-hash memo is disposable: half,
  `docs/references/pwsh/internal/catzc-internal-types.md:38` names Get-TypesStampPath, but deleting a stale stamp as the safe unblock is
  said nowhere a session starts.
- 2026-10-27 Jack: If only the contract author had read the how-to: declared, `docs/how-to/pwsh/add-a-command-contract.md:30` gives the
  group by `Get-ContractGroup -Module`, and Test-Contracts pins the description to the synopsis.
- 2026-10-27 Jack: If only the page lister had read the tracked-files record: half, `docs/drs/automation/tracked-files-from-the-index.md:8`
  says Get-TrackedFile names the tracked universe, so untracked new pages and uncommitted files read red, and no skill says so.
- 2026-10-27 Jack: If only the rebuild-hash tests knew about bursts: gap, nothing in the tree, a peer swap between their two live-tree
  builds still fails them with no code fault.
- 2026-10-27 Jack: If only the rename author had grepped every reader and spelling before the first burst: gap, nothing in the tree, no skill line
  asks for a reader sweep of a renamed key, token or type before staging.
- 2026-10-27 Jack: If only the namespace learner had looked once: automated, Test-TrackNamespace holds the declared exemptions
  (`docs/references/pwsh/base-quality-gates/test-track-namespace.md`) and VariantTrack.FolderNameOf applies to source roots only.
- 2026-10-27 Jack: If only the importer had waited for the swap: automated, `pwsh/.internal/assets/Enter-CatzcBurst.ps1:86` makes every
  other import wait out the burst through Wait-ImportBurst.
- 2026-10-27 Jack: If only the stager had trusted the base hash: automated, `pwsh/.internal/assets/Invoke-StagedBurst.ps1:49` records each
  target's SHA-256 and refuses a stale staged copy, so a live edit of a staged registry is refused, not lost.
- 2026-10-27 Jack: If only the width worrier had read the how-to: declared, `docs/how-to/automation/narrow-a-file-width.md:3` says
  Test-FileLimits measures width, while only the length roofs in `pwsh/Base.FileLimits/configs/file-limits.yml:3` fail.
- 2026-10-27 Jack: If only the orchestrator had read its own skill before re-pinging: declared,
  `.claude/skills/plan-orchestrate/SKILL.md:24` says an idle notice older than the last reply is stale, so a silent worker is checked, never
  reassigned blind.
- 2026-10-27 Jack: If only the mover had remembered agents never git mv: declared, `.claude/CLAUDE.md` forbids mutating git, so a move list
  for git mv is the user's and no csv is owed.
- 2026-10-27 Jack: If only the contract writer had let the gate judge: automated,
  `docs/references/pwsh/base-contracts/private/get-contract-description-findings.md:16` holds the description to the comment page's synopsis
  through PlainText.Plain.
- 2026-10-27 Jack: If only the help seeker had read function-help: half, ADR-REPO-HELP puts synopses on comment pages read by FunctionHelp,
  yet no skill tells a session not to look in the .ps1.
- 2026-10-27 Jack: If only the test counter had read the row type: half, catzc-run names `Invoke-TestFile -PassThru` but not that it returns
  Rows to count by Result, never a PassedCount.
- 2026-10-27 Jack: If only the contract-type changer had grepped the fixture builders first: half, `.claude/skills/catzc-module/SKILL.md:23`
  updates the contract with the command, but nothing says every test fixture building the type changes in the same burst.
- 2026-10-27 Jack: If only the module-root prober had read the bootstrap page: half,
  `docs/references/pwsh/internal/catzc-internal-bootstrap.md:62` explains module bases, and a New-Module's fake cwd-guid Path is in no
  skill.
- 2026-10-27 Jack: If only the re-render had used the burst without staging: declared, `.claude/skills/catzc-run/SKILL.md:24` runs an
  in-place step through Enter-CatzcBurst, so no unchanged carrier file is staged for Invoke-StagedBurst.
- 2026-10-27 Jack: If only the citation rewriter had read the how-to: declared, `docs/how-to/pwsh/rewrite-paths-after-a-move.md:9` gives the
  tab-separated code map Update-DrsCitation reads and says which rows it rewrites.
- 2026-10-27 Jack: If only the tester had passed test files by name: gap, nothing in the tree says Invoke-TestFile and Test-Parsing reject a
  dot-folder path such as pwsh/.internal.
- 2026-10-27 Jack: If only the list builder had known PowerShell flattens @(@()): gap, nothing in the tree, no strict-mode or pester how-to
  names nested-array flattening.
- 2026-10-27 Jack: If only the backslash editor had read catzc-run: declared, `.claude/skills/catzc-run/SKILL.md:39` writes any script
  holding backslashes with the Write tool, never a heredoc.
- 2026-10-27 Jack: If only the fresh-page counter had counted again: automated, a Grep finds the FreshPage opening sentence on 31 pages
  under docs/references today, not 1,789, so the exporter's own reruns did the sweep.
