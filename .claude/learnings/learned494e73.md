# Session learnings 494e73

Started 2026-10-21T02:20:59.6603823+02:00.

- 2026-10-21: Truth is the whole repository at one commit, committed files only; only in the listen mode is the editor's edit fact over the
  tree (ADR-REPO-AI-EDITORISFACT).
- 2026-10-21: The rule, docs, code order sequences plan steps and never ranks truth; one repository is one responsibility domain
  (ADR-THES-STORES-RESPONSIBILITYDOMAIN).
- 2026-10-21: eac is a sibling repository read for ideas only, and catzc's ADRs decide.
- 2026-10-21: Most needs are already met: file kinds (Get-FileKind), TimeLimit, DurableHash, Copy-Directory, Build-AgentHook and
  Install-VSCodeExtension.
- 2026-10-21: Every wait is bounded, executables too: a long call inside a command gets that command's TimeLimit, never a workaround.
- 2026-10-21: Under strict mode an if or try assigned to a variable collapses to $null or one item, so .Count throws
  (Measure-NoCollapsingAssignment flags it).
- 2026-10-21: PowerShell passes $null to a .NET string parameter as an empty string.
- 2026-10-21: Sessions edit, stage and commit at the same time, so check git status before touching a shared file and re-read it before
  relying on it.
- 2026-10-21: out/ can be wiped at any time; a run reads back only its own stamped folder there and waits through its absence.
- 2026-10-21: A new tool counts as working only after a live run; green tests alone miss real bugs.
- 2026-10-21: The BCL ADRs live in docs/adr/automation/BCL/ and their references in docs/references/BCL/, outside the pwsh folders.
- 2026-10-21: Only 14 of 309 types use PowerShell's library (object unwrapping, WildcardPattern, the parser or runspace), and only the
  parser and runspace need it.
- 2026-10-21: A host-bound file is one listed exception with its reason, never a second folder (configure, don't program).
- 2026-10-21: A new plan needs three parts: the plan file, a row in value-of-plan.md and a line in plan-master.md.
- 2026-10-21: Test-Plans checks the whole plans folder, so another session's plan can fail your check.
- 2026-10-21: Overlapping plan work goes through the plan orchestration agent, which hands out free steps by message and expects each
  verdict line verbatim.
- 2026-10-21: Format-FileMeta's time goes to many small processor calls, not file reads, so setup belongs once per run, not once per file.
- 2026-10-21: A file's head depends on more than its bytes: cites come partly from its comment page and edges from which test and page files
  exist.
- 2026-10-21: A head lists its file's own cites first, then its page's, not alphabetically.
- 2026-10-21: Fact processors call Get-RepositoryRoot, not the -RepositoryRoot passed in, so a test with a temporary root mocks it.
- 2026-10-21: A private function runs only as `& (Get-Module X) { … }`, and the caller's variables are not visible inside that block.
- 2026-10-21: PowerShell costs about 0.1 ms per cmdlet call, which multiplies across about 4,600 files and 17 kinds.
- 2026-10-21: A cats command that looks hung is usually a long silent loop: Build-Diagrams spends 1.5-2.5 s per folder on minimap data and
  about 1 s on a render.
- 2026-10-21: Minimap data derives from the ADRs, so one ADR commit can redraw many diagrams' side panels while their bodies stay the same.
- 2026-10-21: A diagram sample in out/ needs the private Write-DiagramMinimapData before put; Build-Diagrams takes only folders under
  .assets/.
- 2026-10-21: Write-Progress is banned by the NoRawConsoleWrite rule; progress goes through Write-Message, one line per item.
- 2026-10-21: drawio.yml gives a folder the legend role, but the renderer's missing-diagram warning ignores it.
- 2026-10-21: A recursive grep over the tree runs past the 3 s foreground limit; the Grep tool answers in time.
- 2026-10-21: Each pwsh check needs a script under out/ and one bounded background call, since a background call runs one command.
- 2026-10-21: Test-Plans rejects an open step that names no check (ADR-REPO-PLANS-OPENSTEP).
- 2026-10-21: The user's instruction comes before an orchestrator's assignment.
- 2026-10-21: catzc usually holds most of a feature already: look first for the policy setting, template or edge to change.
- 2026-10-21: Switching heads on for a set of files switches on every fact they carry, about 19 lines per file.
- 2026-10-21: A link in a head is repository-relative; a code link elsewhere starts with `/`.
- 2026-10-21: Peers can overwrite each other's out/ scripts, so give a script a name your session owns.
- 2026-10-21: Test-Formatting takes -Language, not -Path; check a gate's parameters before calling it.
- 2026-10-21: Before taking on a peer's item, check whether another plan already owns it.
- 2026-10-21: FileHeadPolicy defaults pages to required, almost every code file has a comment page, and the 13 place-fact kinds apply to
  every file.
- 2026-10-21: Generated files get their heads from their writers, never from the head engine.
- 2026-10-21: A body sha on authored code conflicts with ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY as that rule reads today.
- 2026-10-21: Nothing reads a head back (ADR-REPO-FILEMETA-NOREADBACK), so a head-key filler with no reader can be deleted.
- 2026-10-21: Format-Code -Language markdown also runs the file-meta step on plans.
- 2026-10-21: The orchestrator sends a plan's handoffs to the session that owns the plan.
- 2026-10-21: The glossary is enforced like code: contrasts go both ways, a term is defined only where its rule bolds it, and qualified
  forms are a closed list.
- 2026-10-21: Check a "never" rule against the tree before writing it.
- 2026-10-21: A capability's 10-line roof counts unindented lines, front matter included, so wrapping never helps and a new item merges into
  an existing one.
- 2026-10-21: A user-invocable skill sits beside the robot capabilities (ADR-REPO-AGENTS-USERSKILL).
- 2026-10-21: The user's main worry is a session vanishing without warning, so finalizing means the work is in the tree; the user does the
  clear.
- 2026-10-21: A repeat finalize with nothing new costs one short reply, no edits and no gate runs.
