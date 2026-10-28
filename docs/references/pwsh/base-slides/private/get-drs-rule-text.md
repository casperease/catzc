# pwsh/Base.Slides/private/Get-DrsRuleText.ps1

The reader of a rule's registry text: it resolves a rule code and returns the paragraph under the rule's heading as plain text.

## help

### synopsis

Reads the registry text of one rule, by its rule code.

### description

Resolves the code through the DRS citation map, opens the record, and returns the paragraph under the rule's heading as plain text, links
reduced to their text and whitespace collapsed, so a slide that quotes the rule can be compared to it (ADR-REPO-SLIDES-CHECKABLECLAIMS).
Null when the code names no rule or the index knows no such rule.

### parameter `Code`

One rule code, such as PDR-EAC-DIFFABLEISVERSIONED.

### parameter `RepositoryRoot`

The repository root whose DRS index is read.

### outputs

`[string]` The rule's text, or null.
