# automation/Catzc.Base.Docs/private/Get-AgentFrontMatter.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Parses the YAML front matter of one sub-agent definition file.

### description

Reads the block between the opening `---` line (the file's first line) and the next `---` line of a `.claude/agents/<name>.md` file and
parses it as YAML ([ADR-REPO-AGENTS#1](../../../../adr/repository/agent-definitions.md#rule-adr-repo-agents1)). It throws when the file has
no front-matter block, when the block is not valid YAML, or when the block is not a mapping, so the caller (Test-AgentDefinitions) records
one issue per unreadable file.

Private helper for Test-AgentDefinitions; not exported.

### parameter `Path`

Absolute path to the agent definition file.

### outputs

`[System.Collections.IDictionary]` The front-matter keys and values, in file order.

### example 1

```powershell
Get-AgentFrontMatter -Path (Resolve-RepoPath '.claude/agents/catzc-worker.md')
```
