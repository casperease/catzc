---
task:
  id: "023"
  status: open
  plans: [plan-assets-gallery-pdf]
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
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task023.md"
    folder: plans
    name: task023
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task023: assets beside articles, the leftovers, and the gallery PDF

The move landed on 2026-10-17: 147 explanation slides and 11 reference diagrams sit beside their articles, the PNGs and minimaps under each
tree's own `.assets`. What is left is the kit's `--assets` mode, one failing carrier test, the empty old folder, and the gallery plan's
three steps. Verified 2026-10-17: `docs/.assets/explanation` holds one gitignored PDF and `chain/` with one gitignored PDF; STYLE.md line 44
of the drawio-waves skill lists `gallery_pdf.py` without naming `--assets`.

## Steps

1. [x] `.claude/drawio/gallery_pdf.py` `--assets`: the companion of `<stem>.drawio.png` under `docs/<tree>/.assets/...` is
   `docs/<tree>/<domain>/<stem>.drawio.md` beside its article (the sidecar carrier `docs/explanation/*/{stem}.drawio.md` in
   file-carriers.yml is the one lookup; read it, do not re-spell it); if the lookup is not worth teaching, delete the mode and its STYLE.md
   lines (D07 then falls away). Check: a run on `docs/explanation/.assets` with `--no-text` ends ok and, with text, includes the
   descriptions; or the mode is gone from the script and STYLE.md. Done 2026-10-17: the script reads the sidecar carriers of
   file-carriers.yml (globs and pattern) and finds a diagram's page through them, a minimap's page beside it; pages stream to the PDF one
   at a time and a long markdown file continues on the next page under the encoder's 65500 px roof; an empty folder is named instead of
   a traceback. `ok out\diagrams\assets-gallery.pdf pages=593` with `--no-text`, `pages=1059` with the descriptions (684 MiB, a D07 fact);
   `Format-Code` python unchanged, `No spelling issues found.` (`out/t023-gallery.sh`).
2. [x] `FileCarrierResolver` shipped-registry test: it fails on its test-file exclusion line because the shipped powershell carrier lists
   no `tests` exclude. Read the head rules for test files (ADR-REPO-CODEMETA, the carrier config); fix the test if test files carry heads,
   or the carrier if they do not. Check: that test file passes. Corrected 2026-10-17: the premise is gone, the file passes as it stands,
   `[Invoke-TestFile] Passed` (`out/test-file/20261017-195921-41fa57`); its shipped-registry line asserts that a test file carries a head,
   and the powershell carrier lists no exclude, so both agree. Nothing changed.
3. [x] Remove `docs/.assets/explanation` (both PDFs are gitignored output; move them to `out/diagrams/` if wanted). Check: the folder is
   gone; `git status` shows no tracked deletion. Done 2026-10-17: the two PDFs moved to `out/diagrams/`, the folder removed, `git status`
   shows nothing under `docs/.assets`.
4. [x] `.claude/skills/drawio-waves/SKILL.md` line 44: the gallery mention names `--assets` (or says the mode is gone, per step 1). Check:
   the line says it; Test-AgentDefinitions clean (the capability roof of 10 lines holds). Done 2026-10-17: the bundles line (43) names
   `--assets <tree>/.assets`; `AGENTS issues=0`, `SPELL issues=0` (`out/t023-gates.ps1`).
5. D07 `--parts <n>`: if yes, a flag that writes parts under 30 MiB each, run once to prove it; if no, one line in the plan. Check: recorded
   or built. Open: waits for D07.
6. [x] A fixture run (two PNGs, one companion) if the kit gains a test home; otherwise the step is recorded as waiting on a test home.
   Check: page count 3, or the line. Recorded 2026-10-17 in plan-assets-gallery-pdf: the kit (`.claude/drawio`) has no test home, so the
   fixture run waits for one.
7. [x] Tick every step in both plans; both are deleted in T036 with one line each in value-of-plan.md. Check: grep `- [ ]` in both counts
   zero. Done 2026-10-17 as far as D07 allows: plan-assets-beside-articles had no step left but its own deletion and is deleted, with its
   line in value-of-plan.md; plan-assets-gallery-pdf keeps the D07 step and the test-home step.

## Report

As report-fixed.
