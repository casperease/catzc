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

## Proposed capability 1: drawio.renderer (built 2026-10-16)

Given a repository address of a `.drawio.png`, new or existing, runs the cats transformation and tells what the raster hides. Built as
`.claude/skills/drawio.renderer/SKILL.md` (10 lines, floor haiku, needs uv and pillow) and proven on
`docs/.assets/commits-quality/commit-lifecycle-states.drawio.png`. Contract settled 2026-10-16 with the user: **fail-forward**. The
deterministic kit script `.claude/drawio/drawio_forward.py` always delivers a byte copy of the source PNG and a result PNG (the re-render,
or the source again when no model reads), plus the decoded model and a `render.md` report; `--xml` asserts a given model matches the
embedded one 100 percent after canonicalisation; `--assert` checks a page (66 lines) of text, line by line, against the cell labels. Exit 0
clean, 2 warnings with every artifact delivered, 3 no source. Proven on four runs (clean, planted missing phrase, mismatching XML, missing
source) with the expected exit each time. AI-bound remainder: none by default; a look at the two PNGs or a parameter ("change this colour")
only on the user's ask. Findings on the real diagram: `out/drawio/commit-lifecycle-states.compare.md`. The file as built:

```markdown
---
name: drawio.renderer
description:
  Fail-forward render of a given .drawio.png, always a source copy and a result PNG in out/drawio, model XML and a page of asserted text
  checked when given; for drawio-png; input is the PNG's repository path, optional model XML path, optional asserted-text path.
user-invocable: false
allowed-tools: Bash, Read
paths: docs/.assets/**/*.drawio.png, out/drawio/**
metadata: { catzc: { model_floor: haiku, needs: [uv, pillow] } }
---

1. Deterministic, background Bash, absolute paths:
   `timeout 60 uv run --with pillow python <repo>/.claude/drawio/drawio_forward.py <src> <repo>/out/drawio [--xml <model>] [--assert <text.md>]`;
   exit 0 clean, 2 warnings with every artifact still delivered, 3 no source, 124 the safeguard.
2. Forward the `src`, `result`, `model`, `report` paths and every `warn` line verbatim; never retry, never edit the source, never judge a
   warning away.
3. AI-bound remainder: none by default; only when the user asks for a look, Read the source copy and the result PNG and list what differs,
   or execute the parameter the user gave ("change this colour") through write-drawio-files.
```

That is 10 lines outside the catzc head: 8 of front matter, 3 of body. The Pillow renderer is the kit's own; the draw.io CLI cannot
rasterise in the agent's Bash context (memory, drawio-diagrams-and-cli), so `needs` names uv and pillow, not drawio. Floor haiku: steps 1
and 2 are parameter execution and verbatim forwarding. Registry: `supported_by: [ADR-DSGN-VISUAL#4]`, `checks: [Test-CheckedInBinaries]`.

## Proposed capability 2: plan.shape (built 2026-10-16)

`.claude/skills/plan.shape/SKILL.md`: the plan rules for the plan-clear robot (head keys `status`, `value`, `reviewed`, `targets`; stable
names; verdicts keep, trim, re-point, delete, intake; one verdict acted on at a time; never delete a plan with an open step). Floor sonnet,
needs none, paths `.claude/plans/**`. Registry entry waits for `capabilities.yml` and its config type (program Phase 1).

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

| Name        | Serves                   | Floor  | needs | Steps in three lines                                                                                                                                                                                 |
| ----------- | ------------------------ | ------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| plan.intake | plan-intake              | sonnet | none  | every pasted item lands in one plan (done with reason, open as a checked step, question left open); a done claim is read in the tree first; prompts verbatim as files; in-use files one line at most |
| plan.decide | plan-decide              | sonnet | none  | one questionnaire item per open question, never renumbered; four per ask, recommendation first; a decisions row with Outcome; the user decides, the fold is per plan                                 |
| plan.value  | plan-intake, plan-decide | sonnet | none  | value is what lands, in one sentence, never job size; needed docs and tests listed by name; the rank lives in the index and the head's value key, never in a file name                               |

