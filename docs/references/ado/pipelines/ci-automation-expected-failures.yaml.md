# pipelines/ci-automation-expected-failures.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `trigger:`, written with `#`.

```text
CI pipeline — expected failures. Verifies guardrails work by running
commands that must fail. All steps use continueOnError so the job
succeeds overall.
```

## comment:2

Above `- task: PowerShell@2` (occurrence 2), written with `#`.

```text
1b: Multiline RunCommand without DisplayName must fail
    Simulates what invoke-automation.yaml does internally.
    The throw propagates → step goes amber (expected).
```
