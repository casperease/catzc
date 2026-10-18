# automation/Catzc.Azure.Firewall/tests/Convert-FirewallCsvToYaml.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `(Get-Content $out -Raw) | Should -Match '# CSV generated: 2026-06-16 10:32 UTC'`, written with `#`.

```text
Literal ':' guards against the locale separator regression — the function formats with
InvariantCulture, so every machine renders 10:32 (a da-DK box without it would render 10.32).
```
