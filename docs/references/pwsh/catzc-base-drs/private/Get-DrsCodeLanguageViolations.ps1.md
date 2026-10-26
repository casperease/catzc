# pwsh/Base.Drs/private/Get-DrsCodeLanguageViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every ADR code and rule heading that breaks the ADR code language.

### description

An ADR code is a path of upper-case segments after `ADR`, its second segment the domain's one-segment code, and a rule is named by one
segment below its ADR, never numbered ([adr-code-language](../../../../drs/repository/drs-code-language.md)). This collects a finding for a
domain code of more than one segment, a code outside the segment grammar, a code that does not start with its domain's segment, a rule
heading that is not its ADR's code plus one segment, and a rule named like an ADR. The numbered rule headings of one ADR file are one
finding with their count. Rule headings inside a code fence are skipped, and a rule set with no file, or several, is a finding of
Test-DrsRegistry and is skipped here.

Private helper for Test-DrsRegistry; not exported.

### parameter `Adrs`

The ADR registry (Get-Config -Config drs).

### parameter `Index`

The docs/drs/ file index (Get-DrsFileIndex).

### outputs

`[string[]]` One finding per code, domain, rule heading, or ADR file with numbered rule headings, each ending with the rule it breaks.

## comment:1

Above `$prefix = $domain.Kind`, written with `#`.

```text
A domain code of several segments is one finding; its ADRs are held to its first segment. A kind one domain
owns has no domain code.
```
