# pwsh/Base.Contracts/types/ContractFragment.cs

The fragment check of a contract asset
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): the real file must
contain the fragment. Each method returns its findings, one precise message per mismatch, and an empty list when the real file contains the
fragment.

## MatchData

For JSON and YAML, after both sides are parsed (`ContractValue` is the value model). It is a key subset:

- an object in the fragment requires an object in the target holding every one of its keys, each value matched by these same rules; the
  target may hold more keys;
- an array in the fragment requires an array in the target in which every fragment element is matched by at least one target element, in any
  order; two fragment elements may be matched by the same target element, and the target may hold more elements;
- a null (an empty YAML value, a JSON null) pins only that its key exists, whatever the target's value;
- any other scalar requires an equal target value (`ContractValue.Equal`: numbers by value, strings ordinally).

A finding names the location in JSONPath form (`ContractValue.MemberPath`).

## MatchLines

For any other text: every non-blank fragment line must appear in the target, in the same order, not necessarily adjacent. Trailing
whitespace is trimmed from every line on both sides, and nothing else, so leading indentation counts. Lines are matched greedily: each
fragment line takes the first equal target line after the one the previous fragment line took. A line the target holds only at or before
that point is reported as out of order.
