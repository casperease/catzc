<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/Convert-FirewallCsvToYaml.ps1
    kind: function
    module: Catzc.Azure.Firewall
    visibility: public
    adrs:
      - ADR-PWSH-PARAM#4
---
#>

<#
.SYNOPSIS
    Renders an Azure Firewall rule-export CSV (application or network) as YAML.
.DESCRIPTION
    A multi-value field is always a list, even for one value or none, so consumers never branch on scalar versus list.
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
    Where the .yaml goes in Object mode; the file is named <original-name>.yaml.
    Unset, the file lands under the output root, which is out locally and the staging directory in a pipeline.
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

        [Parameter(ParameterSetName = 'Path')]
        [string]$SourceName,

        [Parameter(ParameterSetName = 'Path')]
        [Nullable[datetime]]$GeneratedAt,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Object')]
        [psobject]$InputObject,

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

        # Filled in the body, not as a default: in Object mode the value arrives from the pipeline after defaults run.
        # [comment:3](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md#comment3)
        if (-not $SourceName) {
            $SourceName = Split-Path -Path $CsvPath -Leaf
        }

        # The piped Object path is not validated by the parameter, so a wrong path fails here, named, not in Import-Csv.
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

        # A comment header, not a data key, so parsers ignore it and the parsed shape stays a plain list of rules.
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
