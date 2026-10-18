---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/implementation-domains.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: implementation-domains-slide
    filetype: md
    role: slide
    language: markdown
    track: docs
    tracktype: documentation
  config:
    pattern: tiles
    deck: product-thesis
    order: 19
---

# Seven implementation domains

## Eyebrow

Where the principles become enforced code

## Body

Automation states the rules for any execution engine; PowerShell realises them in one; configuration gives every domain its single way to
read a config; pipelines and GitHub bind the flow model to two vendors; Azure is the substrate; repository is the tree itself.

## Tiles

- Automation, the CLI and modules
- PowerShell, one execution engine
- Configuration, one reader
- Pipelines, Azure DevOps
- GitHub, the release workflow
- Azure, the substrate
- Repository, the tree

## Notes

Each of these cites the principles as the reason for its own decisions, and the ADR index names what each depends on.
