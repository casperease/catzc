# pwsh/Base.Drs/Assert-DrsCode.ps1

Throws when a code breaks the rule-code language of `drs-checks.yml`, naming the violation (ADR-REPO-DRSCODE-PATHOFSEGMENTS).

## help

### synopsis

Throws when a DRS code breaks the rule-code language.

### description

Reads the code language of `drs-checks.yml` and throws its violation for the code, citing ADR-REPO-DRSCODE-PATHOFSEGMENTS. The query form is
Test-DrsCode.

### parameter `Code`

The code to check; an empty code is checked, never refused by binding.

### parameter `Rule`

The code must name a rule, not only a record or a domain.
