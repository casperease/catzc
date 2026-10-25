# pwsh/Catzc.Base.Vendor/configs/vendor.yml

The vendor registry: the one place that says where vendored PowerShell modules come from
([ADR-PWSH-VENDOR](../../../../drs/automation/pwsh/vendor-toolset-dependencies.md)). `Install-VendorModule` downloads from it, and
`Remove-VendorModules` checks against it that every committed module can be restored before it deletes one.

## Keys

- **`source`** — the name of a registered PSResourceRepository. `PSGallery` is built in and needs no url.
- **`sourceUrl`** — optional, unset by default. Set it to an Artifactory or proxy feed (for example `https://your-feed/v3/index.json`) to
  vendor from a private feed; the feed is registered under the `source` name on first use.

## How it is read

`Get-Config -Config vendor` loads the file into the typed `Catzc.Base.Vendor.VendorConfig` record, which rejects unknown keys at load
([VendorConfig.cs](../types/VendorConfig.cs.md)). Only the module's own functions read it.
