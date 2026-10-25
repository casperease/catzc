# pwsh/Catzc.Base.Globs/private/Test-GlobListEqual.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Compares two glob-pattern lists for equality — ordered for GitHub, as a set for Azure DevOps.

### description

The comparison behind the trigger-drift quality gates (Test-AdoPipelineTriggerGlob / Test-GitHubWorkflowTriggerGlob). ADO path filters are
order-independent (union include minus union exclude), so a set comparison is correct and an ordinal sort makes it deterministic
([ADR-AUTO-XPLAT](../../../../drs/automation/cross-platform.md) — Sort-Object is culture-aware). GitHub paths are ordered last-match-wins
('!' negation), so -Ordered compares element by element. Matching is case-sensitive (tracked paths are case-sensitive identities,
[FDR-CD-GLOBS-REPOSITORYRELATIVEPATTERNS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-repositoryrelativepatterns)).

### parameter `Reference`

The expected pattern list.

### parameter `Difference`

The actual pattern list.

### parameter `Ordered`

Compare element by element (GitHub); omit for a set comparison (ADO).

### outputs

`[bool]` $true when the lists are equal under the chosen comparison.
