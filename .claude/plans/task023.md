---
task:
  id: "023"
  status: open
  plans: [plan-assets-beside-articles, plan-assets-gallery-pdf]
  value: medium
  blocked_on: D07 for step 5; the rest can start now
  targets:
    [
      .claude/drawio/gallery_pdf.py,
      .claude/drawio/STYLE.md,
      .claude/skills/drawio-waves/SKILL.md,
      automation/Catzc.Base.Languages,
      docs/.assets/explanation,
    ]
---

# task023: assets beside articles, the leftovers, and the gallery PDF

The move landed on 2026-10-17: 147 explanation slides and 11 reference diagrams sit beside their articles, the PNGs and minimaps under each
tree's own `.assets`. What is left is the kit's `--assets` mode, one failing carrier test, the empty old folder, and the gallery plan's three
steps. Verified 2026-10-17: `docs/.assets/explanation` holds one gitignored PDF and `chain/` with one gitignored PDF; STYLE.md line 44 of the
drawio-waves skill lists `gallery_pdf.py` without naming `--assets`.

## Steps

1. `.claude/drawio/gallery_pdf.py` `--assets`: the companion of `<stem>.drawio.png` under `docs/<tree>/.assets/...` is
   `docs/<tree>/<domain>/<stem>.drawio.md` beside its article (the sidecar carrier `docs/explanation/*/{stem}.drawio.md` in file-carriers.yml
   is the one lookup; read it, do not re-spell it); if the lookup is not worth teaching, delete the mode and its STYLE.md lines (D07 then
   falls away). Check: a run on `docs/explanation/.assets` with `--no-text` ends ok and, with text, includes the descriptions; or the mode is
   gone from the script and STYLE.md.
2. `FileCarrierResolver` shipped-registry test: it fails on its test-file exclusion line because the shipped powershell carrier lists no
   `tests` exclude. Read the head rules for test files (ADR-REPO-CODEMETA, the carrier config); fix the test if test files carry heads, or the
   carrier if they do not. Check: that test file passes.
3. Remove `docs/.assets/explanation` (both PDFs are gitignored output; move them to `out/diagrams/` if wanted). Check: the folder is gone;
   `git status` shows no tracked deletion.
4. `.claude/skills/drawio-waves/SKILL.md` line 44: the gallery mention names `--assets` (or says the mode is gone, per step 1). Check: the line
   says it; Test-AgentDefinitions clean (the capability roof of 10 lines holds).
5. D07 `--parts <n>`: if yes, a flag that writes parts under 30 MiB each, run once to prove it; if no, one line in the plan. Check: recorded or
   built.
6. A fixture run (two PNGs, one companion) if the kit gains a test home; otherwise the step is recorded as waiting on a test home. Check:
   page count 3, or the line.
7. Tick every step in both plans; both are deleted in T036 with one line each in value-of-plan.md. Check: grep `- [ ]` in both counts zero.

## Report

As report-fixed.
