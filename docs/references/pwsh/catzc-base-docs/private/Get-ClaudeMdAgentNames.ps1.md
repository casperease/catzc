# pwsh/Catzc.Base.Docs/private/Get-ClaudeMdAgentNames.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the sub-agent names the `## Sub-agents` section of a CLAUDE.md file lists.

### description

Reads the `## Sub-agents` section of .claude/CLAUDE.md (from its heading to the next `##` heading) and returns the name of every bullet that
opens with a name in bold code, ``- **`<name>`**``
([ADR-REPO-AGENTS-LISTEDINCLAUDEFILE](../../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-listedinclaudefile)). Lines that
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
