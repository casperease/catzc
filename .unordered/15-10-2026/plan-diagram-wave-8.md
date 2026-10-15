# Plan: diagram wave 8 — the 13 diagrams without explanation slides

Written 2026-10-15. Waves 1–4 drew 31 single diagrams; 18 of them became the five-lens slide sets that are now the 88 articles in
`docs/explanation/`. 13 never got slides or articles: the 12 of wave 4 and `repository` of wave 2. This wave gives each of them its lens
slides, articles and asset descriptions, in the dark theme (STYLE.md as of today, shadows included), and lands them in `docs/`.

User decisions (2026-10-15): the 13 without slides; go now with the current minimap tooling (the big render pass later refreshes every
minimap and recolours the 88 older slides).

## The 13 sources

| #   | Source (`out/diagrams/`)                            | Main ADR            | Domain folder                                                                                                                                                                             |
| --- | --------------------------------------------------- | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `wave-4/automation/agent-bash-call-verdict`         | ADR-AUTO-FAILFAST   | automation                                                                                                                                                                                |
| 2   | `wave-4/automation/path-two-forms`                  | ADR-AUTO-PATH       | automation                                                                                                                                                                                |
| 3   | `wave-4/automation/time-safeguard-limit-resolution` | ADR-AUTO-FAILFAST   | automation                                                                                                                                                                                |
| 4   | `wave-4/azure/config-coordinate-to-resource-group`  | ADR-AZ-DATAMOD      | azure                                                                                                                                                                                     |
| 5   | `wave-4/azure/deploy-target-from-session`           | ADR-AZ-DATAMOD      | azure                                                                                                                                                                                     |
| 6   | `wave-4/config/config-value-addressing`             | ADR-CONF-ADDRESSING | configuration                                                                                                                                                                             |
| 7   | `wave-4/config/root-config-materialisation`         | ADR-REPO-ROOTCFG    | repository (new)                                                                                                                                                                          |
| 8   | `wave-4/design/aspect-catch-all-per-track`          | ADR-DSGN-ASPECT     | design                                                                                                                                                                                    |
| 9   | `wave-4/flow/one-detection-seam`                    | ADR-FLOW-CD         | flow                                                                                                                                                                                      |
| 10  | `wave-4/globs/change-range-fail-open`               | ADR-FLOW-CD         | flow                                                                                                                                                                                      |
| 11  | `wave-4/globs/compose-to-native-trigger`            | ADR-FLOW-CD         | flow                                                                                                                                                                                      |
| 12  | `wave-4/modules/variant-primitives`                 | ADR-REPO-VARIANT    | repository (new)                                                                                                                                                                          |
| 13  | `wave-2/scopes/repository`                          | (no ADR drawn)      | excluded: no ADR defines scopes or named roots (checked `docs/adr/index.md` and `terminology.yml` 2026-10-15); an explanation article must support an ADR, so this one waits for the user |

The main ADR is the code the source draws most; the maker confirms it from the source's verify file and the ADR index, and may add the other
codes the source cites to the Supports cell.

## Phases

| Phase | Who                   | Owns                                                                                                                                                                                                                                                                                                                                                                         | Done when                                         |
| ----- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| P0    | lead                  | this plan; `out/diagrams/wave-8/_maker_brief.md`, `_build_slide.sh`, `_check_docs.ps1`; `docs/explanation/repository/index.md` skeleton                                                                                                                                                                                                                                      | the makers can launch                             |
| P1    | 12 makers, one launch | per diagram: up to five lens XMLs in `out/diagrams/wave-8/<area>/`, previews, verify files, articles, asset descriptions, preview PNG copies in `docs/.assets/explanation/`, per-file checks                                                                                                                                                                                 | each maker reports clean checks                   |
| P2    | lead                  | the slide list `out/diagrams/wave-8/slides.json`; highlights.ps1 → render.py (`--target docs/.assets/explanation`, `--facts`) → join.py (final PNGs with minimaps); the generated Sidebar sections pasted one file at a time; the domain indexes, `docs/explanation/index.md`, `docs/index.md`, `terminology.yml` words; `_lint_spell_globs.ps1`; `repository` (#13) decided | all checks pass; a per-diagram report to the user |
| P3    | lead, after asking    | the gallery                                                                                                                                                                                                                                                                                                                                                                  | the user has the link                             |

## Rules carried over

- Per-file checks only; the user runs the full suite and commits. One file at a time; no scripted sweeps across files.
- Render nothing beyond the slides and minimaps this wave needs; the gallery waits for the user's go.
- Never overwrite a `docs/.assets` file another wave or the user owns; a `.$<name>.drawio.png.bkp` sibling means it is open in draw.io.
- Present tense, plain English, "cats" in prose, "domain rules" / "ADR rules".
