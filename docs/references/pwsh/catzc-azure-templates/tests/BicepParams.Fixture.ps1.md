# pwsh/Catzc.Azure.Templates/tests/BicepParams.Fixture.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:compileBicepParams = {`, written with `#`.

```text
A literal-only stand-in for `bicep build-params` in L0 tests that mock Invoke-AzCli: it reads `param <name> = <literal>` lines (a
single-quoted string, an integer, true, false or null) and writes the ARM parameters JSON. Any other line throws, naming it; it never
guesses. The real compile is proven at L2.
```

## comment:2

Above `$script:readBicepParams = {`, written with `#`.

```text
A strict stand-in for `bicep build-params` in L0 tests that mock Invoke-AzCli. It reads exactly the forms BicepParamWriter writes —
a one-line literal (a single-quoted string, an integer, true, false or null), a multi-line [ ] or { } block of those, and az.getSecret
on one line or one argument per line — and writes the ARM parameters JSON. Any other line throws, naming it; it never guesses. The real
compile is proven at L2.
```
