# pwsh/Base.Contracts/tests/types/ContractSchema.Tests.ps1

Tests `ContractSchema`, which validates a parsed value against a bounded JSON Schema subset
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): `type`,
`required`, `properties`, `additionalProperties` (a boolean), `enum`, `items` (one schema), `const`, `pattern`, root `definitions` and a
local `$ref`. The annotations `$schema`, `$id`, `$comment`, `title`, `description` and `examples` are ignored. Every other keyword, and
every unsupported form of a supported one, is a finding. Each keyword has a passing and a failing value; schemas and values are JSON
literals.
