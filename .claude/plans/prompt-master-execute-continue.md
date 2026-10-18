---
prompt:
  for: a fresh session that executes the task files of plan-master.md
  written: 2026-10-17
  plan: plan-master
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/prompt-master-execute-continue.md"
    folder: plans
    name: prompt-master-execute-continue
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Prompt: execute the next task of the master plan

You are continuing work in `C:\projects\catzc`. Read `.claude/CLAUDE.md`, then `docs/adr/index.md` (cite rules by code; never sweep the
corpus), then `docs/adr/repository/ai-agent-contract.md` (ADR-AI). Then read `.claude/plans/plan-master.md`: its Process section is the
method, its Chunks section is the order. Each pointer line names a `taskNNN.md` in the same folder.

Pick the first task whose `blocked_on` is satisfied, in numeric order; a decision round runs only when the user is present to answer. Read
that task file in full before any edit. Read the plans its head names, head first, then the sections the task cites. Trust the tree over the
task text: if a step's premise is contradicted by a read, record the correction in the owning plan and in the task file, then continue with
the next step.

Rules that bind every step:

- One file per step, verified before the next; the Edit tool, never a script sweep. Every Bash call carries `timeout: 3000`; anything that
  imports cats runs in the background as `timeout <seconds> pwsh -NoProfile -File out/<name>.ps1` with one command inside. A denied call is
  a blocker to report, not to retry larger.
- No mutating git. A step marked "the user's" is listed for the user, not run. Peer-dirty files (`git status --short` first) are skipped and
  named.
- Tests cost: run the one gate or Pester file a step's check names, in the background, and read its verdict; never Test-Automation. Never
  claim a check passed unless you saw it pass.
- A default is declared once on its config type; present tense in every doc; no history, no legacy alias; terms as the glossary defines them
  ("domain rules", never "house rules"; "all tests", never "full suite").
- The plans folder is the record: tick a plan's checkbox only when the tree holds the work; a task step done is ticked in the task file with
  its check's verdict line.

Stop and ask when a step needs an unsettled decision (an open item of the newest `decisions-*.md`), a mutating git command, an external
binding, or the P4 folder move; otherwise finish the task.

End with the report-fixed shape: files touched (created, edited, deleted; asks for shared files), checks run with each verdict line verbatim
and its report path, left undone with the reason. Then one line: the next task number and whether it is blocked.
