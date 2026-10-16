<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Firewall/Convert-FirewallCsvToYaml.ps1
    name: convert-firewall-csv-to-yaml
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Firewall
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md
    test: automation/Catzc.Azure.Firewall/tests/Convert-FirewallCsvToYaml.Tests.ps1
    cites:
      - ADR-PWSH-PARAM#4
  config:
    synopsis: Renders an Azure Firewall rule-export CSV (application or network) as YAML.
    description: |-
      Reads the CSV and writes each row as a YAML mapping, splitting the multi-value fields into arrays
      (forced to a list even for a single value, and to an empty list when blank). All other fields are
      emitted as-is. Field set is schema-agnostic: a name in -MultiValueFields that the CSV doesn't have is
      simply never encountered, so the same defaults serve both the application and network exports.

      The file opens with a comment header (source filename, CSV generation time, conversion time, all UTC).
      Being YAML comments they're ignored by parsers, so the parsed document is still a plain list of rules.

      Two parameter sets:
        Path   : -CsvPath + -YamlPath.
        Object : -InputObject (a Get-FirewallCsv result, pipeline-bindable) + optional -OutputFolder. CsvPath
                 comes from the object and the file is written as <original-name>.yaml.
    parameters:
      CsvPath: Path to the source CSV (Path set).
      YamlPath: Output YAML path (Path set).
      SourceName: The filename of the source, recorded in the header comment. Defaults to the CSV's own filename.
      GeneratedAt: CSV generation time in UTC, recorded in the header comment. When omitted, that line is dropped.
      InputObject: A Get-FirewallCsv result (Type/Path/Generated/Blob/Modified), accepted from the pipeline (Object set).
      OutputFolder: |-
        Where the .yaml goes in Object mode; the file is named <original-name>.yaml.
        Destination directory in Object mode; the file is named <original-name>.yaml. Defaults to the yaml folder
        under the output root (Get-OutputRoot: <repo>/out locally, the artifact staging directory in a pipeline).
      MultiValueFields: Fields split into YAML arrays on -SplitPattern.
      SplitPattern: Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.
    examples:
      - Convert-FirewallCsvToYaml -CsvPath .\application.csv -YamlPath .\out\application.yaml
      - |-
        Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
            Convert-FirewallCsvToYaml -OutputFolder .\out\yaml
---
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

        if (-not $SourceName) {
            $SourceName = Split-Path -Path $CsvPath -Leaf
        }

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
