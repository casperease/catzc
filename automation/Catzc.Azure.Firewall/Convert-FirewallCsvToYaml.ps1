<#
.SYNOPSIS
    Renders an Azure Firewall rule-export CSV (application or network) as YAML.
.DESCRIPTION
    Reads the CSV and writes each row as a YAML mapping, splitting the multi-value fields into arrays (forced to a...
    [comment:1](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md#comment1)
.PARAMETER CsvPath
    Path to the source CSV (Path set).
.PARAMETER YamlPath
    Output YAML path (Path set).
.PARAMETER SourceName
    The filename of the source, recorded in the header comment. Defaults to the CSV's own filename.
.PARAMETER GeneratedAt
    CSV generation time in UTC, recorded in the header comment. When omitted, that line is dropped.
.PARAMETER InputObject
    A Get-FirewallCsv result (Type/Path/Generated/Blob/Modified), accepted from the pipeline (Object set).
.PARAMETER OutputFolder
    Destination directory in Object mode; the file is named <original-name>.yaml.
    [comment:2](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md#comment2)
.PARAMETER MultiValueFields
    Fields split into YAML arrays on -SplitPattern.
.PARAMETER SplitPattern
    Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.
.EXAMPLE
    Convert-FirewallCsvToYaml -CsvPath .\application.csv -YamlPath .\out\application.yaml
.EXAMPLE
    Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
        Convert-FirewallCsvToYaml -OutputFolder .\out\yaml
#>
function Convert-FirewallCsvToYaml {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = 'In Object mode -SourceName derives from the piped input, bound after defaults are evaluated (ADR-PWSH-PARAM#4)')]
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$CsvPath,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string]$YamlPath,

        # Source filename recorded in the header comment. Defaults to the CSV's own filename.
        [Parameter(ParameterSetName = 'Path')]
        [string]$SourceName,

        # CSV generation time in UTC, recorded in the header comment. Optional.
        [Parameter(ParameterSetName = 'Path')]
        [Nullable[datetime]]$GeneratedAt,

        # A Get-FirewallCsv result object (Type/Path/Generated/Blob/Modified). Pipeline-friendly.
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Object')]
        [psobject]$InputObject,

        # Where the .yaml goes in Object mode. Output file is <original-name>.yaml.
        [Parameter(ParameterSetName = 'Object')]
        [string]$OutputFolder = (Join-Path (Get-OutputRoot) 'yaml'),

        [Parameter()]
        [string[]]$MultiValueFields = @(
            'SourceAddresses',
            'Protocols',
            'DestinationAddresses',
            'SourceIpGroups',
            'DestinationIpGroups',
            'DestinationPorts',
            'DestinationFqdns',
            'DestinationFqdnTag',
            'WebCategories'
        ),

        [Parameter()]
        [string]$SplitPattern = '\s*[,;]\s*'
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Object') {
            $CsvPath = $InputObject.Path
            $SourceName = Split-Path -Path $InputObject.Blob -Leaf
            $GeneratedAt = $InputObject.Generated
            $yamlName = [System.IO.Path]::GetFileNameWithoutExtension($InputObject.Path) + '.yaml'
            $YamlPath = Join-Path $OutputFolder $yamlName
        }

        # A body fill-in on purpose: in Object mode $CsvPath comes from pipeline input, bound after defaults are...
        # [ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)
        # [comment:3](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md#comment3)
        if (-not $SourceName) {
            $SourceName = Split-Path -Path $CsvPath -Leaf
        }

        # In Object mode CsvPath comes from the piped object (the Path set is ValidateScript'd); assert it exists...
        # [comment:4](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md#comment4)
        Assert-PathExist $CsvPath -PathType Leaf

        $rules = Import-Csv -Path $CsvPath | ForEach-Object {
            $row = [ordered]@{}
            foreach ($property in $_.PSObject.Properties) {
                $value = $property.Value

                if ($property.Name -in $MultiValueFields) {
                    if ([string]::IsNullOrWhiteSpace($value)) {
                        $row[$property.Name] = @()
                    }
                    else {
                        # Force array even when split yields one element
                        $row[$property.Name] = @($value -split $SplitPattern | Where-Object { $_ -ne '' })
                    }
                }
                else {
                    $row[$property.Name] = $value
                }
            }
            $row
        }

        $yaml = ConvertTo-Yaml -Data $rules

        # Provenance as a YAML comment header — visible to readers, ignored by parsers, so the parsed shape stays a...
        # [comment:5](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md#comment5)
        $header = [System.Collections.Generic.List[string]]::new()
        $header.Add("# Source: $SourceName")
        if ($null -ne $GeneratedAt) {
            $generatedUtc = ([datetime]$GeneratedAt).ToUniversalTime().ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)
            $header.Add("# CSV generated: $generatedUtc UTC")
        }
        $header.Add("# Converted to YAML: $([datetime]::UtcNow.ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)) UTC")
        $yaml = ($header -join "`n") + "`n`n" + $yaml

        $outputDir = Split-Path -Path $YamlPath -Parent
        if ($outputDir -and -not (Test-Path -Path $outputDir)) {
            New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
        }

        Set-Content -Path $YamlPath -Value $yaml -Encoding UTF8
        Assert-PathExist $YamlPath -PathType Leaf
        Write-Message "wrote $YamlPath"
    }
}
