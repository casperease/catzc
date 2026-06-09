# Catzc.Azure.Firewall

The firewall-rule module. It is a small, focused converter: it takes firewall rules authored in a spreadsheet-friendly source and renders
them into the forms the rest of the system consumes — structured YAML for infrastructure, and a readable table for documentation. It changes
no cloud state; it transforms data between representations.

## Domains

| Domain   | Area   | Name                                                     |
| -------- | ------ | -------------------------------------------------------- |
| domain:1 | ingest | [Rule source ingestion](#domain1--rule-source-ingestion) |
| domain:2 | render | [Rule rendering](#domain2--rule-rendering)               |

### domain:1 — Rule source ingestion

Reading firewall rules from their authoring source — a CSV in a storage account (firewall), or a direct read to the azure control plane
(ipgs) — into structured records the rest of the module works with. This is the single entry point that turns the human-edited source into
data.

### domain:2 — Rule rendering

Turning those ingested rules into their target representations: YAML for infrastructure to consume, a Markdown table for humans to read, and
the IP-group YAML that groups addresses for reuse. Each renderer is a one-directional projection of the ingested rules into one output
shape.

## What the module does

The module exists because firewall rules have two audiences with incompatible preferences. People want to author and review rules in a
spreadsheet, where columns and bulk edits are natural; infrastructure wants them as structured YAML; and documentation wants a table. Rather
than maintain those forms in parallel and let them drift, the module keeps a single authored source and _projects_ it into each consumer's
shape on demand.

Domain 1 is the one place the authored source is parsed, so every projection starts from the same in-memory rules. Domain 2 is a set of pure
renderers over those rules — none of them feeds back into the source, and adding a new output shape means adding another projection, not
another source of truth. The result is the everything-as-code discipline applied to a network artifact: the spreadsheet is the editable
source, version control holds it, and the YAML and Markdown are generated, never hand-maintained (see
[everything-as-code](../../adr/principles/everything-as-code.md)).

## Division

The module's public functions, sorted into the domains above.

| Domain                           | Function                        |
| -------------------------------- | ------------------------------- |
| domain:1 — Rule source ingestion | `Get-FirewallCsv`               |
|                                  | `Get-FirewallIpgsYaml`          |
| domain:2 — Rule rendering        | `Convert-FirewallCsvToYaml`     |
|                                  | `Convert-FirewallCsvToMarkdown` |
