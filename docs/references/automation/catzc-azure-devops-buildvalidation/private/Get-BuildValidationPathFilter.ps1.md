---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
    kind: comment-page
    body_sha: "6948db1d08f3"
    adrs:
      - ADR-FLOW-CD-TYPE#4
---

# automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single place the build-validation policy's `filenamePatterns` is derived (used by both
Register- and Unregister-AdoBuildValidation), so the create side and the match-to-remove side always
agree. Projects the globset to its GitHub-ordered native path list (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)) —
'!' negation and last-match-wins, which ADO branch-policy path filters honour — and anchors each pattern
with a leading '/', mapping '!p' to '!/p'. This is the same set of globs the pipeline triggers on; the
policy is the server-side pre-commit half of that binding
([ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)), never a committed marker.
```
