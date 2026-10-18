# automation/Catzc.Azure.DevOps/tests/Set-AdoPipelineVariable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The ##vso line goes through the writer chokepoint, which a test run silences; lift the guard so the tests can
capture it (every call below captures with 6>&1, so nothing reaches a real pipeline log).
The guard exists only under Test-Automation, so it is read strict-clean and, when it was absent, removed again.
```
