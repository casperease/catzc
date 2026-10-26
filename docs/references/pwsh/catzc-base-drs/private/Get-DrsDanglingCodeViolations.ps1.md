# pwsh/Base.Drs/private/Get-DrsDanglingCodeViolations.ps1

The private helper of `Test-DrsRegistry` that finds citation codes in the ADR pages which name nothing the registry knows.

## help

### synopsis

Lists every citation code in the docs/drs pages that names no registered rule, record or domain.

### description

Reads every line of the docs/drs/ file index outside fenced blocks for a code in the registry's cited form. A code is a finding when the
citation map knows it neither as a rule, nor as a record's code, nor as a domain's code. A code followed by `#` or `:<n>` is left to the
code-language check.

Private helper for Test-DrsRegistry; not exported.

### parameter `Adrs`

The ADR registry (Get-Config -Config drs).

### parameter `Index`

The docs/drs/ file index (Get-DrsFileIndex).

### parameter `Map`

The citation map the codes are resolved against (Get-DrsCitationMap).

### outputs

`[string[]]` One finding per dangling code: '`<file>:<line>`: cites `<code>`, which names no registered rule, record or domain (a dangling
code)'.

## What counts as a citation

A code named in prose is a citation like a link: one that names no registered rule, record or domain dangles. Fenced blocks are examples, so
they are left out. A code followed by `#` or `:<n>` is another form, which the code-language check owns.

## Fences

A fence closes only on a bare run of its own character at least as long as the one that opened it, so a four-tick fence can hold a
three-tick example whole.
