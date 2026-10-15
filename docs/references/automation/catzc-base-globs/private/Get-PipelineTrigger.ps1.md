---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
    kind: comment-page
    body_sha: a58d07ce18bc
---

# automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The counterpart to Get-GlobSetTrigger (which computes what a pipeline's trigger SHOULD be): this reads
what it actually IS, so an integrity quality gate can compare the two (Test-AdoPipelineTriggerGlob /
Test-GitHubWorkflowTriggerGlob, [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)). Parses the file with
ConvertFrom-Yaml and pulls the filters:

- Ado: trigger.paths.include/exclude and pr.paths.include/exclude.
- GitHub: on.push.paths and on.pull_request.paths. YAML 1.1 parses the bare key 'on' as the boolean
  true, so both the string key 'on' and the boolean key are tried.

A missing section comes back as an empty array, never $null, so a caller compares without null guards.
```
