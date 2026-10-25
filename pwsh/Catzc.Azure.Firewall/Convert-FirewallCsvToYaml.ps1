<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md"
  header: "generated"
---
#>

function Convert-FirewallCsvToYaml {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = 'In Object mode -SourceName derives from the piped input, bound after defaults are evaluated (ADR-PWSH-PARAM-RESOLUTIONORDER)')]
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

        # Filled in the body, not as a default: a piped path binds after the defaults are evaluated, so a default would never see it.
        if (-not $SourceName) {
            $SourceName = Split-Path -Path $CsvPath -Leaf
        }

        # Asserted in both modes, so a wrong path to the source CSV fails here by name and never as a raw CSV read error.
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

        # Provenance as YAML comments, so a reader sees it and a parser never does: the parsed shape stays a plain list of rules.
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
