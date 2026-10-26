# pwsh/Azure.Firewall/tests/Convert-FirewallCsvToYaml.Tests.ps1

The L0 tests of the CSV-to-YAML conversion: the rule list and its provenance header.

## The header time

The check on the `# CSV generated: ... UTC` header keeps the literal colon. The function formats with the invariant culture, so every
machine renders `10:32`; a machine whose locale writes a dot, such as a da-DK box, would otherwise render `10.32`, and the literal colon
guards against that regression.
