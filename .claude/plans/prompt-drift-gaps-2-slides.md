---
prompt:
  for: a fresh session, run in parallel with the other prompt-* files of 2026-10-18, but before prompt-diagram-folders-3-migration
  written: 2026-10-18
  plan: plan-explanation-drift-gaps
---

# Prompt: the five slides that draw retired claims

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-explanation-drift-gaps.md` (Decided Q1, Q4, Q5 and the open step on the five slides) and
`.claude/plans/task-explanation-drift-gaps.md` steps 5 and 6.

First the brief, no edit: for each of `rule-and-gate-per-load-stage` (markers 7, 8), `what-gates-each-bundle-stage` (marker 6),
`which-run-mode-rules-have-a-gate` (marker 8), `drift-is-gated-generation-is-adr-only` (marker 8 and its title) and
`tests-pin-the-throw-and-fail-open-no-caller` (marker 7 and its title), find the slide under `docs/explanation/**/.assets/`, its article,
its `.drawio.md` and its minimap pages; read the embedded model; write to `out/drift-slides-brief.md` the elements to remove or relabel
and the new title where one is due, with the ADR rule each change follows. Show the brief to the user and stop. On the user's go, in this
same session: labels and titles through the `write-drawio-files` robot; a cell set that must go is a `drawio-png` run per slide; the
article's text blocks and the `.drawio.md` follow; minimaps restamped with `.claude/drawio/minimaps/stamp.ps1` on those pages only.
Check per slide: the article's text blocks match the slide, `Test-Links -Path` on each touched page, `Test-FileMeta` on the folder.

Owns: the five slides' files and their articles, descriptions and minimap pages. Touch nothing else; re-read a file right before editing
it; one file at a time. Never run Test-Automation or a gate over the whole tree; a final session does that once, last. Never edit
`.claude/plans`. No git add, commit, push or mv. Every Bash call runs under the time safeguard (foreground `timeout: 3000`; a render goes
to the background behind a GNU `timeout` prefix). The typed DLL under `pwsh/.compiled` is ignored.

End by writing `out/reports/drift-gaps-2.md`: the brief's verdict, what landed with each check, what is left and why, every file touched.
