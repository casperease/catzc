# pwsh/Tooling.Inspiration/types/InspirationEntry.cs

One inspiration of `configs/inspiration.yml`, as stored: an id, the root it lives at, what it is, and the folders inside it worth reading.
It mirrors the YAML mapping with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing one maps and validates the entry, and every violation is reported in one throw, prefixed with the entry's position, so one load
names every broken entry at once. The load-time rules:

- the mapping's keys are `id`, `root`, `description` and `paths`;
- `id` is kebab-case, lowercase words joined by `-`;
- `root` is in communication form, repository-relative or `{workspace}`-anchored (`InspirationRoot.Violations`);
- `description` is non-blank;
- `paths`, when present, lists relative paths inside the root, with no anchor.
