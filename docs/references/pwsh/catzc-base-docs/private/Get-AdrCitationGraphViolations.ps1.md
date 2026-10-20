# pwsh/Catzc.Base.Docs/private/Get-AdrCitationGraphViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every citation in an ADR page that leaves its domain for a domain the registry does not declare it depends on.

### description

An ADR page, its rule summaries and its body prose alike, may cite only its own domain or a domain in its domain's depends_on list in
adrs.yml. The list is read as declared, not transitively: like the module dependency graph, it is an allow-list of direct edges, so a domain
that cites another names it. A fenced block is not read. A finding names the rule whose block holds the line, or the ADR's code for a line
outside the rule registry.

Two kinds of reference are read in every line:

- a citation code, `ADR-<CODE>` or `ADR-<CODE>#<n>`, resolved to its domain through the registry (an External code, or a domain's code in a
  wildcard such as `ADR-<CODE>-*`); a code the registry does not know is left to Test-Links;
- a markdown link whose target is a file under `docs/adr/<domain>/` (Resolve-AdrLinkTarget).

Each line reports the domain it cites once, naming the first reference to it.

Private helper for Test-AdrRegistry; not exported.

### parameter `Adrs`

The ADR registry (Get-Config -Config adrs).

### parameter `Index`

The docs/adr/ file index (Get-AdrFileIndex).

### outputs

`[string[]]` One finding per violation: '`<file>:<line>`: `<rule>` (`<domain>`) cites `<reference>` (`<domain>`); `<domain>` depends on:
...'.
