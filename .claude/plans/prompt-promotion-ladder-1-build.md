---
prompt:
  for: a fresh session, after prompt-closeout-1-decisions and after the prompt-layers-1-retire-and-rename session has ended
  written: 2026-10-18
  plan: plan-promotion-ladder
---

# Prompt: build the promotion ladder

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-promotion-ladder.md`, its Q1 to Q4 answers in `.claude/plans/decisions-2026-10-19.md` (stop and ask if any is open
without a working assumption), `out/reports/layers-1.md` for the pipeline names as they now are, then in full
`docs/adr/design/commit-lifecycle.md`, `docs/adr/flow/cd-discipline-and-promotion-flow.md` and `docs/adr/flow/pipeline-runner-pattern.md`,
and `docs/how-to/automation/apply-environment-approvals.md`.

Build the ladder as the answers decide, one file at a time: `pipelines/README.md` naming the ladder's environments and the pipeline that
deploys each; the environments and their approval checks in `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml` and its config
type with defaults declared once (ADR-AUTO-DEFAULT#6); the pipeline YAML for main-uat, release-uat behind the RC gate, pre-prod behind
the RBC gate, and the separate DEPLOY pipeline taking the CI artifact as Q4 decides; every decision an ADR rule in ADR-DSGN-LIFE or
ADR-FLOW-CD in the same change (ADR-REPO-PLANS#9), registered in `pwsh/Catzc.Base.Docs/configs/adrs.yml` (re-read it right before the
append), `Build-AdrIndex` run, never `docs/adr/index.md` by hand. Config over code: a per-environment value is a config entry, not a
branch in a script. A real run is the user's; say in the report which run proves which rung.

Owns: `pipelines/**`, the workflow files, `pwsh/Catzc.Azure.DevOps/**`, the two ADR pages, `adrs.yml`, the lifecycle articles under
`docs/explanation/design/` and `docs/explanation/flow/` (text only). Re-read a file right before editing it; each verified by
`Test-Pipelines` and `Test-AdoPipelineTriggerGlob` on the YAML, the config type's test file under `Invoke-TestFile`, `Test-AdrRegistry`,
`Test-Links -Path`. Never run Test-Automation or a gate over the whole tree; a final session does that once, last. Never edit
`.claude/plans`. No git add, commit, push or mv. Every Bash call runs under the time safeguard (foreground `timeout: 3000`; longer work in
the background behind a GNU `timeout` prefix). The typed DLL under `pwsh/.compiled` is ignored.

End by writing `out/reports/promotion-ladder-1.md`: what landed with each verdict line, the runs the user must make and what each
proves, what is left, every file touched.
