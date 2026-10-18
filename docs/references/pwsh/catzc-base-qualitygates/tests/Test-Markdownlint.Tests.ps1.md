# automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Repository markdown integrity' -Tag 'L2', 'integrity', 'source-only' {`, written with `#`.

```text
Integrity: the ACTUAL repository markdown is lint-clean. Unlike the logic test above (real markdownlint over
a fixture file), this binds to the real repo — Test-Markdownlint with no -Path scans its default content
scope ([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). L2 because it drives the
markdownlint-cli2 CLI; self-skips when absent
([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)/9).
Behind a protected glob ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a repeat local run over an
unchanged 'markdown-scope' globset (the
scan's inputs — in-scope markdown plus the markdownlint config) is skipped; in a pipeline the protection
is ignored and the scan always runs full. source-only: it reads the repository's markdown, which gives the same
answer in both run modes.
```
