<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
    name: test-shipped-types
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
---
#>

function Test-ShippedTypes {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $typeCount = 0
    $modulesRoot = Get-CatzcModulesRoot
    foreach ($moduleDirectory in ([System.IO.Directory]::EnumerateDirectories($modulesRoot) | Sort-Object)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDirectory)
        $typesDirectory = Join-Path $moduleDirectory 'types'
        if ($moduleName -match '^\.' -or -not [System.IO.Directory]::Exists($typesDirectory)) {
            continue
        }
        foreach ($file in ([System.IO.Directory]::EnumerateFiles($typesDirectory, '*.cs') | Sort-Object)) {
            $typeCount++
            $fullName = "$moduleName.$([System.IO.Path]::GetFileNameWithoutExtension($file))"
            $relative = "$moduleName/types/$([System.IO.Path]::GetFileName($file))"
            $type = ([System.Management.Automation.PSTypeName] $fullName).Type
            if (-not $type) {
                $issues.Add("${relative}: type '$fullName' does not resolve after import")
                continue
            }
            if (-not (Test-ConsoleReadyType -Type $type)) {
                $issues.Add("${relative}: '$fullName' renders as its full name in pwsh — add ``public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);``")
            }
        }
    }

    Write-QualityGateReport -Subject 'shipped-types' -Title 'Test-ShippedTypes' -Issues $issues `
        -Facts ([ordered]@{ Types = $typeCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
