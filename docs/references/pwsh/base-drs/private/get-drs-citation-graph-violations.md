# pwsh/Base.Drs/private/Get-DrsCitationGraphViolations.ps1

The private helper of `Test-DrsRegistry` that finds record citations leaving their domain for one it does not depend on.

## help

### synopsis

Lists every citation in a record page that leaves its domain for a domain the registry does not declare it depends on.

### description

A record page, its rule summaries and its body prose alike, may cite only its own domain or a domain in its domain's depends_on list in
drs.yml. The list is read as declared, not transitively: like the module dependency graph, it is an allow-list of direct edges, so a domain
that cites another names it. A fenced block is not read. A finding names the rule whose block holds the line, or the record's code for a
line outside the rule registry.

Two kinds of reference are read in every line:

- a citation code, `ADR-<CODE>` or `ADR-<CODE>#<n>`, resolved to its domain through the registry (an External code, or a domain's code in a
  wildcard such as `ADR-<CODE>-*`); a code the registry does not know is left to Test-Links;
- a markdown link whose target is a file under `docs/drs/<domain>/` (Resolve-DrsLinkTarget).

Each line reports the domain it cites once, naming the first reference to it.

Private helper for Test-DrsRegistry; not exported.

### parameter `Drs`

The DRS registry (Get-Config -Config drs).

### parameter `Index`

The docs/drs/ file index (Get-DrsFileIndex).

### parameter `ExemptDomain`

Domains whose own citations are not held to their dependencies, such as a domain of external records that binds to the records it serves.

### outputs

`[string[]]` One finding per violation: '`<file>:<line>`: `<rule>` (`<domain>`) cites `<reference>` (`<domain>`); `<domain>` depends on:
...'.

## Which domain a link belongs to

A link's domain is the one with the longest folder that holds its target, so a domain folder nested in another keeps its own links.
