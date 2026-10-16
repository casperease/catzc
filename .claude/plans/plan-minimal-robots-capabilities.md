---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  parent: plan-minimal-robots
  targets: [.claude/skills, automation/Catzc.Base.Docs/configs/capabilities.yml]
---

# Minimal-Robots catalogue: the capabilities

A capability is `.claude/skills/<name>/SKILL.md`: at most 10 lines outside the catzc head, mostly fixed front matter, one model floor,
loaded only through a robot's `skills:` list. Two proposed by the user, eight recommended; the set may grow to 50 but never below the orphan
rule (every capability is loaded by at least one robot). Names are `<domain>.<job>` (program Q4).

## Fixed front matter (the whole set, in this order; the catzc head follows)

```yaml
name: <domain>.<job>
description: <one line: what it does, which robot it serves, the input it must be given>
user-invocable: false
allowed-tools: <comma list>
paths: <optional globs that pin auto-activation>
metadata: { catzc: { model_floor: haiku | sonnet | opus, needs: [<tool>, ...] } }
```

The body is the remaining lines: numbered steps, each one action. `model_floor` is the lowest model that performs the steps reliably; the
gate holds every loading robot at or above it (program rule 2).

## Proposed capability 1: drawio.renderer

Given a repository address of a `.drawio.png`, new or existing, runs the cats transformation and tells what the raster hides.

```markdown
---
name: drawio.renderer
description: Re-render the model embedded in a given .drawio.png to out/ and list raster-versus-model differences; for drawio-png.
user-invocable: false
allowed-tools: Bash, Read
metadata: { catzc: { model_floor: haiku, needs: [uv, pillow] } }
---

1. Read the given PNG with the Read tool and note the cells, labels and colours the raster shows.
2. Background Bash: `timeout 60 uv run --with pillow python .claude/drawio/drawio_png.py <in> out/drawio/<name>.drawio.png`.
3. Read the out/ PNG; list each difference (missing, extra, mislabelled, mis-coloured cell); end with the out/ path as a link.
```

That is 10 lines outside the catzc head: 7 of front matter, 3 of body. The Pillow renderer is the kit's own; the draw.io CLI cannot
rasterise in the agent's Bash context (memory, drawio-diagrams-and-cli), so `needs` names uv and pillow, not drawio. Floor haiku: step 1 is
vision, which haiku has; step 3 is a diff of two lists. Registry: `supported_by: [ADR-DSGN-VISUAL#4]`, `checks: [Test-CheckedInBinaries]`.

## Proposed capability 2: plan.shape (built 2026-10-16)

`.claude/skills/plan.shape/SKILL.md`: the plan rules for the plan-clear robot (head keys `status`, `value`, `reviewed`, `targets`; stable
names; verdicts keep, trim, re-point, delete, intake; one verdict acted on at a time; never delete a plan with an open step). Floor
sonnet, needs none, paths `.claude/plans/**`. Registry entry waits for `capabilities.yml` and its config type (program Phase 1).

## Recommended capabilities (eight)

| Name           | Serves                                                        | Floor | needs | Steps in three lines                                                                                                                                                                     |
| -------------- | ------------------------------------------------------------- | ----- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| catzc.run      | every robot that runs a catzc command                         | haiku | pwsh  | foreground Bash at most 3 s; a catzc command goes to the background as `timeout <s> pwsh -NoProfile -File out/<script>.ps1`; exit 124 is reported as the safeguard, never retried larger |
| catzc.gate     | gate-runner, catzc-worker, glossary-keeper, test-optimization | haiku | pwsh  | run `Invoke-TestFile` or the named gate on one file; read the output; report pass or the failing lines verbatim; never claim a pass unseen                                               |
| catzc.filehead | catzc-worker, build-inspiration-module                        | haiku | pwsh  | a new or moved file gets its head from `Format-FileMeta`, never by hand; never `Format-Code` on a YAML head; check `git status` shows the move                                           |
| adr.cite       | adr-reviewer, catzc-worker                                    | haiku | none  | read `docs/adr/index.md` first; read in full only the ADRs that govern the touched files; cite as `ADR-X#n`, never sweep the corpus or `research/`                                       |
| report.fixed   | every robot                                                   | haiku | none  | end with: files touched (path per line), checks run with their result, asks for shared-file entries, what was left undone and why                                                        |
| git.readonly   | adr-reviewer, session-cost-audit, plan-clear                  | haiku | git   | `git status`, `log`, `diff`, `blame` only; no add, commit, checkout, reset, stash; a dirty file of another session is reported, not edited                                               |
| md.links       | link-fixer, plan-clear                                        | haiku | pwsh  | run `Test-Links` on the one file; re-point a relative target from the file's own folder; re-run; one file per step, never a sweep                                                        |
| drawio.look    | drawio-png, write-drawio-files, drawio-diagram-waves          | haiku | none  | read the PNG with the Read tool; name every cell, label, edge and colour seen; say which dark tokens (`.claude/drawio/STYLE.md`) a colour fails                                          |

