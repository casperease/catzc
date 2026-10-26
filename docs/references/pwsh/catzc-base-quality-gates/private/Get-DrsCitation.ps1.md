# pwsh/Base.QualityGates/private/Get-DrsCitation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The ADR citations the prose of a file and its comment page makes, sorted and without duplicates.

### description

A citation is `ADR-<CODE>#<n>`; the colon form belongs to a rule's own heading and is no citation. A rule the file defines itself is no
citation of it, and a code the ADR index does not register is no citation. A bare record code, which names a whole ADR, is a citation in
every class, except the record whose rules the file itself defines. A bare ADR domain code is a citation only in a file whose class the
`domain_classes` of drs.yml names. The codes come from the text alone, never from a head
([ADR-REPO-FILEMETA-NOREADBACK](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)), and the codes inside a
`yml drawio` block are the diagram's, never the prose's. The spelling is
[ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling), and the order is
ordinal, so a rerun never moves a code. Get-DrsUsage reads its rows through it.

### parameter `State`

What Get-CodeMetaState or Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `DomainClasses`

The file classes whose citations also count the code of a whole ADR domain. Default: the `domain_classes` of drs.yml.

### outputs

`[string[]]` the cited codes, a bare record code standing for its rules.

## comment:1

Above `foreach ($match in [regex]::Matches($prose,...`, written with `#`.

```text
Body text cites by code only: a numbered citation or a wildcard there is a mention, never a citation.
```

## comment:2

Above `foreach ($code in @($found)) {`, written with `#`.

```text
Only a code the ADR index registers is a citation: a fixture code or a placeholder named in prose is not. A bare record code is one
in every class, except the record the file itself defines rules of; a bare domain code only in a code class.
```
