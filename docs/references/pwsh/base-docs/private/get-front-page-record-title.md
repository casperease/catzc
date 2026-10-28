# pwsh/Base.Docs/private/Get-FrontPageRecordTitle.ps1

Names a decision record for a reader of the front page: its title as a sentence, without the kind or code the index puts before it.

## help

### synopsis

Returns a record's title without its leading kind or code, capitalised.

### description

Reads the record's first level-one heading, drops everything up to the first colon and its space, and capitalises the first letter. A record
with no title throws.

### parameter `RecordPath`

The record, relative to the repository root.

### outputs

`[string]` the title.
