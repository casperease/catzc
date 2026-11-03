function Test-BclReferences {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $ModulesRoot,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $config = Get-Config -Config bcl
    $hostUsing = [regex]::new('^\s*using\s+(static\s+)?System\.Management\.Automation\b', 'Multiline')
    $issues = [System.Collections.Generic.List[string]]::new()
    $bound = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $scanned = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $sources = @(foreach ($moduleFolder in @(Get-WorkingRootModuleFolder -ModulesRoot $ModulesRoot)) {
            $typesFolder = Join-Path $moduleFolder 'types'
            if (Test-Path -LiteralPath $typesFolder -PathType Container) {
                Get-ChildPath $typesFolder -Depth 1 -File -Filter '*.cs' -PruneVendor $true
            }
        })

    $repositoryRoot = Get-RepositoryRoot
    foreach ($source in $sources) {
        $module = [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($source)))
        $file = "$module/types/$([System.IO.Path]::GetFileName($source))"
        [void]$scanned.Add($file)
        if (-not $hostUsing.IsMatch([System.IO.File]::ReadAllText($source))) {
            continue
        }
        [void]$bound.Add($file)
        if ($null -eq $config.HostBindingOf($file)) {
            $sourceFolder = [System.IO.Path]::GetRelativePath($repositoryRoot, [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($source)))).Replace('\', '/')
            $issues.Add("$sourceFolder/${file}: uses System.Management.Automation without a host binding in bcl.yml — move the host work to its pwsh caller, or add the row with its reason")
        }
    }

    foreach ($binding in $config.host_bindings) {
        if ($scanned.Contains($binding.file) -and -not $bound.Contains($binding.file)) {
            $issues.Add("bcl.yml $($binding.file): binds a type source that does not use System.Management.Automation — remove the row")
        }
    }

    Write-QualityGateReport -Subject 'bcl-references' -Title 'Test-BclReferences' -Issues $issues `
        -Facts ([ordered]@{ Sources = $sources.Count; HostBound = $bound.Count; Rows = $config.host_bindings.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
