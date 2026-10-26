# pwsh/Base.QualityGates/types/GuidsConfig.cs

The typed record for the managed-GUID registry, `configs/guids.yml`: every GUID literal the repository carries, each a named, described
entry (`guids:`), plus the non-allow list of values that are never a legitimate identity (`denied:`). It is registered in
`Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config guids` returns it. Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record maps and validates the parsed YAML and gathers every violation into one throw:

- the only top-level keys are `denied` (optional) and `guids` (required; an empty map or no value is allowed), so a stray key cannot quietly
  linger;
- each section is a map of name to `ManagedGuidEntry`, each entry well-formed;
- guid values are unique across all entries: a GUID has exactly one name, and a denied value can never also be registered.

That every registered GUID appears in tracked text, and that no unregistered or denied one does, is the managed-guid integrity test's job,
not load's.
