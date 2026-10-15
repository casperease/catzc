<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/private/Resolve-AdoYamlClassification.ps1
    kind: private-function
    module: Catzc.Azure.DevOps
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Classifies a parsed YAML document as Pipeline, Template, or Unknown.
.DESCRIPTION
    TemplateType is null for a non-template, so a Pipeline or Unknown result never carries a sub-kind.
.PARAMETER Yaml
    A null from a file that failed to parse is accepted and classifies as Unknown.
.EXAMPLE
    $yaml = Get-Content 'ci.yml' -Raw | ConvertFrom-Yaml -Ordered
    $result = Resolve-AdoYamlClassification -Yaml $yaml
    $result.Classification  # 'Pipeline'
    $result.TemplateType    # $null
#>
function Resolve-AdoYamlClassification {
    [OutputType([PSCustomObject])]
    param(
        [AllowNull()]
        [object] $Yaml
    )

    $unknown = [Catzc.Azure.DevOps.YamlClassificationResult]::new('Unknown', $null)

    if ($null -eq $Yaml) {
        return $unknown
    }

    if ($Yaml -isnot [System.Collections.IDictionary]) {
        return $unknown
    }

    $keys = @($Yaml.Keys | ForEach-Object { $_.ToLower() })

    # Strong pipeline signals — any one is conclusive
    $strongPipelineKeys = @('trigger', 'pr', 'schedules', 'extends', 'lockbehavior')
    $hasStrongPipeline = $keys | Where-Object { $_ -in $strongPipelineKeys } | Select-Object -First 1

    if ($hasStrongPipeline) {
        return [Catzc.Azure.DevOps.YamlClassificationResult]::new('Pipeline', $null)
    }

    # Template detection: parameters + body key
    $templateBodyMap = @{
        'stages'    = 'Stages'
        'jobs'      = 'Jobs'
        'steps'     = 'Steps'
        'variables' = 'Variables'
    }

    $hasParameters = 'parameters' -in $keys

    if ($hasParameters) {
        $bodyKey = $keys | Where-Object { $templateBodyMap.ContainsKey($_) } | Select-Object -First 1

        if ($bodyKey) {
            $templateType = $templateBodyMap[$bodyKey]
            return [Catzc.Azure.DevOps.YamlClassificationResult]::new('Template', $templateType)
        }
    }

    # Moderate pipeline signals: pool/name/resources + stages/jobs without parameters
    $moderatePipelineKeys = @('pool', 'name', 'resources')
    $bodyKeys = @('stages', 'jobs')
    $hasModerate = $keys | Where-Object { $_ -in $moderatePipelineKeys } | Select-Object -First 1
    $hasBody = $keys | Where-Object { $_ -in $bodyKeys } | Select-Object -First 1

    if ($hasModerate -and $hasBody -and -not $hasParameters) {
        return [Catzc.Azure.DevOps.YamlClassificationResult]::new('Pipeline', $null)
    }

    # Single-key files
    if ($keys.Count -eq 1) {
        $only = $keys[0]

        if ($only -eq 'steps') {
            return [Catzc.Azure.DevOps.YamlClassificationResult]::new('Template', 'Steps')
        }
        if ($only -eq 'variables') {
            return [Catzc.Azure.DevOps.YamlClassificationResult]::new('Template', 'Variables')
        }
    }

    $unknown
}
