<#
---
catzc:
  immutable:
    with_body_sha: "695fc905fa8c"
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Test-Diagrams.Tests.ps1
    docs: "[Test-Diagrams.ps1.md](../../docs/references/pwsh/catzc-base-slides/Test-Diagrams.ps1.md)"
---
#>

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

    # A declared diagram is a <name>.drawio.yml under docs/**/.assets/, tracked or not, named by its stem .assets/<name>; a new one is
    # checked once its first put has run.
    $candidates = @(Get-GitTrackedPath '.') + @(Get-GitChangedPath 'docs')
    $found = @($candidates | Where-Object { $_ -cmatch '^docs/(.+/)?\.assets/[^/]+\.drawio\.(png|yml)$' } | ForEach-Object { $_ -creplace '\.drawio\.(png|yml)$', '' } |
            Select-Object -Unique | Where-Object { Test-Path -LiteralPath (Join-Path $root "$_.drawio.yml") -PathType Leaf })
    # A legend diagram has no yml: the kit's drawio.yml names its stem under roles, and its png is checked against the painted glyph library.
    $kitConfigPath = Join-Path $root "$Kit/configs/drawio.yml"
    $kitConfig = if ([System.IO.File]::Exists($kitConfigPath)) {
        ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($kitConfigPath)) -Ordered
    }
    $legends = @(if ($kitConfig -and $kitConfig.Contains('roles') -and $kitConfig['roles']) {
            $kitConfig['roles'].Keys | Where-Object { $kitConfig['roles'][$_] -ceq 'legend' -and (Test-Path -LiteralPath (Join-Path $root "$_.drawio.png") -PathType Leaf) }
        })
    $found = @($found) + @($legends | Where-Object { $found -cnotcontains $_ })
    $folders = @(if ($Path) {
            foreach ($folderPath in $Path) {
                $relative = ([System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath((Join-Path $root $folderPath))) -replace '\\', '/') -creplace '\.drawio\.(png|yml)$', ''
                Assert-True ($found -ccontains $relative) -ErrorText "Test-Diagrams: '$relative' is not a declared diagram (a <name>.drawio.yml under docs/**/.assets/, or a legend the kit's drawio.yml names)."
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
        $declared = @($folders | Where-Object { $legends -cnotcontains $_ })
        if ($declared.Count -gt 0) {
            $null = Write-DiagramMinimapData -Folder $declared -RepositoryRoot $root
        }
        $quoted = ($folders | ForEach-Object { "`"$_`"" }) -join ' '
        $result = Invoke-Executable "`"$($tool.Path)`" run --project `"$(Join-Path $root $Kit)`" python `"$declaration`" check $quoted" -WorkingDirectory $root -PassThru -NoAssert -Silent
        Assert-True ($result.ExitCode -eq 0) -ErrorText "Test-Diagrams: the drift check failed (exit $($result.ExitCode)): $(@($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ')"
        foreach ($line in @($result.Output -split "`r?`n" | Where-Object { $_.StartsWith('{') })) {
            $row = $line | ConvertFrom-Json
            if ($row.PSObject.Properties['error']) {
                $issues.Add("$($row.diagram): $($row.error)")
            }
            elseif ($row.PSObject.Properties['conflict'] -and @($row.conflict).Count -gt 0) {
                $issues.Add("$($row.diagram): the yml and the png both moved from HEAD and disagree in $(@($row.conflict) -join ', '); put or get it by name to pick the side that wins")
            }
            elseif (@($row.drift).Count -gt 0) {
                $issues.Add("$($row.diagram): the png differs from put of its yml in $(@($row.drift) -join ', '); put the yml, or get after a draw.io edit")
            }
            elseif (@($row.stale).Count -gt 0) {
                $stale.Add($row.diagram)
            }
        }
    }

    $facts = [ordered]@{
        DiagramCount      = $folders.Count
        StaleMinimapCount = $stale.Count
        StaleDiagrams     = $stale.ToArray()
    }
    if ($stale.Count -gt 0) {
        Write-Message "Test-Diagrams: $($stale.Count) diagram(s) carry minimaps or a legend a registry or kit change left stale; rebuild them with Build-Diagrams -Stale: $($stale -join ', ')"
    }
    Write-QualityGateReport -Subject diagrams -Title Test-Diagrams -Issues $issues.ToArray() -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
}
