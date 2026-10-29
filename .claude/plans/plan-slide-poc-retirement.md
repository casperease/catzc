---
plan:
  status: active
  value: high
  reviewed: 2026-10-29
  class: feature
  targets:
    - python/diagrams
    - pwsh/Base.Slides
    - docs/explanation/flow
    - docs/explanation/thesis
    - docs/references
    - .claude/skills/diagram-review/SKILL.md
    - pwsh/Base.Docs/configs/capabilities.yml
---

# Slide proofs of concept: prove the machine, harvest the ideas, then delete them

## Why its value is high

The 207 `.slide.md` files in 13 decks (`docs/explanation/flow/*`, `docs/explanation/thesis/product-thesis`) are proofs of concept that built
the slide machine; they are not the slides people will see. What has value is the machine (`Build-Diagrams`, `Build-SlideDeck`,
`Test-Diagrams`, `Test-Slides`, the engine in `python/diagrams/`), good diagrams, and the style and ideas the proofs found. The slides
themselves are deleted once those are kept.

## Decided (the user, 2026-10-29)

- The slides are not reviewed one by one; the one-slide review cycle is dropped, and its skill goes with the proofs.
- Order: the slides stay in the tree untouched until the last step; the diagrams are made good and the diagram and slide commands proven
  first; the slides are read and harvested next; they are deleted last.
- The harvest is one reference page, `docs/references/slides/slide-style-and-ideas.md`: the style that worked (layouts, symbols, colours,
  how words and pictures split) and the ideas worth a real slide for humans (core concepts, wins, problems solved), each naming the deck it
  came from. Real slide shows are a later plan, built from that page.
- Diagram fixes go engine-first (`python/diagrams/`, then the language in `python/diagrams/configs/drawio.yml`, then one declaration), each
  recorded in the veto list `out/diagram-review-findings.md`; a language change keeps every declaration valid or corrects all of them in the
  same change (PDR-ONELIVE).
- Every special rendering of a diagram for a slide is bad and goes with the slide that owns it (the user, 2026-10-29): no diagram fix,
  review round or harvested style is spent on a slide-only rendering; the diagram work covers only the diagrams articles embed.

- An edge word says what the tail does to the head (the user, 2026-10-29): `feeds` is wrong unless the tail puts work on the head's queue,
  so it leaves the vocabulary. A diagram's name binds it to the system in plain words; the mechanism lives in the article and the markers.

## Open steps

- [ ] `pwsh/Base.Languages/Invoke-PythonTest.ps1`: a strict editable install's link whose content differs from its source (an edit that
      replaced the file broke the hardlink, so tests and renders run the stale copy) throws naming the relink command, as a missing link
      does today (check: `Invoke-TestFile -Path pwsh/Base.Languages/tests/Invoke-PythonTest.Tests.ps1`, with a case for a broken link).
- [ ] Every article-embedded diagram's `about.title` and article heading name the part of the system it shows, never its mechanism (approved
      examples: "How a command's time limit is chosen", "How an Azure resource gets its name"), and the diagram is renamed with it in the
      same change: its `.drawio.png` (and `.drawio.yml`) stem and the article that carries it take the kebab form of the new title, through
      `Move-Diagram`, links included (check: `Test-Links` and `Test-Diagrams` clean on each moved diagram).
- [ ] `out/diagram-findings.md`: one haiku round over what it lists as unchecked (rows and titles on its lines 181-570), batches of 10,
      skipping every slide-only rendering, each finding fixed by cause as above (check: a per-diagram list per batch, and `Test-Diagrams`
      clean over the tree).
- [ ] `pwsh/Base.Slides`: the diagram and slide commands proven working: each command's own test file green, then one deck built end to end
      with `Build-SlideDeck` and its pages looked at (check: `Invoke-TestFile` on each of `Build-Diagrams`, `Build-SlideDeck`,
      `Test-Diagrams`, `Test-Slides` tests, and `Test-Slides` clean on that deck).
- [ ] `docs/references/slides/slide-style-and-ideas.md`: written from a read of every deck, one deck at a time, the text read and the
      slides' layout looked at, their special diagram renderings taken as bad; style and ideas each name their source deck (check:
      `Test-Links` and `Test-Spelling` clean on the page, and every one of the 13 decks named in it).
- [ ] The 13 decks deleted from disk: every `.slide.md`, each deck's index and build output, and every special rendering a slide owns (each
      `.drawio.png`/`.drawio.yml` only a slide uses); a diagram an article embeds stays (check: `git ls-files '*.slide.md'` lists none after
      the user commits, `Test-Links` and `Test-Diagrams` clean over `docs`).
- [ ] `.claude/skills/diagram-review/SKILL.md` deleted with its row in `pwsh/Base.Docs/configs/capabilities.yml` (check:
      `Test-AgentDefinitions` reads 0 issues).