Floor sonnet for all three: each step is a judgement about where an item belongs or what it is worth. With these the catalogue holds 17
names. Registry entries wait for capabilities.yml like plan.shape; `supported_by` for all three: ADR-PRIN-NOWASTE#1, plus the ADR-REPO-PLANS
rule once it exists.

## Registry entries (capabilities.yml, one per name)

Each entry: `name`, `supported_by` (rule citations; `catzc.run` cites ADR-AUTO-FAILFAST#7, `adr.cite` cites ADR-REPO-LINK#5, `git.readonly`
cites the CLAUDE.md git rule's ADR once one exists, else ADR-PROC-BUILTIN#3, `report.fixed` cites ADR-REPO-AGENTS#4, `md.links` cites
ADR-REPO-LINK#1, the drawio ones cite ADR-DSGN-VISUAL#4) and `checks` (`[]` for the read-only ones). The floor is not in the registry
(program rule 4).

## Decided (2026-10-16, questionnaire items Q136 to Q138)

- Q136 Floors: kept as catalogued; adr.cite stays haiku; catzc-worker's sonnet is a Phase 3 hypothesis, not a floor consequence.
- Q137 report.fixed stays a capability every robot loads, so the report shape is written once.
- Q138 `paths:` is set on every capability about a file family (drawio._, plan._, md.links) and left off report.fixed and catzc.run.
- Program Q128: the capability roof is 10 lines outside the catzc head; drawio.renderer as built is 11 and loses one line in Phase 1.
- Program Q130: dotted names confirmed.

## Done, and why

- 2026-10-16: drawio.renderer gained `--page dark|model`, an optional `<out_dir>`, both defaulting from `.claude/drawio/drawio.yml`, and
  `--minimaps`, which derives the one-slide list from the file name and the sister `.drawio.md` and runs highlights.ps1, render.py and
  join.py into `<out_dir>/<name>/`. Proven on three explanation slides, exit 0 each, 9 to 10 s each; count in `out/drawio/token-count.md`.
- 2026-10-16: all 148 explanation slides migrated to the dark tokens in place (migrate_dark.py, no light token left) and rebuilt with fresh
  minimaps from the current maps; 60 slides got minimaps and sister files for the first time. The slide's ADR codes come from its own labels
  and file name, checked against the ADR index (`slide_adrs` in drawio_forward.py), never from the sister .md's citations. join.py now turns
  a template placeholder into an image cell and drops its label. Driver scripts: `out/drawio/regen-explanation.py`,
  `out/drawio/relabel-subset.py`.
- 2026-10-16, rule from the user: a slide's `<stem>.drawio.md` is the **instruction file** for the robot that rebuilds the slide, not a
  record of its data. Its Sidebar names the ADR codes, the generators whose output the minimaps are (`Get-WorldMapHighlight`,
  `Get-ValueChainHighlight`, `Get-WorldMap`, `Get-AdrCitationMap`, linked to their reference pages) and the rebuild step
  (`drawio_forward.py <slide> --minimaps`); it never carries lit-cell counts, file names or reasons, which live in the generated sister
  `.grid.md`, `.tree.md`, `.chain.md` as of each build. All 148 descriptions rewritten so (`out/drawio/regen-descriptions.py`); the
  at-a-glance line reads "three minimaps and the map key, generated from the current maps". The same rule goes to the `drawio.renderer`
  capability's robot (drawio-png step 2) and, when it is built, to `drawio.waves`: a maker writes the pointer form, never the data form.
- 2026-10-16: the capability set stands at 18 files under `.claude/skills/`, every one registered in `capabilities.yml` with its rules and
  checks and preloaded by at least one robot: catzc.run, catzc.gate, catzc.module, catzc.verify, report.fixed, git.readonly, md.links,
  drawio.renderer, drawio.model-edit, drawio.look, drawio.waves, artifact.publish, test.speed, plan.shape, plan.intake, plan.decide,
  plan.value (the last three by the planner session). Floors: sonnet for catzc.module, test.speed, drawio.waves and the plan.\* judging
  ones; haiku for the rest. Reserved and not built: adr.cite (its content went into catzc.module step 3). The gate's line count treats the
  two `---` delimiters and the catzc head as outside the roof (program Q2 as recommended).
