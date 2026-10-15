---
catzc:
  derived:
    path: docs/references/pipelines/ci-automation-expected-failures.yaml.md
    kind: comment-page
    body_sha: b62e57868b53
---

# pipelines/ci-automation-expected-failures.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `trigger:`.

```text
CI pipeline — expected failures. Verifies guardrails work by running
commands that must fail. All steps use continueOnError so the job
succeeds overall.
```

## comment:2

Above `- task: PowerShell@2`.

```text
1b: Multiline RunCommand without DisplayName must fail
    Simulates what invoke-automation.yaml does internally.
    The throw propagates → step goes amber (expected).
```
