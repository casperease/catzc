# pwsh/Base.Contracts/types/ContractDirection.cs

The direction of a contract asset
([ADR-REPO-CONTRACT-BINDINGINTERFACE](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-bindinginterface),
[ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)).

## Values

- **DependedOn** is what an outside platform expects of our files and calls.
- **Provided** is what an outside consumer may rely on.

By convention the `catzc` root is provided and every other root is a vendor's, so depended-on. A per-version `contract.yml` can override a
single asset.
