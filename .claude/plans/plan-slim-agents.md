---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: feature
  targets:
    [
      .claude/agents,
      .claude/skills,
      pwsh/Catzc.Base.Docs/configs/agents.yml,
      pwsh/Catzc.Base.Docs/configs/capabilities.yml,
      docs/drs/repository/agent-definitions.md,
    ]
---

# Slim agents: four model drones, every job a skill

Today 22 robots (47914 bytes) preload 28 capabilities (46177 bytes, 2026-10-25), and most robots are one capability restated: the robot's
body and its capability say the same job twice. The rewrite keeps every job (each holds value) and moves it into one skill, and leaves four
robots that differ only in their model. A spawn then reads one drone body, the shared core, and the one job skill its brief names.

## Why its value is high

Every spawn pays for a robot body plus four to seven preloaded capabilities; the duplicates below are read twice in every spawn that loads
them, and every new job today costs a robot, a capability, two registry entries, a CLAUDE.md bullet and a line in `catzc-drone`'s
description. After it, a new job is one skill and one `capabilities.yml` entry.

## Decided (the user accepted the design, 2026-10-25)

- **Four robots**: `drone-haiku`, `drone-sonnet`, `drone-opus`, `drone-fable`. There is no standard or default drone (the user, 2026-10-25):
  every spawn names a skill, and the skill's `model_floor` picks the drone; `agents.yml` drops `standard:`. One body, the coordinator
  protocol of today's `catzc-drone` steps 1, 2, 5 and 6 (brief shape, repository rules, questions to the coordinator, report), plus one
  step: "load the skill the brief names with the Skill tool, then do its steps". Tools: `Bash, Read, Glob, Grep, Write, Edit, Skill`;
  `effort` low for haiku, medium otherwise; `skills: [catzc-core]`.
- **The minimal model is picked, never chosen by taste**: the spawner takes the drone whose model equals the job skill's `model_floor`;
  floors gain `fable`, ranked haiku < sonnet < opus < fable. A floor is lowered on evidence, never raised to be safe.
- **Main-session jobs are user skills** (ADR-REPO-AGENTS-USERSKILL), since they need the user, the session's peers or a tool a spawn lacks:
  `orchestrate` (ListAgents and SendMessage, and it already must run as the main session, plan-claude-diet step 6), `listen` (today
  `claude --agent listen-very-carefully-to-doc-changes`), `diagram-review` (interactive), `plan-decide` (AskUserQuestion), `drawio-waves`
  (spawns makers), `artifact-print` (Artifact tools), and `session-finalize` (already one).
- **A brief-loaded skill is neither orphan nor ghost**: `capabilities.yml` gains `invoked_by: brief` beside `robot` and `user`; such a skill
  is preloaded by no robot and named in a brief as `skill: <name>`.
- **Skills grow, robots shrink**: `roofs.capability_lines` goes from 10 to 30, the job skill absorbing the old robot body (at most 20) and
  its capability; `roofs.agent_body_lines` stays 20, and a drone uses about 8.
- **Personas move with their job**: `persona: Jack` and `persona: Susan from HR` move from the `agents.yml` entries to the skill entries in
  `capabilities.yml`.
- **Lost and accepted**: `disallowedTools` no longer keeps the read-only jobs (`gate`, `drs-review`, `fact-check`, `doc-scout`,
  `devbox-diagnose`) read-only; the skill's `allowed-tools` and its job line say so, and `Test-AgentDefinitions` checks that every read-only
  skill's `allowed-tools` holds no Write or Edit.

## Duplicates found

| Duplicate                                                                                                                    | Becomes                          |
| ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `catzc-run` + `git-readonly` + `report-fixed`, preloaded by 20 of 22 robots                                                  | `catzc-core`, preloaded by all   |
| `gate-runner` body = `catzc-check` + `catzc-subset`; `catzc-verify`'s per-file checks run the same gates                     | `catzc-gate` (+ verify's list)   |
| `catzc-drone` body vs `catzc-verify` and `catzc-module` ("one file at a time", "skip a peer-dirty file")                     | drone body + `catzc-module`      |
| `edit-diagram-yml` body = `drawio-declaration` steps + `drawio-look`                                                         | `drawio-edit`                    |
| `print-artifacts` body = `artifact-publish` steps 1 to 3                                                                     | `artifact-print`                 |
| `link-fixer` body = `md-links` steps 1 to 3                                                                                  | `md-links`                       |
| `drs-reviewer` body = `drs-cite` steps 1 to 3                                                                                | `drs-review` (+ `drs-cite`)      |
| `doc-pattern-scout` body = `listen-tiers`'s `Find-DocPattern` line                                                           | `listen-tiers`                   |
| `plan-clear`, `plan-intake`, `plan-decide` bodies = `plan-shape`, `plan-intake`, `plan-decide` skills                        | three skills, one each           |
| `2020-hindsight` = `hindsight-log`; `its-a-chore-…` = `debt-reduce`; `test-optimization` = `test-speed`                      | one skill each                   |
| `devbox-vscode-diagnostics` = `devbox-diagnose`; `diagram-review` = `drawio-review`; `drawio-diagram-waves` = `drawio-waves` | one skill each                   |
| `session-cost-audit` step 2 and `its-a-chore-…` step 2 both measure `.claude` bytes per robot and capability                 | one line in `debt-reduce`, cited |
| "`git status --short` first, skip a peer-dirty file" in six bodies                                                           | once, in `catzc-core`            |
| "`Format-Code -Path <touched>` then `Test-Plans`" in four bodies                                                             | once, in `plan-shape`            |
| "Report as report-fixed says" in every body                                                                                  | once, the drone's last step      |

