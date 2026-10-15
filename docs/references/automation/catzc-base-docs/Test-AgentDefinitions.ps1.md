---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Test-AgentDefinitions.ps1.md
    kind: comment-page
    body_sha: "0e4ff1cba509"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-AGENTS#1
      - ADR-REPO-AGENTS#2
      - ADR-REPO-AGENTS#3
      - ADR-REPO-AGENTS#4
    links: []
---

# automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
sub-agent definitions .claude/agents/*.md, the registry (Get-Config -Config agents, an AgentsConfig), and the
`## Sub-agents` section of .claude/CLAUDE.md
([ADR-REPO-AGENTS](/docs/adr/repository/agent-definitions.md)). It collects an issue when:

  - an agent file has no registry entry, or an entry has no agent file;
  - a file's front matter does not parse, its `name` differs from the file name, or it lacks a `description`,
    a `Do NOT` clause in that description, or `tools`
    ([ADR-REPO-AGENTS#1](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents1));
  - a `supported_by` citation names no rule (Get-CatsAdrRuleIds), or a `checks` entry names no command
    ([ADR-REPO-AGENTS#2](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents2));
  - a registered agent is not listed in the CLAUDE.md section, or a listed agent is not registered
    ([ADR-REPO-AGENTS#3](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents3));
  - a specialised agent is not named in the standard agent's description
    ([ADR-REPO-AGENTS#4](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents4)).

The registry's own shape (citation and command spelling, distinct names, a standard that names an entry) is an
AgentsConfig construction rule, not this gate's.
```
