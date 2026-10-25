# pwsh/Catzc.Tooling.Inspiration/configs/inspiration.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `{}`, written with `#`.

```text
inspiration.yml — the inspirations catzc reads for ideas, never as a reference implementation
([ADR-REPO-INSPIRE](/docs/drs/repository/inspiration.md)). Get-Inspiration lists them and reports whether each is
available on this machine. Validated on load by InspirationConfig, which declares the sensible default once: an
empty file, or an omitted 'inspirations' key, is the one eac entry shown below
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)); set the key only to change it.

  inspirations:
    - id: eac                                   # kebab-case
      root: "{workspace}/eac"                   # {workspace}/folder or repository-relative; never absolute or '..'
      description: Sibling Go monorepo of the same project family. Ideas, not a reference implementation.
      paths: [docs, specs, contracts, go]       # optional: the folders worth reading

{workspace} is the parent folder of the repository root, where sibling checkouts live
([ADR-AUTO-PATH-WORKSPACEANCHOR](/docs/drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)).
```
