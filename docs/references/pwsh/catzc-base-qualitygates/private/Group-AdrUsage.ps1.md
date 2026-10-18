# pwsh/Catzc.Base.QualityGates/private/Group-AdrUsage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Groups ADR usage rows by the rule they cite or by the document that cites them.

### description

Pure: it takes the rows Get-AdrUsageRow returns and reads nothing else. Grouping by Rule gives one row per code and rule (a null Rule is the
whole ADR), sorted by code and rule with the whole ADR first, listing the documents that cite it. Grouping by Document gives one row per
citing file, sorted by path, listing the citations it holds. Count is the number of documents or citations in the list.

### parameter `Row`

The usage rows, each @{ Path; Code; Rule; Source }.

### parameter `By`

`Rule` or `Document`.

### outputs

`[pscustomobject]` one per group, by Rule @{ Code; Rule; Count; Documents }, by Document @{ Path; Count; Citations }, each list sorted
without duplicates.
