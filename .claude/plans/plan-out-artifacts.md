---
plan:
  status: blocked
  value: medium
  reviewed: 2026-10-16
  blocked_on: four decisions in the draft
  targets: [automation/Catzc.Base.Writers/configs/output-formats.yml, automation/Catzc.Base.Reports, docs/adr/repository/dedicated-output-directory.md]
---

# Configurable output artifacts with sensible defaults

out/ holds registered gate runs beside unregistered caches, views, 144 session scripts, logs and 27 backups. The draft proposes six
areas with defaults and a prune.

## Why its value is medium

The root is the contract and it is noisy. Low risk, clear win, but no other plan waits on it. The plans plan moves the plans out,
which shrinks this one.

## Harvest of out/ after the plan absorption (measured 2026-10-16, names only, bodies not read)

Plan data left out/ on 2026-10-16; what remains is session tooling and output. Counted at the top level: 272 .ps1 scripts, 35 .log,
27 .txt, 27 .bak (cc-int-*.bak of the internal .psm1 files and condense-comments-sa-*.bak of the analyzer modules), 2 .py, 5 .csv, .json
or .sh, plus 45 run folders (test-* gates, cache, diagrams, template, verdicts, spike, glossary-check, to-scratch-*).

Referenced by a plan or prompt in .claude/plans, so kept until that plan is done:

- Link cleanup: adr-link-ledger.csv, build-adr-link-ledger.ps1, prepass-adr-link-ledger.ps1, refresh-ledger.ps1, apply-verdicts.ps1,
  analysis-adr-link-ledger.txt, verdicts/, measure-text-in-source.ps1; source-text-ledger.csv is named but does not exist yet (Phase 2 builds it).
- Unboxing: bench-unboxing.ps1, bench-unboxing.cs, bench-unboxing.log, boxing-bench.ps1, run-unboxing-tests.ps1.
- Bounded enumeration: bench-folder-walk.ps1. Layers and generators: run-generator-tests.ps1, regen-generators.ps1, run-gates.ps1,
  run-meta-tests.ps1. Assert-BashTimeout.cs is named by a plan as out/ but lives under .claude/hooks; not an out/ file.

Unreferenced by any plan: everything else, by prefix family: run-* (about 90), probe-* 12, fix-* 12, verify-meta-* 7, to-* 7, step1-7,
check-* 7, migrate-* 5, meta-selector-* 5, gates-* 5, boxing-stages* 4, adrhead-* 4, debug-* 4, yamlcheck* 3, bodysha-* 3 and singles.
Not yet sorted into one-off probe (delete), rerunnable check (keep in out/ and name it in its plan), or reusable tool (becomes a module
function with tests). That sorting needs each script's body read; it is the next step of this plan, on the user's go.

## Open steps (harvest)

- [ ] Sort the unreferenced scripts by reading each body: probe, rerunnable, or tool (check: a table in this file with one verdict each).
- [ ] Delete the probes and the 27 .bak files on the user's yes (check: the counts above shrink; nothing a plan names is gone).
- [ ] Each tool verdict becomes an open step in the plan that owns the behaviour, never a copy in two places.

## Needed docs

- ADR-REPO-OUTDIR amendments: the areas, session placement, what prunes and when.
- output-formats.yml registers cache, views, session scripts and logs.

## Needed tests

- Clear-Output and the prune honour the area defaults; a registered run area keeps its N newest.
- Log rotation of time-safeguard.log, if chosen, keeps one older file.

## Open steps

- [ ] Decide: areas and numbers; out/sessions or out/scratch; rotate or never prune the safeguard log; prune on import or on call.
- [ ] Register the unregistered areas (check: Test-Links on output-formats.yml; its config tests).
- [ ] Implement the prune (check: its Pester file).

## Refs

- the full draft is carried below (formerly out/plan-out-artifacts.md; decisions at its end)
- docs/references/out.md

