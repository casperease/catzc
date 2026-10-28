# pwsh/Base.QualityGates/private/Get-DrsCitation.ps1

The DRS citations that the prose of a file and its comment page make, sorted and without duplicates. The scan itself is the compiled
DrsCitationScanner; this function gathers the text and the file's class.

## help

### synopsis

The DRS citations the prose of a file and its comment page makes, sorted and without duplicates.

### description

A citation is `ADR-<CODE>#<n>`; the colon form belongs to a rule's own heading and is no citation. A rule the file defines itself is no
citation of it, and a code the DRS index does not register is no citation. A bare record code, which names a whole record, is a citation in
every class, except the record whose rules the file itself defines. The bare code of a domain is a citation only in a file whose class the
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

The file classes whose citations also count the code of a domain as a whole. Default: the `domain_classes` of drs.yml.

### parameter `RepositoryRoot`

The repository the file is read from. It is one of the run's constants, which a caller over many files resolves once and passes in. Default:
the current repository.

### parameter `Map`

The DRS citation map. Default: `Get-DrsCitationMap` over the repository.

### parameter `Pages`

The comment-pages config, which finds a file's comment page so the citations on it count as the file's own. Default: the `comment-pages`
config.

### parameter `Form`

The drs code form the citations are spelled in. Default: the `CodeForm` of the `drs` config.

### parameter `FileClass`

The file's kind class, which a scope that already resolved it passes in. Default: the class `Get-FileKind` gives the path.

### parameter `Scanner`

The compiled citation scan, built once per run from the form and the map. Default: a scanner over `Form` and `Map`.

### outputs

`[string[]]` the cited codes, a bare record code standing for its rules.

## what counts as a citation

The scan cites body text by code only: a numbered citation or a wildcard in the body is a mention, never a citation. Only a code the DRS
index registers is a citation, so a fixture code or a placeholder named in prose is not one. The domain forms of a code count only in a file
of one of the domain classes the `drs` config names.

## the text

The text is the file's body (or its rest, when it has no body) followed by the body of its comment page, when the page exists.
