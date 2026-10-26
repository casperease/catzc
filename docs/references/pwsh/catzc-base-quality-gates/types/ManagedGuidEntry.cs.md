# pwsh/Base.QualityGates/types/ManagedGuidEntry.cs

One named entry of `configs/guids.yml`: under `guids:` a GUID the repository is allowed to carry, or under `denied:` a value that is never a
legitimate identity. Its properties mirror the YAML keys, snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing one maps and validates the entry and gathers every violation into one throw:

- the entry name, its map key, is snake_case;
- the entry is a map carrying only the section's allowed keys: `guid`, `description` and, under `guids:` only, `sentence` (a denied value is
  never minted for use);
- `guid` is required and canonical, the lowercase hyphenated 8-4-4-4-12 form;
- `description` is required and non-empty;
- `sentence` is optional but non-empty when present; it is the `ConvertTo-Guid` source of a minted placeholder.

Value uniqueness spans both sections, so `GuidsConfig` checks it.
