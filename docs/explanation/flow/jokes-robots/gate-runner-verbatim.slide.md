---
catzc:
  config:
    pattern: fact
    deck: jokes-robots
    order: 7
    picture:
      mode: reduce
      source: ../../automation/.assets/one-commit-one-immutable-package.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-REPO-AGENTS
---

# The gate runner brings the verdict back verbatim, which is why nobody invites it to parties

## Eyebrow

7 / 10 · fact · ADR-REPO-AGENTS

## Lead

One gate or test file, run in the background under the time safeguard, pass or fail, with the failing lines.

## Image

.assets/gate-runner-verbatim.png

## Caption

From the catalogue, reduced: one commit one immutable package.

## Notes

Check it: the record ADR-REPO-AGENTS in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/one-commit-one-immutable-package.drawio.png.
