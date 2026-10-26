# pwsh/Base.QualityGates/configs/parameter-consistency.yml

The exemptions of Test-ParameterConsistency: the parameter names that may carry more than one type across the public functions.

## Keys

`exempt` maps a parameter name, written without the dash, to the reason the same name means different things in different functions, each
with its own type. A name that means the same thing everywhere takes one type instead
([ADR-PWSH-PARAM](../../../../drs/automation/pwsh/parameter-design.md)). Omitted means none exempt.

The default is declared once on `Catzc.Base.QualityGates.ParameterConsistencyConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
Test-ParameterConsistency reports an entry whose name no longer conflicts, so the list only shrinks to what is real.
