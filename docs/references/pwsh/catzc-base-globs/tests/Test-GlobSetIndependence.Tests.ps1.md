# pwsh/Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GlobSetIndependence'`, written with `#`.

```text
Test-GlobSetIndependence is a quality gate
([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over per-layer independence
([FDR-CD-GLOBS-NOOVERLAPWITHINLAYER](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nooverlapwithinlayer)). The registry, the derived
module sets and the tracked-file universe are mocked with neutral fixtures (widget/gadget,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the report goes to $TestDrive.
```
