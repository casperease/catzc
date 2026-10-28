# pwsh/Base.QualityGates/private/Group-DrsUsage.ps1

Groups DRS usage rows by the rule they cite or by the document that cites them. It is pure: it takes the rows Get-DrsUsageRow returns and
reads nothing else.

## help

### synopsis

Groups DRS usage rows by the rule they cite or by the document that cites them.

### description

Pure: it takes the rows Get-DrsUsageRow returns and reads nothing else. Grouping by Rule gives one row per code and rule (a null Rule is the
whole record), sorted by code and rule with the whole record first, listing the documents that cite it. Grouping by Document gives one row
per citing file, sorted by path, listing the citations it holds. Count is the number of documents or citations in the list.

### parameter `Row`

The usage rows, each @{ Path; Code; Rule; Source }.

### parameter `By`

`Rule` or `Document`.

### outputs

`[pscustomobject]` one per group, by Rule @{ Code; Rule; Count; Documents }, by Document @{ Path; Count; Citations }, each list sorted
without duplicates.
