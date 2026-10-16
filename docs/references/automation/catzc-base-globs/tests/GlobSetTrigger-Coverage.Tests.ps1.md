---
catzc:
  immutable:
    with_body_sha: d6378d1c74a8
    repo_status: locked
    path: docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
    folder: docs/references/automation/catzc-base-globs/tests
    name: glob-set-trigger-coverage-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Native-trigger projection coverage' -Tag 'L2', 'integrity',...`, written with `#`.

```text
Coverage of the native-trigger projection over THIS repo's real tree
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)), through its quality gate
(Test-GlobSetTriggerCoverage — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The
guaranteed safety property: every member of a pipeline-bound set matches at least one ADO include pattern — so an ADO
include-only trigger is always a SUPERSET of exact membership and can never under-trigger (miss a deploy); the
in-pipeline Test-GlobSetAffected check supplies exactness on top. (GitHub is exact by construction: its ordered
'!'-negation paths ARE the scan program, the same evaluator as GlobSet.Matches — covered at L0.)
```
