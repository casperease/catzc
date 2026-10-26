# pwsh/Base.Vendor/types/VendorConfig.cs

The typed record for `vendor.yml`, the vendor registry
([ADR-PWSH-VENDOR](../../../../drs/automation/pwsh/vendor-toolset-dependencies.md)). It is registered in
`Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config vendor` returns it. Its properties mirror the YAML keys exactly, including
the file's own `sourceUrl` spelling
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record checks the file and gathers every violation into one `ArgumentException`, so a typo fails at load rather than at
download:

- only the known keys, `source` and `sourceUrl`, are allowed;
- `source` is required and must not be empty;
- `sourceUrl`, when present, must be an absolute URI.

## Properties

- **`source`** — the PSResourceRepository to download from and validate against.
- **`sourceUrl`** — the url of a private feed, registered under the `source` name on first use; null for a built-in repository.
