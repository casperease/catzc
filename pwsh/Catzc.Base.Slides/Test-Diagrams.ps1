function Test-Diagrams {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Path,

        [string] $Kit = (Get-Config -Config slides).drawio_kit,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $declaration = Join-Path $root "$Kit/declaration.py"
    Assert-PathExist $declaration -PathType Leaf -ErrorText "Test-Diagrams: the draw.io kit '$Kit' has no declaration.py; slides.yml drawio_kit names the kit."

    # A declared diagram is a folder holding a tracked diagram.drawio.png beside its diagram.drawio.yml.
    $tracked = @(Get-GitTrackedPath '.')
    $found = @($tracked | Where-Object { $_ -cmatch '^docs/(.+/)?\.assets/[^/]+/diagram\.drawio\.png$' } | ForEach-Object { $_.Substring(0, $_.LastIndexOf('/')) } |
            Where-Object { Test-Path -LiteralPath (Join-Path $root "$_/diagram.drawio.yml") -PathType Leaf })
    $folders = @(if ($Path) {
            foreach ($folderPath in $Path) {
                $relative = ([System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath((Join-Path $root $folderPath))) -replace '\\', '/').TrimEnd('/')
                Assert-True ($found -ccontains $relative) -ErrorText "Test-Diagrams: '$relative' is not a declared diagram folder (a tracked diagram.drawio.png beside its diagram.drawio.yml)."
                $relative
            }
        }
        else {
            $found
        })

    $issues = [System.Collections.Generic.List[string]]::new()
    $stale = [System.Collections.Generic.List[string]]::new()
    if ($folders.Count -gt 0) {
        $tool = Resolve-ToolExecutable -Tool uv
        Assert-True $tool.Found -ErrorText 'Test-Diagrams: uv is not installed (no managed uv found). Run Install-Uv.'
        $quoted = ($folders | ForEach-Object { "`"$_`"" }) -join ' '
        $result = Invoke-Executable "`"$($tool.Path)`" run --project `"$(Join-Path $root $Kit)`" python `"$declaration`" check $quoted" -WorkingDirectory $root -PassThru -NoAssert -Silent
        Assert-True ($result.ExitCode -eq 0) -ErrorText "Test-Diagrams: the drift check failed (exit $($result.ExitCode)): $(@($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ')"
        foreach ($line in @($result.Output -split "`r?`n" | Where-Object { $_.StartsWith('{') })) {
            $row = $line | ConvertFrom-Json
            if ($row.PSObject.Properties['error']) {
                $issues.Add("$($row.folder): $($row.error)")
            }
            elseif ($row.PSObject.Properties['conflict'] -and @($row.conflict).Count -gt 0) {
                $issues.Add("$($row.folder): the yml and the png both moved from HEAD and disagree in $(@($row.conflict) -join ', '); put or get it by name to pick the side that wins")
            }
            elseif (@($row.drift).Count -gt 0) {
                $issues.Add("$($row.folder): the png differs from put of its yml in $(@($row.drift) -join ', '); put the yml, or get after a draw.io edit")
            }
            elseif (@($row.stale).Count -gt 0) {
                $stale.Add($row.folder)
            }
        }
    }

    $facts = [ordered]@{
        FolderCount       = $folders.Count
        StaleMinimapCount = $stale.Count
        StaleFolders      = $stale.ToArray()
    }
    if ($stale.Count -gt 0) {
        Write-Message "Test-Diagrams: $($stale.Count) diagram(s) carry minimaps a registry change left stale; put them again: $($stale -join ', ')"
    }
    Write-QualityGateReport -Subject diagrams -Title Test-Diagrams -Issues $issues.ToArray() -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
}
