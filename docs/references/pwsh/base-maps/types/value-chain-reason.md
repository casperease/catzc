# pwsh/Base.Maps/types/ValueChainReason.cs

Why a value-chain highlight lights a cell for one record: the requested citation, the record code, its domain and that domain's row of the
value-chain stack ([ADR-REPO-VALUECHAIN-STACK](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-stack)).

## Concerns

It also holds the value-chain concern of the lit cell, and the record's value-chain concerns with the domain's default
([ADR-REPO-VALUECHAIN-CONCERN][r1]). `Override` is true when the record declares its own concerns instead of the default.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

[r1]: ../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-concern
