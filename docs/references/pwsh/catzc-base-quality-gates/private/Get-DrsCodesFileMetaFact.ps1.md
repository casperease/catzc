# pwsh/Catzc.Base.QualityGates/private/Get-DrsCodesFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The adr-codes meta kind's fact: the ADR citations the file and its comment page make, sorted and without duplicates.

### description

A citation is `ADR-<CODE>#<n>`; the colon form belongs to a rule's own heading and is no citation. A rule the file defines itself is listed
under `defines`, never here, and a code the ADR index does not register is no citation. A file whose class the kind's `domain_classes`
setting names also lists a bare `ADR-<CODE>`; the setting defaults to the classes the kind selects. The codes come from the text alone,
never from the head ([ADR-REPO-FILEMETA-NOREADBACK](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)). The
spelling is [ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling), and
the order is ordinal, so a rerun never moves a code.

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.

## comment:1

Above `foreach ($match in [regex]::Matches($text,...`, written with `#`.

```text
Body text cites by code only: a numbered citation or a wildcard there is a mention, never a citation.
```
