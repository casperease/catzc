<#
.SYNOPSIS
    Quality gate: every shipped C# type resolves in the session as <module>.<basename>.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the shipped
    C# types: each <module>/types/<Name>.cs under the loaded code root (Get-CatzcModulesRoot — the source tree or a built
    package) declares the type <module>.<Name>, so after import that full name must resolve. A file that compiles to a
    differently named type, or a module whose types never loaded, is an issue. The formatting of the files
    (file-scoped namespaces) is Test-Formatting's.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-shipped-types/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Types }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ShippedTypes
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
            if (-not ([System.Management.Automation.PSTypeName] $fullName).Type) {
                $issues.Add("$moduleName/types/$([System.IO.Path]::GetFileName($file)): type '$fullName' does not resolve after import")
            }
        }
    }

    Write-QualityGateReport -Subject 'shipped-types' -Title 'Test-ShippedTypes' -Issues $issues `
        -Facts ([ordered]@{ Types = $typeCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
