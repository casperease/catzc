---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/every-deploy-stage-is-main-only.drawio.png
      scale: 0.4
---

# Every repository-changing git command runs at the user's hand

## Eyebrow

3 / 12 · fact · FDR-GIT

## Lead

Tooling resolves the sync point, counts commits and says what to run next; it never fetches, rebases, commits or pushes for the user.

## Image

.assets/user-runs-git.png

## Caption

From the catalogue, reduced: every deploy stage is main only.

## Notes

Check it: the record FDR-GIT in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/every-deploy-stage-is-main-only.drawio.png.
