# pwsh/Base.Drs/private/Get-DrsCodeLanguageViolations.ps1

The private helper of `Test-DrsRegistry` that finds rule codes and rule headings breaking the rule-code language.

## help

### synopsis

Lists every rule code and rule heading that breaks the rule-code language.

### description

A rule code is a path of upper-case segments after `ADR`, its second segment the domain's one-segment code, and a rule is named by one
segment below its record, never numbered ([drs-code-language](../../../../drs/repository/drs-code-language.md)). This collects a finding for
a domain code of more than one segment, a code outside the segment grammar, a code that does not start with its domain's segment, a rule
heading that is not its record's code plus one segment, and a rule named like a record. The numbered rule headings of one record file are
one finding with their count. Rule headings inside a code fence are skipped, and a rule set with no file, or several, is a finding of
Test-DrsRegistry and is skipped here.

Private helper for Test-DrsRegistry; not exported.

### parameter `Drs`

The DRS registry (Get-Config -Config drs).

### parameter `Index`

The docs/drs/ file index (Get-DrsFileIndex).

### outputs

`[string[]]` One finding per code, domain, rule heading, or record file with numbered rule headings, each ending with the rule it breaks.

## Domain codes

A domain code of several segments is one finding, and its records are held to its first segment. A kind that one domain owns has no domain
code.
