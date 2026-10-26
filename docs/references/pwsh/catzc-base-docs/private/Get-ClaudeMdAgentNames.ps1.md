# pwsh/Base.Docs/private/Get-ClaudeMdAgentNames.ps1

The private list reader of `Test-AgentDefinitions`: it returns the agent names bulleted in the `## Sub-agents` section of CLAUDE.md, so the gate
can compare them with the registry.

## help

### synopsis

Lists the sub-agent names the `## Sub-agents` section of a CLAUDE.md file lists.

### description

Reads the `## Sub-agents` section of .claude/CLAUDE.md (from its heading to the next `##` heading) and returns the name of every bullet that
opens with a name in bold code, ``- **`<name>`**``
([ADR-REPO-AGENTS-LISTEDINCLAUDEFILE](../../../../drs/repository/agent-definitions.md#rule-adr-repo-agents-listedinclaudefile)). Lines that
are not such a bullet (prose, continuation lines) are skipped. It returns nothing when the file has no such section.

Private helper for Test-AgentDefinitions; not exported.

### parameter `Path`

Absolute path to the CLAUDE.md file.

### outputs

`[string[]]` The listed names, in file order.

### example 1

```powershell
Get-ClaudeMdAgentNames -Path (Resolve-RepoPath '.claude/CLAUDE.md')
```
