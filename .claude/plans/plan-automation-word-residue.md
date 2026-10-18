---
plan:
  status: active
  value: medium-high
  reviewed: 2026-10-18
  targets: [docs/references/pwsh/.assets, docs]
---

# The word "automation" after the move to pwsh/: retire the folder meaning, keep the layer meaning

The word `automation` keeps its layer meaning (ADR-AUTO-LAYERS-AUTOMATIONISABSTRACT) and loses every meaning of the removed folder. What is
left is the references asset folder, which still carries the old track name, and the links into it. The pipeline names and the avoid
phrasings are P5 and P6 of plan-layers-vocabulary-rename-contracts, not this plan.

## Why its value is medium-high

A folder named after a track that no longer exists misleads every reader and sub-agent that resolves a reference slide's path, and the links
into it must move with it (ADR-PRIN-ONELIVE).

## Decided, and why

- The how-to folders named `automation` keep their name: they hold cross-track pages, and ADR-AUTO-LAYERS makes automation the abstract.
- The test fixtures shaped like the old folder are renamed to a neutral segment only when each test is next edited
  (ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES), with no sweep.

## Open steps

- [x] The user runs `git mv docs/references/.assets/automation docs/references/.assets/pwsh` (a mutating git command; it belongs in
      task-user-runs-and-commits step 5, its references asset bullet). (check: `ls docs/references/.assets/automation` fails) Done
      2026-10-18 by the user (`out/run-user-git.ps1`): "ls: cannot access 'docs/references/.assets/automation': No such file or directory".
- [x] Every page that links into the moved folder is re-pointed by `link-fixer`, after the move. (check: `Test-Links` clean over `docs/`)
      Done 2026-10-18: 22 links re-pointed one file at a time (11 module reference pages to `.assets/<slide>/diagram.drawio.png`, 11 slide
      description pages to `diagram.drawio.png`); "TEST-LINKS docs issues=0" (`out/test-links/20261018-200355`).

## Refs

- `out/automation-usage-overview.md`: the classification report, classes, counts and per-file evidence.
- plan-layers-vocabulary-rename-contracts and task-layers-classification-flip (P5 guards, P6 pipeline names): the globset key `automation`,
  `ci-automation*`, the avoid phrasings.
- ADR-AUTO-LAYERS (the layer doctrine), ADR-PRIN-ONELIVE (no residue of the old shape), ADR-REPO-PLANS (this file's shape).
