function Get-MarkerBlastRadius {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Files')]
        [string[]] $ChangedFile,

        [Parameter(Mandatory, ParameterSetName = 'Ref')]
        [string] $Ref
    )

    if ($PSCmdlet.ParameterSetName -eq 'Ref') {
        $diff = Invoke-Executable "git diff --name-only `"$Ref`"" -PassThru -Silent
        $ChangedFile = @($diff.Output -split "`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    }
    $files = @($ChangedFile | ForEach-Object { $_.Trim().Replace('\', '/') })
    if ($files.Count -eq 0) {
        return
    }

    # Declared sets first, in registry order, then the derived module sets: one answer per set either way.
    foreach ($set in @(Get-GlobSet) + @(Get-ModuleGlobSet)) {
        foreach ($file in $files) {
            if ($set.Matches($file)) {
                [pscustomobject]@{
                    Name          = $set.Name
                    Layer         = $set.Layer
                    Pipeline      = $set.Pipeline
                    VerifyModules = @($set.VerifyModules)
                    VerifyLevel   = $set.VerifyLevel
                }
                break
            }
        }
    }
}
