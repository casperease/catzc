# pwsh/Base.Docs/private/Get-FrontPageRuleTitle.ps1

Names one rule for a reader of the front page: the short phrase its record already words for it, so a link to a rule reads as a few words
rather than a whole record title.

## help

### synopsis

Returns the short phrase of a rule, the text of the first decision link under its heading.

### description

Finds the rule's heading by its anchor in the record and returns the text of the first bullet link under it. A rule with no such link takes
the record's title (Get-FrontPageRecordTitle). An anchor the record has no rule for throws.

### parameter `RecordPath`

The record, relative to the repository root.

### parameter `Anchor`

The rule's anchor without the leading `#`, such as `rule-<code>`.

### outputs

`[string]` the phrase.