Two more that Phase 3 of the program plan will need, listed so the names are reserved: `drawio.model-edit` (the chunk recipe from
write-drawio-files: decode the `mxfile` tEXt chunk, edit `value=` labels, re-encode, assert the round-trip; floor haiku; needs uv, pillow)
and `drawio.waves` (the scout, rank, make protocol of drawio-diagram-waves; floor sonnet; serves the lead only). `artifact.publish` (the
print-artifacts page recipe, floor haiku, needs the Artifact tool) and `test.speed` (the test-optimization diagnosis checklist, floor
sonnet) are reserved the same way. With the two proposed that is 14 names, inside the 5 to 50 range.

## Built 2026-10-16: the three plan capabilities of the planner robots

| Name        | Serves                   | Floor  | needs | Steps in three lines                                                                                                                                       |
| ----------- | ------------------------ | ------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| plan.intake | plan-intake              | sonnet | none  | every pasted item lands in one plan (done with reason, open as a checked step, question left open); a done claim is read in the tree first; prompts verbatim as files; in-use files one line at most |
| plan.decide | plan-decide              | sonnet | none  | one questionnaire item per open question, never renumbered; four per ask, recommendation first; a decisions row with Outcome; the user decides, the fold is per plan |
| plan.value  | plan-intake, plan-decide | sonnet | none  | value is what lands, in one sentence, never job size; needed docs and tests listed by name; the rank lives in the index and the head's value key, never in a file name |

Floor sonnet for all three: each step is a judgement about where an item belongs or what it is worth. With these the catalogue holds 17
names. Registry entries wait for capabilities.yml like plan.shape; `supported_by` for all three: ADR-PRIN-NOWASTE#1, plus the
ADR-REPO-PLANS rule once it exists.

## Registry entries (capabilities.yml, one per name)

Each entry: `name`, `supported_by` (rule citations; `catzc.run` cites ADR-AUTO-FAILFAST#7, `adr.cite` cites ADR-REPO-LINK#5, `git.readonly`
cites the CLAUDE.md git rule's ADR once one exists, else ADR-PROC-BUILTIN#3, `report.fixed` cites ADR-REPO-AGENTS#4, `md.links` cites
ADR-REPO-LINK#1, the drawio ones cite ADR-DSGN-VISUAL#4) and `checks` (`[]` for the read-only ones). The floor is not in the registry
(program rule 4).

## Open questions

- Q1 Floors: every recommended capability sits at haiku except the two reserved sonnet ones. Confirm, or raise `adr.cite` to sonnet, which
  would push catzc-worker to sonnet by the floor rule (it is proposed there anyway).
- Q2 `report.fixed` is loaded by every robot. Alternative: fold its three lines into rule 7 of the program plan and the robot body.
  Recommendation: keep it a capability so the report shape is written once.
- Q3 `paths:` on the drawio capabilities (`docs/.assets/**/*.drawio.png`, `out/drawio/**`) to stop the main session auto-loading them.
  Recommendation: set it on every capability whose job is about a file family; leave it off `report.fixed` and `catzc.run`.

## Done, and why

Nothing yet.
