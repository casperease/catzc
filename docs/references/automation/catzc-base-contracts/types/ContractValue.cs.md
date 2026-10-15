---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/types/ContractValue.cs.md
    kind: comment-page
    body_sha: cc0526de0c61
    adrs:
      - ADR-REPO-CONTRACT#6
    links: []
---

# automation/Catzc.Base.Contracts/types/ContractValue.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The value model the contract checks compare: a parsed JSON or YAML document as PowerShell hands it over
(ConvertFrom-Json -AsHashtable, the vendored ConvertFrom-Yaml -Ordered), read as one of seven JSON kinds
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)).
  object   any IDictionary (Hashtable, OrderedHashtable, OrderedDictionary); keys compare as invariant strings, ordinally
  array    any IList (object[], List<object>)
  string   a string (the YAML parser leaves a timestamp a string)
  integer  an integral CLR number (Int32, Int64, BigInteger, ...), or a fractional one with no fraction (1.0)
  number   any CLR number; every integer is a number too
  boolean  a bool
  null     null
A PSObject wrapper is looked through at every node. A value of any other CLR type is not JSON-shaped, and Kind
throws, naming the type: the parsers above never produce one, so meeting one is a misuse, not a failed check.

Equal is JSON equality: numbers compare by value whatever their CLR type (YAML's Decimal 1.5 equals JSON's Double
1.5), strings ordinally, objects by the same key set with equal values, arrays by length and pairwise in order.
A location in a value is named in JSONPath form: $ is the document, .key or ['key'] a member, [n] an array element.
```

## comment:2

Above `public const int DescribeLimit = 80;`.

```text
A value as a finding names it, on one line: a string quoted ('gadget'), any other scalar as its text, an object as
{key: value, ...} and an array as [value, ...]. A rendering longer than DescribeLimit characters is cut there and
ends in "...".
```
