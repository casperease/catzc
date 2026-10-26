# pwsh/Base.Contracts/types/ContractCommand.cs

The typed record for a command contract, `<name>.command.yml`, and for the signature read from a command's file, so the two compare as one
type ([ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage)).
The asset names the command, so the contract holds no placement facts
([ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-noplacementfacts)).

## Keys

- **`description`** — what the command guarantees, one plain sentence: its help synopsis stripped of links, codes and markup. A contract
  requires it; a signature read from a command file carries none.
- **`parameters`** — the parameters in the order the contract states them.
- **`output`** — the output type, with `[]` for a list; `void` when omitted.
- **`default_set`** — the parameter set a call that fits several resolves to; null when the command names none.

## Behaviour

- `Compare` returns the findings of a contract against the signature read from the command's file: every disagreement, each as one message
  ([ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-checkerperlanguage)).
  A computed default on the command's side is not compared.
- `ToAssetText` writes the asset text, the inverse of the grammar. Each parameter name, set name and catzc type name passes through
  `rename`; the base types, flags, defaults and order stay as read. Void output and no default set are left out, as the defaults are.
