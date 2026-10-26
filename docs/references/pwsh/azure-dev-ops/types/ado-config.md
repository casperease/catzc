# pwsh/Azure.DevOps/types/AdoConfig.cs

The typed record for `ado.yml`, the single source of truth for which Azure DevOps organization and Entra tenant is the correct one to be
connected to. It is registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config ado` returns it. Its properties mirror the
YAML keys, which are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record checks the file and gathers every violation into one `ArgumentException`:

- `organization` is required and must be an `https://` Azure DevOps organization URL;
- `project` is required and not empty;
- `tenant` is required and must be a GUID, the Entra tenant that backs the organization, which every auth path must be proven to target
  before `Get-AdoAuthorizationHeader` returns a header;
- `yaml_inventory_depth` is optional and a whole number of 1 or more; it defaults to 6;
- no other key is allowed, so a misspelled or non-snake_case key fails at load.
