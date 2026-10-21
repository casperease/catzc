<#
---
catzc:
  immutable:
    with_body_sha: "5ff46dce0063"
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Build-Diagrams.Tests.ps1
    docs: "[Build-Diagrams.ps1.md](docs/references/pwsh/catzc-base-slides/Build-Diagrams.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-MINIMAPSFROMDATA
---
#>

function Build-Diagrams {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Path,

        [string] $Kit = (Get-Config -Config slides).drawio_kit,

        [string] $Theme = (Get-Config -Config slides).theme,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $FromDrawing,

        [switch] $Stale,

        [switch] $DryRun,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $renderer = Join-Path $root "$Kit/drawio_forward.py"
    Assert-PathExist $renderer -PathType Leaf -ErrorText "Build-Diagrams: the draw.io kit '$Kit' has no drawio_forward.py; slides.yml drawio_kit names the kit."
    Assert-True (-not ($FromDrawing -and $Stale)) -ErrorText 'Build-Diagrams: -FromDrawing and -Stale are two journeys; pass one.'
    # -Stale rebuilds only the diagrams whose minimaps a tree change left stale: the set Test-Diagrams reports.
    if ($Stale) {
        Assert-True (-not $Path) -ErrorText 'Build-Diagrams: -Stale finds its folders itself; pass no -Path.'
        $Path = @((Test-Diagrams -Kit $Kit -RepositoryRoot $root -PassThru).Facts['StaleFolders'])
        if ($Path.Count -eq 0) {
            Write-Message 'Build-Diagrams: no diagram carries a stale minimap.'
            return
        }
    }

    $tracked = @(Get-GitTrackedPath '.')
    $candidates = @($tracked) + @(Get-GitChangedPath 'docs')
    $found = @($candidates | Where-Object { $_ -cmatch '^docs/(.+/)?\.assets/[^/]+/diagram\.drawio\.(png|yml)$' } |
            Where-Object { $_.EndsWith('.png') -or (Test-Path -LiteralPath (Join-Path $root $_) -PathType Leaf) } |
            ForEach-Object { $_.Substring(0, $_.LastIndexOf('/')) } | Select-Object -Unique)
    $folders = @(if ($Path) {
            @(foreach ($folderPath in $Path) {
                    $relative = ([System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath((Join-Path $root $folderPath))) -replace '\\', '/').TrimEnd('/')
                    Assert-True ($found -ccontains $relative) -ErrorText "Build-Diagrams: '$relative' is not a diagram folder (<article-folder>/.assets/<name>/ holding a tracked diagram.drawio.png or a diagram.drawio.yml)."
                    $relative
                })
        }
        else {
            $found
        })

    # Every article and slide that embeds a folder's png, wherever it sits; each one's Supports line is held against the yml.
    $embedders = Get-DiagramEmbedder -Tracked $tracked -RepositoryRoot $root
    $articles = @{}
    foreach ($folderPath in $folders) {
        $articles[$folderPath] = [string[]] @(if ($embedders.ContainsKey($folderPath)) {
                $embedders[$folderPath]
            })
        if ($articles[$folderPath].Count -eq 0) {
            Write-Message "Build-Diagrams: $folderPath is an orphan; no page embeds its diagram.drawio.png." -Warning
        }
        foreach ($drift in @(Get-DiagramSupportsDrift -Folder $folderPath -Page $articles[$folderPath] -RepositoryRoot $root)) {
            Write-Message "Build-Diagrams: $drift" -Warning
        }
    }

    $uv = 'uv'
    if (-not $DryRun -and $folders.Count -gt 0) {
        $tool = Resolve-ToolExecutable -Tool uv
        Assert-True $tool.Found -ErrorText 'Build-Diagrams: uv is not installed (no managed uv found). Run Install-Uv.'
        $uv = "`"$($tool.Path)`""
    }

    $render = $true
    $runs = [System.Collections.Generic.List[pscustomobject]]::new()
    $total = [System.Diagnostics.Stopwatch]::StartNew()
    $declared = @($folders | Where-Object { Test-Path -LiteralPath (Join-Path $root "$_/diagram.drawio.yml") -PathType Leaf })
    if (-not $DryRun -and $declared.Count -gt 0) {
        Write-Message "Build-Diagrams: writing the minimap data of $($declared.Count) declared folder(s), then $(if ($FromDrawing) { 'syncing' } else { 'rendering' }) $($folders.Count)."
        for ($index = 0; $index -lt $declared.Count; $index++) {
            $step = [System.Diagnostics.Stopwatch]::StartNew()
            $null = Write-DiagramMinimapData -Folder $declared[$index] -RepositoryRoot $root
            Write-Message "minimaps $($index + 1)/$($declared.Count) $($declared[$index]) ($([Math]::Round($step.Elapsed.TotalSeconds, 1)) s)"
        }
    }
    if ($FromDrawing) {
        Assert-True ([bool] $Path) -ErrorText 'Build-Diagrams: -FromDrawing syncs the folders it is given; pass -Path.'
        $declaration = Join-Path $root "$Kit/declaration.py"
        foreach ($folderPath in $folders) {
            Assert-PathExist (Join-Path $root "$folderPath/diagram.drawio.yml") -PathType Leaf -ErrorText "Build-Diagrams: $folderPath has no diagram.drawio.yml to sync."
            $arguments = "run --project `"$(Join-Path $root $Kit)`" python `"$declaration`" sync `"$folderPath`""
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
        if (-not $DryRun) {
            $null = Test-Diagrams -Path $folders -Kit $Kit -RepositoryRoot $root
        }
        $render = $false
    }
    foreach ($folderPath in @(if ($render) {
                $folders
            })) {
        $arguments = "run --project `"$(Join-Path $root $Kit)`" python `"$renderer`" --all `"$(Join-Path $root $folderPath)`" --theme $Theme"
        $run = [pscustomobject]@{ Folder = $folderPath; Articles = $articles[$folderPath]; Stage = 'render'; ExitCode = $null; Status = 'dry-run' }
        if ($DryRun) {
            Write-Message "Would run: uv $arguments"
            $runs.Add($run)
            continue
        }
        $step = [System.Diagnostics.Stopwatch]::StartNew()
        $result = Invoke-Executable "$uv $arguments" -WorkingDirectory $root -PassThru -NoAssert -Silent
        $run.ExitCode = $result.ExitCode
        # The renderer's exit codes: 0 clean, 2 warnings with every artifact delivered, 3 nothing to render.
        $run.Status = switch ($result.ExitCode) {
            0 {
                'clean'
            }
            2 {
                'warnings'
            }
            3 {
                'nothing'
            }
            default {
                'failed'
            }
        }
        $runs.Add($run)
        Write-Message "render $($runs.Count)/$($folders.Count) $folderPath $($run.Status) ($([Math]::Round($step.Elapsed.TotalSeconds, 1)) s)"
        if ($run.Status -eq 'warnings') {
            Write-Message "Build-Diagrams: $folderPath finished with warnings; see the renderer's bulk report under out/drawio/." -Warning
        }
        Assert-True ($run.Status -ne 'failed') -ErrorText "Build-Diagrams: the renderer failed on $folderPath (exit $($result.ExitCode)): $(@($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ')"
    }
    Write-Message "Build-Diagrams: $($folders.Count) diagram folder(s) $(if ($FromDrawing) { 'synced from the drawing' } else { 'rendered' })$(if ($DryRun) { ', dry run' }) in $([Math]::Round($total.Elapsed.TotalSeconds, 1)) s."

    if ($PassThru) {
        return $runs.ToArray()
    }
}
