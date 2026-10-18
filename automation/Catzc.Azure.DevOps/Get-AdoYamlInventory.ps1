<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps/Get-AdoYamlInventory.ps1
    name: get-ado-yaml-inventory
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-devops/Get-AdoYamlInventory.ps1.md
---
#>

function Get-AdoYamlInventory {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Path,

        [string[]] $Exclude = @('.git', 'node_modules', '.terraform'),

        [string] $Project,

        [string] $Organization
    )

    $scanParams = @{ Exclude = $Exclude }
    if ($Path) {
        $scanParams.Path = $Path
    }

    $files = Get-AdoYamlFiles @scanParams

    $defParams = @{}
    if ($Project) {
        $defParams.Project = $Project
    }
    if ($Organization) {
        $defParams.Organization = $Organization
    }

    $definitions = Get-AdoPipelineDefinitions @defParams

    $registeredByPath = @{}
    foreach ($definition in $definitions) {
        if ($definition.YamlPath) {
            $registeredByPath[$definition.YamlPath] = $definition
        }
    }

    $pathPrefix = ''
    foreach ($file in $files) {
        foreach ($definition in $definitions) {
            if ($definition.YamlPath -and $definition.YamlPath.EndsWith("/$($file.RelativePath)")) {
                $pathPrefix = $definition.YamlPath.Substring(0, $definition.YamlPath.Length - $file.RelativePath.Length)
                break
            }
        }
        if ($pathPrefix) {
            break
        }
    }

    foreach ($file in $files) {
        $registered = $registeredByPath[$pathPrefix + $file.RelativePath]
        $isRegistered = $null -ne $registered

        $classification = $file.Classification
        if ($classification -eq 'Unknown' -and $isRegistered) {
            $classification = 'Pipeline'
        }

        [Catzc.Azure.DevOps.YamlInventoryRecord]::new(
            $file.Root, $file.Path, $file.RelativePath, $file.RelativeDirectory,
            $classification, $file.TemplateType, $isRegistered,
            $registered.Name, $registered.Id, $registered.Folder,
            $file.TopLevelKeys, $file.ParseError)
    }
}
