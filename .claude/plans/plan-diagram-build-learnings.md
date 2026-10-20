---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: meta
  targets:
    [
      docs/references/pwsh/catzc-base-slides/Build-Diagrams.ps1.md,
      .claude/skills/catzc-run/SKILL.md,
      python/Catzc.Diagrams/drawio_forward.py,
      python/Catzc.Diagrams/configs/drawio.yml,
      pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1,
    ]
---

# Diagram build learnings: what a "hung" Build-Diagrams taught, folded back into docs, instructions and the renderer

A bare `Build-Diagrams` looked hung: it wrote the minimap data of all 171 diagram folders (1.5-2.5 s each), then rendered each (about 1 s),
for 5-8 minutes with no output. Per-folder progress lines fixed the silence (committed as a user step in task-user-runs-and-commits). This
plan folds the rest of what the session learned back into the repository: the help page that describes the run wrongly, the run skill that
lacks two patterns an agent tripped on, the warning a full run prints on every pass, the minimap cost, and one drawing of the pipeline.

## Why its value is medium

Every agent and every user who runs `Build-Diagrams`, or any cats command under the time safeguard, pays for each item today: a wrong mental
model from the help, a denied or timed-out call from a missing pattern, and a warning that trains readers to ignore warnings. None of it
blocks a feature.

## Recommendations (the agent's, each with its reason)

- Fix the help before anything else: it is the page a reader trusts, and it is wrong on three facts.
- Keep a bare `Build-Diagrams` as the full rebuild; do not make `-Stale` the default. A full rebuild that silently does less breaks the
  one-command promise; the help names `-Stale` and `-Path` as the everyday journeys instead.
- Quiet the glyphs warning in the renderer by role, not by giving the legend a yml: `drawio.yml` already says the glyphs folder is a
  `legend`, and a legend draws no minimaps, so `W_UNDECLARED` asks for something a legend never needs (configure, don't program: the role is
  the config, the renderer reads it).
- Make the minimap stage cheaper by computing each distinct ADR set once per run: 10 of the 11 automation folders share one of two ADR sets,
  so the same minimap data is computed again and again. Measure first; a per-run memo, never a session cache (a guard's verdict is never
  cached across runs). A compiled type only if the measurement says PowerShell is the cost.
- The drawing is one sample for approval, never a batch, and lands only with the article that embeds it.

## Open steps

### Docs

- [ ] `docs/references/pwsh/catzc-base-slides/Build-Diagrams.ps1.md`, `### description`: say the run writes the minimap data of every
      declared folder first, then renders or syncs each; that it prints one line per folder per stage with its position, status and time,
      and the total at the end; that a full run takes minutes and `-Stale` or `-Path` is the everyday journey. Replace the locality
      paragraph with what the code does: every page anywhere that embeds a folder's png is its article, a folder no page embeds is an orphan
      (reported, still rendered), and each page's Supports line is held against the yml (reported as drift). Then rebuild the comment view
      with `Build-CommentView` on `Build-Diagrams.ps1` (check: `Test-Links` on the page, `Test-GeneratedFiles` on its head).

### Instructions

- [ ] `.claude/skills/catzc-run/SKILL.md`: add line 4, a private function runs inside its module, `& (Get-Module <Module>) { … }`, never by
      dot-sourcing its file; add line 5, wait on a background run with a second background call,
      `timeout <s> bash -c 'until grep -q <line> <output>; do sleep 2; done'`, never by polling, and search the tree with the Grep tool,
      never a recursive `grep` (it passes 3 s). The file stays at most 10 lines (check: `Test-AgentDefinitions`).

### Renderer

- [ ] `python/Catzc.Diagrams/drawio_forward.py`: skip `W_UNDECLARED` for a folder whose role in `drawio.yml` `roles:` is `legend`, since a
      legend draws no minimaps; a slide folder with no declaration still warns. Add the case to the renderer's tests, one for each role
      (check: `Invoke-PythonTest` on the Catzc.Diagrams tests, then `Build-Diagrams -Path docs/explanation/.assets/glyphs` prints `clean`).

### Speed

- [ ] Measure: one script in `out/` that times `Write-DiagramMinimapData` over every declared folder and counts the distinct `about.adrs`
      sets; record the numbers in this plan in place of this step (check: the script exits 0 under `timeout 360` and prints the seconds per
      folder and the set count).
- [ ] `pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1`: compute each minimap once per distinct ADR set within one call and
      write it to every folder that shares the set; `Build-Diagrams` passes all declared folders in one call again, keeping its progress
      line per folder (check: `Invoke-TestFile` on both functions' tests, and the measuring script shows the gain). Only if the measurement
      shows the minimap functions themselves are the cost, a compiled type in their place, measured against PowerShell.

### Drawing

- [ ] One sample in `out/diagrams/dark-sample/build-diagrams-pipeline/`: the Build-Diagrams pipeline as symbols (find folders, find
      articles, minimap data, render or sync, report), the minimap stage marked as the cost, `about.adrs`
      `ADR-REPO-SLIDES-MINIMAPSFROMDATA`. Words go in an article, not on the slide. The user approves before anything lands in `docs/`
      (check: `Test-Diagrams -Path` on the sample folder, then the user's approval).
- [ ] On approval: the folder lands under the article that embeds it (the Build-Diagrams reference or an explanation page, the user's pick),
      put with `Build-Diagrams -Path` (check: `Test-Diagrams` on the folder, `Test-Links` on the article).

## Open questions

1. **Where does the pipeline drawing live?** (a, recommended) an explanation page on how a diagram is built, embedding it, so the reference
   page stays generated; (b) embedded in the Build-Diagrams comment page.
