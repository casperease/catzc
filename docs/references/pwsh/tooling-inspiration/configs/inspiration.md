# pwsh/Tooling.Inspiration/configs/inspiration.yml

The inspirations catzc reads for ideas, never as a reference implementation ([ADR-REPO-INSPIRE](../../../../drs/repository/inspiration.md)).
`Get-Inspiration` lists them and reports whether each is available on this machine.

## Default

The file is empty on purpose. The sensible default is declared once on its type, `InspirationConfig`, so an empty file and an omitted
`inspirations` key both yield the one `eac` entry
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). Set the
key only to change it.

## Keys

The default, written out:

```yaml
inspirations:
  - id: eac # kebab-case
    root: "{workspace}/eac" # {workspace}/folder or repository-relative; never absolute or '..'
    description: Sibling Go monorepo of the same project family. Ideas, not a reference implementation.
    paths: [docs, specs, contracts, go] # optional: the folders worth reading
```

`{workspace}` is the parent folder of the repository root, where sibling checkouts live
([ADR-AUTO-PATH-WORKSPACEANCHOR](../../../../drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)).