## Carried: out/plan-out-artifacts.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: configurable output artifacts with sensible defaults

2026-10-15. Status: **basis for review**. It is derived from what `out/` holds today. Nothing is built yet.

## What `out/` holds today (measured 2026-10-15)

| Area                         | Today                                                                         | Registered in `output-formats.yml` |
| ---------------------------- | ----------------------------------------------------------------------------- | ---------------------------------- |
| `test-<subject>/<stamp>/`    | 27 gate folders. `test-file` 199 stamps, `test-comments` 175, `test-links` 98, `test-spelling` 91, `test-file-meta` 59, `test-formatting` 46, `test-automation` 19 stamps / 79 MB | yes: reports, pointers, run files |
| `diagrams/`                  | 1 review PDF, 91 MB                                                           | yes: drawio, minimaps, review PDF  |
| `automation/built`, `packages` | none at the moment                                                          | yes: bundle, package               |
| `cache/`                     | 6 files, 2.3 MB (the analyzer result cache, `ADR-AUTO-CACHE`)                 | **no**                             |
| `test-comments`-style views  | the comment view (`comments.yml` `view:`)                                     | **no**                             |
| top-level session scripts    | 144 `.ps1` (`run-*`, `verify-*`, `to-*`, `measure-*`, `check-*`…)            | **no**                             |
| top-level session logs, dumps | 16 `.log`, 17 `.txt`, 2 `.csv`, 1 `.json` (`to-fc*.log`, `tracked-files.txt`…) | **no**                             |
| top-level backups            | 27 `.bak` (`condense-comments*.bak` 20, `cc-int*.bak` 7)                      | **no**                             |
| plans and handoffs           | 18 `.md` (`plan-*.md`, `handoff-*.md`)                                        | **no** (CLAUDE.md places them)     |
| hook log                     | `time-safeguard.log`, appended by the Bash time-safeguard hook                 | **no**                             |
| one-off folders              | `spike/` (14), `to-scratch-{discovery,expedition,foundation}/`, empty `template/`, `test-isolation/` | **no**  |

Two problems follow from this. Stamped run folders grow without bound, because no format says how many runs to keep. And about 230
session files sit at the top of `out/`, against `ADR-REPO-OUTDIR#2`: no format names them, so nothing can place, check or prune them.

## The basis: one registry, every artifact a format, defaults declared once

`output-formats.yml` stays the one registry. Every artifact `out/` holds becomes a format, and each format gains **placement** and
**retention**, with defaults declared once on the config type (`ADR-AUTO-DEFAULT#6`, `ADR-PRIN-CONFIG`). A format states only what
differs from the defaults.

### New keys on a format

| Key          | Meaning                                                                    | Default (declared once on the type)                       |
| ------------ | -------------------------------------------------------------------------- | --------------------------------------------------------- |
| `area`       | the class of output, which picks the rest of the defaults                  | required: `run`, `build`, `cache`, `review`, `session`, `log` |
| `keep`       | how many to keep: the newest N stamps or files of the pattern, or `all`     | by area (below)                                           |
| `max_age`    | the oldest file kept, such as `7d`; `none` never ages out                   | by area (below)                                           |
| `in_pipeline` | whether retention applies in a pipeline staging directory                  | `false`: a pipeline run is one fresh staging directory    |

### Defaults per area

