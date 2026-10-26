<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-types-system/Test-ShippedTypes.ps1.md"
  header: "generated"
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
    $walk = Get-Config -Config folder-walk
    # A type's namespace is its module's full name, the folder joined to the track's namespace (DDR-TRACK-MODULENAMESPACE).
    $track = Get-Track -Name ([System.IO.Path]::GetFileName($modulesRoot.TrimEnd('\', '/')))
    foreach ($moduleDirectory in @(Get-ChildPath $modulesRoot -Directory -Depth 1)) {
        $folderName = [System.IO.Path]::GetFileName($moduleDirectory)
        $typesDirectory = Join-Path $moduleDirectory 'types'
        if ($folderName -match '^\.' -or -not [System.IO.Directory]::Exists($typesDirectory)) {
            continue
        }
        $moduleName = $track.FullNameOf($folderName)
        foreach ($file in [Catzc.Base.Folders.PathSet]::new($walk).AddPattern($typesDirectory, '*.cs', 1).ToArray()) {
            $typeCount++
            $fullName = "$moduleName.$([System.IO.Path]::GetFileNameWithoutExtension($file))"
            $relative = "$folderName/types/$([System.IO.Path]::GetFileName($file))"
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
