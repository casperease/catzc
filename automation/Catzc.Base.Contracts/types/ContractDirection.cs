// The direction of a contract asset: DependedOn is what an outside platform expects of our files and calls; Provided is what an outside...
// [ADR-REPO-CONTRACT#1](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract1),
// [ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)
// [comment:1](/docs/references/automation/catzc-base-contracts/types/ContractDirection.cs.md#comment1)

namespace Catzc.Base.Contracts;

public enum ContractDirection
{
    DependedOn,
    Provided,
}
