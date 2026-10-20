function Build-Diagrams {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Path,

        [ValidateSet('all', 'prepare', 'highlight', 'join')]
        [string] $Stage = 'all',

        [string] $Kit = (Get-Config -Config slides).drawio_kit,

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

    # A diagram folder is `<article-folder>/.assets/<name>/` holding a tracked diagram.drawio.png; it is found, never listed.
    $tracked = @(Get-GitTrackedPath '.')
    $found = @($tracked | Where-Object { $_ -cmatch '^docs/(.+/)?\.assets/[^/]+/diagram\.drawio\.png$' } | ForEach-Object { $_.Substring(0, $_.LastIndexOf('/')) })
    $folders = @(if ($Path) {
            @(foreach ($folderPath in $Path) {
                    $relative = ([System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath((Join-Path $root $folderPath))) -replace '\\', '/').TrimEnd('/')
                    Assert-True ($found -ccontains $relative) -ErrorText "Build-Diagrams: '$relative' is not a diagram folder (<article-folder>/.assets/<name>/ holding a tracked diagram.drawio.png)."
                    $relative
                })
        }
        else {
            $found
        })

    # Found by locality: a folder's article is the one page beside its .assets that embeds its diagram.drawio.png.
    $articles = @{}
    foreach ($folderPath in $folders) {
        $articleFolder = $folderPath.Substring(0, $folderPath.LastIndexOf('/.assets/'))
        $name = $folderPath.Substring($folderPath.LastIndexOf('/') + 1)
        $embed = '\]\((\./)?\.assets/' + [regex]::Escape($name) + '/diagram\.drawio\.png[)#\s]'
        $pages = @($tracked | Where-Object { $_ -like '*.md' -and $_.Substring(0, [Math]::Max(0, $_.LastIndexOf('/'))) -ceq $articleFolder })
        $embedders = @($pages | Where-Object { [System.IO.File]::ReadAllText((Join-Path $root $_)) -match $embed })
        Assert-True ($embedders.Count -le 1) -ErrorText "Build-Diagrams: $folderPath is embedded by $($embedders.Count) pages ($($embedders -join ', ')); a diagram belongs to one article."
        $articles[$folderPath] = $embedders | Select-Object -First 1
        if ($embedders.Count -eq 0) {
            Write-Message "Build-Diagrams: $folderPath is an orphan; no page in $articleFolder embeds its diagram.drawio.png." -Warning
        }
    }

    $uv = 'uv'
    if (-not $DryRun -and $folders.Count -gt 0) {
        $tool = Resolve-ToolExecutable -Tool uv
        Assert-True $tool.Found -ErrorText 'Build-Diagrams: uv is not installed (no managed uv found). Run Install-Uv.'
        $uv = "`"$($tool.Path)`""
    }

    $stages = if ($Stage -eq 'all') {
        'prepare', 'highlight', 'join'
    }
    else {
        , $Stage
    }
    $runs = [System.Collections.Generic.List[pscustomobject]]::new()
    if ($FromDrawing) {
        Assert-True ([bool] $Path) -ErrorText 'Build-Diagrams: -FromDrawing syncs the folders it is given; pass -Path.'
        $declaration = Join-Path $root "$Kit/declaration.py"
        foreach ($folderPath in $folders) {
            Assert-PathExist (Join-Path $root "$folderPath/diagram.drawio.yml") -PathType Leaf -ErrorText "Build-Diagrams: $folderPath has no diagram.drawio.yml to sync."
            $arguments = "run --project `"$(Join-Path $root $Kit)`" python `"$declaration`" sync `"$folderPath`""
            $run = [pscustomobject]@{ Folder = $folderPath; Article = $articles[$folderPath]; Stage = 'sync'; ExitCode = $null; Status = 'dry-run' }
            $runs.Add($run)
            if ($DryRun) {
                Write-Message "Would run: uv $arguments"
                continue
            }
            $result = Invoke-Executable "$uv $arguments" -WorkingDirectory $root -PassThru -NoAssert -Silent
            $run.ExitCode = $result.ExitCode
            $row = @($result.Output -split "`r?`n" | Where-Object { $_.StartsWith('{') }) | Select-Object -Last 1 | ForEach-Object { $_ | ConvertFrom-Json }
            Assert-True ($result.ExitCode -eq 0 -and $row -and -not $row.PSObject.Properties['error']) -ErrorText "Build-Diagrams: the sync of $folderPath stopped: $(if ($row -and $row.PSObject.Properties['error']) { $row.error } else { @($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ' })"
            $run.Stage = "sync ($(@($row.ran) -join ', '))"
            $run.Status = 'clean'
        }
        if (-not $DryRun) {
            $null = Test-Diagrams -Path $folders -Kit $Kit -RepositoryRoot $root
        }
        $stages = @()
    }
    foreach ($folderPath in $folders) {
        foreach ($name in $stages) {
            $arguments = "run --project `"$(Join-Path $root $Kit)`" python `"$renderer`" --all `"$(Join-Path $root $folderPath)`" --stage $name"
            $run = [pscustomobject]@{ Folder = $folderPath; Article = $articles[$folderPath]; Stage = $name; ExitCode = $null; Status = 'dry-run' }
            if ($DryRun) {
                Write-Message "Would run: uv $arguments"
                $runs.Add($run)
                continue
            }
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
            if ($run.Status -eq 'warnings') {
                Write-Message "Build-Diagrams: $folderPath $name finished with warnings; see the renderer's bulk report under out/drawio/." -Warning
            }
            Assert-True ($run.Status -ne 'failed') -ErrorText "Build-Diagrams: the renderer failed on $folderPath, stage $name (exit $($result.ExitCode)): $(@($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ')"
        }
    }
    Write-Message "Build-Diagrams: $($folders.Count) diagram folder(s), $(if ($FromDrawing) { 'synced from the drawing' } else { "stages $($stages -join ', ')" })$(if ($DryRun) { ', dry run' }) done."

    if ($PassThru) {
        return $runs.ToArray()
    }
}