| Area      | Holds                                                     | `keep` | `max_age` | Why                                                                |
| --------- | --------------------------------------------------------- | ------ | --------- | ------------------------------------------------------------------ |
| `run`     | `test-<subject>/<stamp>/` and `latest.txt`                | 10     | none      | A person reads the latest run and compares a few; 199 stamps help no one. `latest.txt` must name a kept stamp. |
| `build`   | `automation/built/<bundle>`, `automation/packages`        | 1      | none      | A build is regenerated from source (`ADR-REPO-OUTDIR#9`); only the newest is installed. |
| `cache`   | `cache/`                                                  | all    | none      | A cache entry is keyed by its inputs, and its own rules invalidate it (`ADR-AUTO-CACHE`). Age is not staleness. |
| `review`  | `diagrams/`, review PDFs and pages for the user           | all    | none      | Only the user retires a review artifact.                          |
| `session` | an agent session's scripts, dumps, backups, plans, handoffs | all  | 7d        | Work products of one session; plans and handoffs outlive it by days, not weeks. |
| `log`     | `time-safeguard.log` and other appended logs              | 1      | none      | One file per log, rotated by size (see open item 3).               |

### Placement: `session` artifacts get a folder

`ADR-REPO-OUTDIR#2` asks recurring output to live in a subdirectory. Session output gets one:

- `out/sessions/<session>/`, where `<session>` is the Claude session name (`catzc-b8`). It holds the session's scripts, logs, dumps and
  `.bak` files. Two sessions never overwrite each other's `run-batch.ps1`.
- Plans and handoffs stay at `out/plan-*.md` and `out/handoff-*.md`, because `.claude/CLAUDE.md` names that place and the user reviews
  them there. They are registered as `session` formats with their own pattern, so retention covers them.

### Sketch of the registry entries this adds

```yaml
formats:
  test-report:
    area: run                    # keep 10 newest stamps, from the area default
    patterns: ["test-*/{stamp}/*.md"]
    ...
  analyzer-cache:
    area: cache
    patterns: ["cache/**"]
    producer: Get-ScriptAnalyzerDiagnostics (the result cache)
  session-work:
    area: session
    patterns: ["sessions/*/**"]
    producer: an agent session (scripts, logs, dumps, backups)
  plan:
    area: session
    patterns: ["plan-*.md", "handoff-*.md"]
    max_age: 30d                 # a plan outlives its session; overrides the 7d default
  time-safeguard-log:
    area: log
    patterns: ["time-safeguard.log"]
    producer: the Assert-BashTimeout hook
```

### One command, one check

Today only the config types read the registry (`OutputFormat`, `OutputFormatsConfig` in `Catzc.Base.Reports`). No command uses it
yet, so both of these are new:

- **`Clear-Output`** applies retention: per format, it removes the stamps and files the defaults and overrides do not keep. It has
  `-DryRun` (`ADR-AUTO-DRYRUN`), and with `-All` it is `ADR-REPO-OUTDIR#7`'s clean-all.
- **`Test-OutputFormats`** reports any file under `out/` that no format's pattern covers, and any file a format's validator rejects. So
  the 230 loose files become findings, and a new producer cannot drop files without registering them.
- The importer tail may run `Clear-Output` for the `run` area only. It is cheap, and it keeps `test-file/` from growing to 199 stamps.

## Migration from today's `out/`

1. Register the missing formats. Every file under `out/` is then covered, which the gate proves.
2. Move today's top-level session files into `out/sessions/<session>/`. The `run-*`/`to-*` scripts belong to sessions that ended, so
   they go under `out/sessions/unattributed/` with the 7-day default.
3. The first `Clear-Output -DryRun` reports what the `run` default prunes: about 190 stamps of `test-file`, 165 of `test-comments`,
   88 of `test-links`, 81 of `test-spelling`, 49 of `test-file-meta`, 36 of `test-formatting`, and 9 of `test-automation`.

## Decisions for the user

1. **Areas and defaults:** accept the six areas and the table, or change a number (for example, keep 20 runs).
2. **Session placement:** `out/sessions/<session>/` (recommended), or a flat `out/scratch/` with no session name.
3. **Log rotation:** rotate `time-safeguard.log` by size (for example 1 MB, keeping one older file), or never prune it, because it is
   evidence for tuning `timeouts.yml`.
4. **Automatic pruning:** the importer tail prunes the `run` area on every import, or pruning runs only when a person calls
   `Clear-Output`.