## Mapping: every robot to its skill and drone

| Robot today                            | Skill after         | Runs on        |
| -------------------------------------- | ------------------- | -------------- |
| `catzc-drone`                          | `catzc-module`      | `drone-sonnet` |
| `gate-runner`                          | `catzc-gate`        | `drone-haiku`  |
| `link-fixer`                           | `md-links`          | `drone-haiku`  |
| `glossary-keeper`                      | `glossary-keep`     | `drone-haiku`  |
| `edit-diagram-yml`                     | `drawio-edit`       | `drone-haiku`  |
| `doc-pattern-scout`                    | `listen-tiers`      | `drone-haiku`  |
| `fact-checker`                         | `fact-check`        | `drone-haiku`  |
| `session-cost-audit`                   | `cost-audit`        | `drone-haiku`  |
| `drs-reviewer`                         | `drs-review`        | `drone-sonnet` |
| `build-inspiration-module`             | `inspiration-build` | `drone-sonnet` |
| `devbox-vscode-diagnostics`            | `devbox-diagnose`   | `drone-sonnet` |
| `test-optimization`                    | `test-speed`        | `drone-sonnet` |
| `plan-clear`                           | `plan-clear`        | `drone-sonnet` |
| `plan-intake`                          | `plan-intake`       | `drone-sonnet` |
| `its-a-chore-but-i-will-do-better`     | `debt-reduce`       | `drone-sonnet` |
| `2020-hindsight`                       | `hindsight-log`     | `drone-opus`   |
| `implementation-orchestrator`          | `orchestrate`       | user skill     |
| `listen-very-carefully-to-doc-changes` | `listen`            | user skill     |
| `diagram-review`                       | `diagram-review`    | user skill     |
| `plan-decide`                          | `plan-decide`       | user skill     |
| `drawio-diagram-waves`                 | `drawio-waves`      | user skill     |
| `print-artifacts`                      | `artifact-print`    | user skill     |

Kit skills kept as they are, loaded by a job skill's steps: `drawio-declaration`, `drawio-look`, `drawio-renderer`, `drs-cite`,
`plan-value`, `listen-notes`, `listen-insight`, `catzc-verify`. Net: 22 robots and 28 capabilities become 4 robots and 26 skills.

## Open steps

1. [ ] Parked with the drone-files step behind task-user-runs-and-commits item 25 (the four CLAUDE.md bullets); the drafts of both steps are
       in `out/catzc-5c-drones/`, landed in one pass, and the three old skills are deleted when step 5 removes the last robot that preloads
       them. `catzc-core` from `catzc-run`, `git-readonly` and `report-fixed`, with the peer-dirty line and one line that a new agent type
       appears only in a session started after its file lands, so a new job skill is tried through a stand-in drone at once (decided by
       catzc-5c from the harness fact, 2026-10-26); the three files deleted. Check: `Test-AgentDefinitions`.
2. [ ] The four drone files and their `agents.yml` entries (`model_reason` on sonnet, opus and fable). Check: `Test-AgentDefinitions`.
3. [ ] One job skill per row of the mapping, one file at a time: the robot's body folded into its skill, the duplicate lines dropped, the
       robot file and its `agents.yml` entry deleted, the `capabilities.yml` entry updated. The `plan-decide` skill gains one merged line:
       the open-question search matches all three shapes in one grep (`## Open questions`, `[ ] Open question`,
       `Proposed ... Answer: yes or no`), and every option's description carries its why and its outcome in the tree (the user, 2026-10-25).
       Check: `Test-AgentDefinitions` after each.
4. [ ] `pwsh/Catzc.Tooling.Claude/types/ClaudeDroneConfig.cs` and its config: the default agent `catzc-drone` is removed;
       `Start-ClaudeDrone` takes a required skill and resolves the drone from its `model_floor`, its tests with it. Check: `Invoke-TestFile`
       on `ClaudeDroneConfig.Tests.ps1` and `Start-ClaudeDrone.Tests.ps1`.
5. [ ] `.claude/CLAUDE.md` Sub-agents section: four bullets and one line saying jobs are the skills in `capabilities.yml`; this replaces
       plan-claude-diet step 1, which is deleted in the same edit. The user's file. Check: `Test-AgentDefinitions`.
6. [ ] Grep the tree for every old robot name (plans, prompts, docs, hooks, tests) and re-point each, one file at a time. Check: no match
       outside `git log`.
