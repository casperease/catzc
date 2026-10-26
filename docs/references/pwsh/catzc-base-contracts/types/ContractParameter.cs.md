# pwsh/Base.Contracts/types/ContractParameter.cs

One parameter of a command contract: its name, type, sets and default, parsed from the contract language's one-line spec.

## Spec

A spec reads `type [ "!" ] [ "=" literal ] [ "pipeline" ]`, where `type = base [ "[]" ]`
([ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage)). The
base types are `string`, `int`, `bool` and `switch`, or a contract type; `[]` makes a list.
