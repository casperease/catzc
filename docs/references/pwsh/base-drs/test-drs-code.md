# pwsh/Base.Drs/Test-DrsCode.ps1

Says whether a code keeps the rule-code language of `drs-checks.yml`; the query form of Assert-DrsCode.

## help

### synopsis

Returns whether a DRS code keeps the rule-code language.

### description

Reads the code language of `drs-checks.yml` and returns `$true` when it finds no violation for the code. The throwing form is
Assert-DrsCode.

### parameter `Code`

The code to check; an empty code is checked, never refused by binding.

### parameter `Rule`

The code must name a rule, not only a record or a domain.

### outputs

`[bool]`.
