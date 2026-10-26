# pwsh/Base.Drs/private/Get-DrsRuleSummaryLines.ps1

The private helper that returns the normative lines of every rule summary in one ADR file, for the engine-neutrality check.

## help

### synopsis

Returns every line of every rule summary in one ADR file, with its line number and the rule's citation.

### description

A rule summary is the body of a `### Rule <code>:<n>` entry in an ADR's rule registry: every line from the line after the heading to the
next heading. Blank lines, lines inside a fenced block, and the summary's own anchor bullets (`- [Section](#section)`, the internal links to
the prose that justifies the rule) are left out: what remains is the normative text. The rule is named in its citation form, `<code>#<n>`
([ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)).

Private helper for Test-DrsEngineNeutrality; not exported.

### parameter `Path`

The absolute path of the ADR markdown file.

### outputs

`[pscustomobject[]]` One { Rule; Line; Text } per summary line, in file order; Line is 1-based.
