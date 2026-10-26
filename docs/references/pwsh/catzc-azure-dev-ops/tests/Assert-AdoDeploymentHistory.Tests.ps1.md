# pwsh/Azure.DevOps/tests/Assert-AdoDeploymentHistory.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:runs = @{`, written with `#`.

```text
Run 10 is the CI run that built commit aaa; run 11 built bbb. Runs 20 and 21 are DEPLOY runs naming a CI run;
run 30 is a CD run.
```
