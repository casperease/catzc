<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-slides/Build-Diagrams.ps1.md"
  header: "generated"
---
#>

function Build-Diagrams {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [string] $Kit = (Get-Config -Config slides).drawio_kit,

        [string] $Theme = (Get-Config -Config slides).theme,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Workers = (Get-Config -Config slides).render_parallel,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $FromDrawing,

        [switch] $Stale,

        [switch] $DryRun,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $diagramKit = [Catzc.Base.Slides.DrawioKit]::new($root, $Kit)
    $renderer = $diagramKit.Renderer
    Assert-PathExist $renderer -PathType Leaf -ErrorText "Build-Diagrams: the draw.io kit '$Kit' has no drawio_forward.py; slides.yml drawio_kit names the kit."
    Assert-True (-not ($FromDrawing -and $Stale)) -ErrorText 'Build-Diagrams: -FromDrawing and -Stale are two journeys; pass one.'
    # -Stale rebuilds only the diagrams whose minimaps a tree change left stale: the set Test-Diagrams reports.
    if ($Stale) {
        Assert-True (-not $Path) -ErrorText 'Build-Diagrams: -Stale finds its diagrams itself; pass no -Path.'
        # The stale set is checked before it becomes -Path, whose ValidatePathGiven refuses an empty list on assignment too.
        $stalePaths = @((Test-Diagrams -Kit $Kit -RepositoryRoot $root -PassThru).Facts['StaleDiagrams'])
        if ($stalePaths.Count -eq 0) {
            Write-Message 'Build-Diagrams: no diagram carries a stale minimap.'
            return
        }
        $Path = $stalePaths
    }

    # A diagram is found by its tracked png or its yml, never listed, so a new one gets its first put.
    $tracked = @(Get-GitTrackedPath '.')
    $candidates = @($tracked) + @(Get-GitChangedPath 'docs')
    # A diagram is the pair <article-folder>/.assets/<name>.drawio.png and .yml, named by its stem <article-folder>/.assets/<name>.
    $found = @($candidates | Where-Object { $_ -cmatch '^docs/(.+/)?\.assets/[^/]+\.drawio\.(png|yml)$' } |
            Where-Object { $_.EndsWith('.png') -or (Test-Path -LiteralPath (Join-Path $root $_) -PathType Leaf) } |
            ForEach-Object { $_ -creplace '\.drawio\.(png|yml)$', '' } | Select-Object -Unique)
    # A diagram in the article carrier has no yml beside its png, and before its first put no png either: its block names it.
    $found = @($found) + @(Get-DiagramArticleStem -RepositoryRoot $root -Candidate $candidates | Where-Object { $found -cnotcontains $_ })
    $folders = @(if ($Path) {
            @(foreach ($folderPath in $Path) {
                    $relative = ([System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath((Join-Path $root $folderPath))) -replace '\\', '/') -creplace '\.drawio\.(png|yml)$', ''
                    Assert-True ($found -ccontains $relative) -ErrorText "Build-Diagrams: '$relative' is not a diagram (<article-folder>/.assets/<name>.drawio.yml, a tracked <name>.drawio.png, or a `yml drawio` block above an image of it in an article)."
                    $relative
                })
        }
        else {
            $found
        })

    # Every article and slide that embeds a diagram's png, wherever it sits; each one's Supports line is held against the yml.
    $embedders = Get-DiagramEmbedder -Tracked $tracked -RepositoryRoot $root
    $articles = @{}
    $findings = [System.Collections.Generic.List[string]]::new()
    foreach ($folderPath in $folders) {
        $articles[$folderPath] = [string[]] @(if ($embedders.ContainsKey($folderPath)) {
                $embedders[$folderPath]
            })
        if ($articles[$folderPath].Count -eq 0) {
            $findings.Add("E_ORPHAN ${folderPath}: no page embeds its .drawio.png")
        }
        foreach ($drift in @(Get-DiagramSupportsDrift -Stem $folderPath -Page $articles[$folderPath] -RepositoryRoot $root)) {
            $findings.Add("E_SUPPORTS $drift")
        }
    }
    # Every finding is an error, by the one setting of the kit's drawio.yml (renderer findings-fail); none is a warning.
    $failOnFindings = (Get-Content -LiteralPath (Join-Path $diagramKit.Folder 'configs/drawio.yml') -Raw) -match '(?m)^\s*findings-fail:\s*yes'
    Assert-True (-not ($failOnFindings -and $findings.Count -gt 0)) -ErrorText "Build-Diagrams: $($findings.Count) finding(s), each an error:`n$($findings -join "`n")"

    $uv = 'uv'
    if (-not $DryRun -and $folders.Count -gt 0) {
        $tool = Resolve-ToolExecutable -Tool uv
        Assert-True $tool.Found -ErrorText 'Build-Diagrams: uv is not installed (no managed uv found). Run Install-Uv.'
        $uv = "`"$($tool.Path)`""
    }

    $render = $true
    $runs = [System.Collections.Generic.List[pscustomobject]]::new()
    $total = [System.Diagnostics.Stopwatch]::StartNew()
    $declared = @($folders | Where-Object { $null -ne (Get-DiagramDeclarationText -Stem $_ -RepositoryRoot $root) })
    # -Stale found its set through Test-Diagrams, which has just written the minimap data of every declared diagram.
    if (-not $DryRun -and -not $Stale -and $declared.Count -gt 0) {
        Write-Message "Build-Diagrams: writing the minimap data of $($declared.Count) declared diagram(s), then $(if ($FromDrawing) { 'syncing' } else { 'rendering' }) $($folders.Count)."
        # One call builds the world map once for every diagram; each diagram's target streams back as its data is written.
        $index = 0
        $step = [System.Diagnostics.Stopwatch]::StartNew()
        Write-DiagramMinimapData -Stem $declared -RepositoryRoot $root | ForEach-Object {
            Write-Message "minimaps $($index + 1)/$($declared.Count) $($declared[$index]) ($([Math]::Round($step.Elapsed.TotalSeconds, 1)) s)"
            $index++
            $step.Restart()
        }
    }
    # Sync runs get then put per diagram, stops on a conflict, and ends in the drift gate; the renderer never runs.
    if ($FromDrawing) {
        Assert-True ([bool] $Path) -ErrorText 'Build-Diagrams: -FromDrawing syncs the diagrams it is given; pass -Path.'
        $declaration = $diagramKit.Declaration
        foreach ($folderPath in $folders) {
            Assert-True ($declared -ccontains $folderPath) -ErrorText "Build-Diagrams: $folderPath has no declaration to sync (its .drawio.yml, or one ``yml drawio`` block above its image)."
            $arguments = "run --project `"$($diagramKit.Folder)`" python `"$declaration`" sync `"$folderPath`""
            $run = [pscustomobject]@{ Folder = $folderPath; Articles = $articles[$folderPath]; Stage = 'sync'; ExitCode = $null; Status = 'dry-run' }
            $runs.Add($run)
            if ($DryRun) {
                Write-Message "Would run: uv $arguments"
                continue
            }
            $step = [System.Diagnostics.Stopwatch]::StartNew()
            $result = Invoke-Executable "$uv $arguments" -WorkingDirectory $root -PassThru -NoAssert -Silent
            $run.ExitCode = $result.ExitCode
            $row = @($result.Output -split "`r?`n" | Where-Object { $_.StartsWith('{') }) | Select-Object -Last 1 | ForEach-Object { $_ | ConvertFrom-Json }
            Assert-True ($result.ExitCode -eq 0 -and $row -and -not $row.PSObject.Properties['error']) -ErrorText "Build-Diagrams: the sync of $folderPath stopped: $(if ($row -and $row.PSObject.Properties['error']) { $row.error } else { @($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ' })"
            $run.Stage = "sync ($(@($row.ran) -join ', '))"
            $run.Status = 'clean'
            Write-Message "sync $($runs.Count)/$($folders.Count) $folderPath clean ($([Math]::Round($step.Elapsed.TotalSeconds, 1)) s)"
        }
        if (-not $DryRun -and $folders.Count -gt 0) {
            $null = Test-Diagrams -Path $folders -Kit $Kit -RepositoryRoot $root
        }
        $render = $false
    }
    if ($render -and $folders.Count -gt 0) {
        # One renderer call for every folder: each worker pays the imports once, and each folder ends with its JSON row.
        $quoted = ($folders | ForEach-Object { "`"$(Join-Path $root $_)`"" }) -join ' '
        # The query rows go to an address named here, never a default
        # ([DDR-VISUAL-ZOOMISANAXIS](/docs/drs/design/visual-design.md#rule-ddr-visual-zoomisanaxis)).
        $rowsPath = Join-Path (Get-OutputRoot -EnsureExists) 'diagrams/query-rows.json'
        if (-not $DryRun) {
            $null = Write-DiagramQueryRows -Stem $declared -RepositoryRoot $root -Path $rowsPath
        }
        $arguments = "run --project `"$($diagramKit.Folder)`" python `"$renderer`" --theme $Theme --workers $Workers --rows `"$rowsPath`" --all $quoted"
        if ($DryRun) {
            Write-Message "Would run: uv $arguments"
        }
        else {
            $step = [System.Diagnostics.Stopwatch]::StartNew()
            $result = Invoke-Executable "$uv $arguments" -WorkingDirectory $root -PassThru -NoAssert -Silent
            $exits = @{}
            foreach ($line in @($result.Output -split "`r?`n" | Where-Object { $_.StartsWith('{') })) {
                $row = $line | ConvertFrom-Json
                $exits[([System.IO.Path]::GetRelativePath($root, $row.diagram) -replace '\\', '/')] = [int] $row.exit
            }
        }
        foreach ($folderPath in $folders) {
            $run = [pscustomobject]@{ Folder = $folderPath; Articles = $articles[$folderPath]; Stage = 'render'; ExitCode = $null; Status = 'dry-run' }
            $runs.Add($run)
            if ($DryRun) {
                continue
            }
            $run.ExitCode = $exits[$folderPath]
            # The renderer's exit codes: 0 clean, 2 findings (errors) with every artifact delivered, 3 nothing to render; no row is a failure.
            $run.Status = switch ($run.ExitCode) {
                0 {
                    'clean'
                }
                2 {
                    'findings'
                }
                3 {
                    'nothing'
                }
                default {
                    'failed'
                }
            }
            Write-Message "render $($runs.Count)/$($folders.Count) $folderPath $($run.Status)"
        }
        if (-not $DryRun) {
            Write-Message "render: $($folders.Count) folder(s) across $Workers worker(s) ($([Math]::Round($step.Elapsed.TotalSeconds, 1)) s)"
            $findingFolders = @($runs | Where-Object Status -EQ 'findings' | ForEach-Object Folder)
            $failedFolders = @($runs | Where-Object Status -EQ 'failed' | ForEach-Object Folder)
            Assert-True ($findingFolders.Count -eq 0) -ErrorText "Build-Diagrams: the renderer reported findings on $($findingFolders -join ', '), each an error; see their bulk reports under out/drawio/."
            Assert-True ($failedFolders.Count -eq 0) -ErrorText "Build-Diagrams: the renderer failed on $($failedFolders -join ', ') (exit $($result.ExitCode)): $(@($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ')"
        }
    }
    Write-Message "Build-Diagrams: $($folders.Count) diagram(s) $(if ($FromDrawing) { 'synced from the drawing' } else { 'rendered' })$(if ($DryRun) { ', dry run' }) in $([Math]::Round($total.Elapsed.TotalSeconds, 1)) s."

    if ($PassThru) {
        return $runs.ToArray()
    }
}
