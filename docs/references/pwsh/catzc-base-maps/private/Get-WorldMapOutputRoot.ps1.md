# pwsh/Base.Maps/private/Get-WorldMapOutputRoot.ps1

The helper that names the output folder the world-map PDFs are written to, and the seam a test mocks.

## help

### synopsis

Returns the folder the world-map PDFs are written to.

### description

The world map writes recurring files, so they land in their own folder under the output root
([ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-subdirectoryperproducer)):
Get-OutputRoot joined with the output_folder of configs/maps.yml (read through Get-Config, typed as Catzc.Base.Maps.MapsConfig; default
world-map). It is also the seam a test mocks to a folder of its own
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)).

### parameter `EnsureExists`

Create the folder (and the output root) when it does not exist.

### outputs

`[string]` the absolute folder path.

### example 1

```powershell
Get-WorldMapOutputRoot                    # -> <repository>/out/world-map
```

### example 2

```powershell
Get-WorldMapOutputRoot -EnsureExists
```
