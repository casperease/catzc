# pwsh/Base.QualityGates/private/Invoke-MarkdownTitleEngine.ps1

Checks every in-scope Markdown file's title and headings. Format-MarkdownTitle and Test-MarkdownTitle share it: it resolves the scope, reads
each file, checks the title and then the headings of the titled files.

## help

### synopsis

Checks every in-scope Markdown file's title and headings — the one place Format-MarkdownTitle and Test-MarkdownTitle share.

### description

Resolves the scope (Get-MarkdownScope), reads each file, checks its title (Get-MarkdownTitleFinding) and then its headings on the titled
text (Get-MarkdownHeadingFinding), so the formatter and the gate can never disagree. When a heading's anchor changes, every in-scope file —
the whole scope, even when Path narrows the check — has its links to that anchor re-pointed (Get-RepointedMarkdownText) and carries an
Anchor finding.

### parameter `RepositoryRoot`

The repository root titles are relative to.

### parameter `Path`

Optional files or folders to limit the scope to.

### outputs

`[pscustomobject]` @{ FileCount; Files } — Files holds every file with a finding: @{ Path; Findings; Fixed }, each finding @{ Path; Line;
Kind; Actual; Expected }.
