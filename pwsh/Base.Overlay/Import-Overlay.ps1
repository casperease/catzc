function Import-Overlay {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $entries = @(Get-Overlay)
    if ($entries.Count -eq 0) {
        return
    }
    Assert-Overlay -Entry $entries

    foreach ($override in @($entries | Where-Object { $_.Kind -eq 'FunctionOverride' })) {
        $module = Get-Module $override.Module
        . $module { param($overrideFile) . $overrideFile } $override.File
        if ($override.Visibility -eq 'public') {
            Set-Item -Path "function:global:$($override.Target)" -Value $module.ExportedFunctions[$override.Target].ScriptBlock
        }
        Write-Verbose "Overlay: $($override.Module)/$($override.Target) replaced by $($override.RelativePath)"
        $override
    }
}
