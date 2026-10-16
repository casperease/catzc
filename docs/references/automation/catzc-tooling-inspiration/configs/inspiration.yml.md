---
catzc:
  immutable:
    with_body_sha: "10cb072ee225"
    path: docs/references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md
    folder: docs/references/automation/catzc-tooling-inspiration/configs
    name: inspiration-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-PATH#11
---

# automation/Catzc.Tooling.Inspiration/configs/inspiration.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `{}`, written with `#`.

```text
inspiration.yml — the inspirations catzc reads for ideas, never as a reference implementation
([ADR-REPO-INSPIRE](/docs/adr/repository/inspiration.md)). Get-Inspiration lists them and reports whether each is
available on this machine. Validated on load by InspirationConfig, which declares the sensible default once: an
empty file, or an omitted 'inspirations' key, is the one eac entry shown below
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)); set the key only to change it.

  inspirations:
    - id: eac                                   # kebab-case
      root: "{workspace}/eac"                   # {workspace}/folder or repository-relative; never absolute or '..'
      description: Sibling Go monorepo of the same project family. Ideas, not a reference implementation.
      paths: [docs, specs, contracts, go]       # optional: the folders worth reading

{workspace} is the parent folder of the repository root, where sibling checkouts live
([ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11)).
```
