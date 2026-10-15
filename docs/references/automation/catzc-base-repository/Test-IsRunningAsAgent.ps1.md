---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/Test-IsRunningAsAgent.ps1.md
    kind: comment-page
    body_sha: d385da52e75f
    adrs: []
    links: []
---

# automation/Catzc.Base.Repository/Test-IsRunningAsAgent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Detects an agent-run shell by the environment variables the agent sets for the processes it spawns:
Claude Code sets CLAUDECODE=1, and agent harnesses set AI_AGENT. The distinction is who owns the
machine's other sessions: a person may stop their own stale processes, an agent must not stop the
person's — it works with what it loaded itself.
```
