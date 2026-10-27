# pwsh/Base.Docs/private/Format-FrontPageRecords.ps1

Renders a `records` section of the front page: its intro and a table of the decision records it names, each with the first sentence of its
first rule.

## help

### synopsis

Formats a front-page records section as its intro and a record-and-rule table.

### description

Looks each named code up in the DRS index and takes the first sentence of the record's first rule, its links rebased from the record to
the page. A link that names a record by its code is renamed by the record's title (Get-FrontPageRecordTitle), and one that names a rule by
the rule's short phrase (Get-FrontPageRuleTitle), so the reader meets sentences. The table is padded the way the formatter pads one. A code the index does not list, or a record with no rule, throws.

### parameter `Section`

The records section of frontpage.yml.

### parameter `Folder`

The front page's folder, relative to the repository root, that the links are rebased to.

### outputs

`[string]` the section body.
