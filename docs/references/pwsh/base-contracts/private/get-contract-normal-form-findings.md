# pwsh/Base.Contracts/private/Get-ContractNormalFormFindings.ps1

The normal-form check of a command contract. It reports every name in the contract that is not in the repository normal form, so each
language's checker can render its own name from it.

## help

### synopsis

Checks that every name a command contract states is in the repository normal form and returns the findings.

### description

A command contract names its command, module, parameters, parameter sets and types in the repository normal form, never in one language's
idiom ([ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage)),
so each language's checker renders its own name from it. Every name of the contract that is not in the normal form's case is one finding.

### parameter `Contract`

The parsed command contract whose names are checked.

### parameter `NormalForm`

The naming case of the normal form; by default `naming_normal_form` of the languages config.

### outputs

`[string[]]` One finding per name not in the normal form; nothing when every name is.
