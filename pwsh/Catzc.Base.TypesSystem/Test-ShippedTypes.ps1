<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
    name: test-shipped-types
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
    docs: "[Test-ShippedTypes.ps1.md](/docs/references/pwsh/catzc-base-typessystem/Test-ShippedTypes.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

function Test-ShippedTypes {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
