function Build-Diagrams {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Folder,

        [ValidateSet('all', 'prepare', 'highlight', 'join')]
        [string] $Stage = 'all',

        [ValidateRange(1, 10000)]
        [int] $Batch = (Get-Config -Config slides).diagram_batch,

        [string] $Kit = (Get-Config -Config slides).drawio_kit,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $renderer = Join-Path $root "$Kit/drawio_forward.py"
    Assert-PathExist $renderer -PathType Leaf -ErrorText "Build-Diagrams: the draw.io kit '$Kit' has no drawio_forward.py; slides.yml drawio_kit names the kit."

    # Every folder that holds a tracked slide, or the folders asked for; a slide is a tracked .drawio.png directly in the folder.
    $slides = @(Get-GitTrackedPath '.' | Where-Object { $_ -like '*.drawio.png' })
    $folders = if ($Folder) {
        @($Folder | ForEach-Object { ([System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath((Join-Path $root $_))) -replace '\\', '/').TrimEnd('/') })
    }
    else {
        @($slides | ForEach-Object { $_.Substring(0, $_.LastIndexOf('/')) } | Sort-Object -Unique)
    }

    $uv = 'uv'
    if (-not $DryRun) {
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
    foreach ($folderPath in $folders) {
        $count = @($slides | Where-Object { $_.Substring(0, $_.LastIndexOf('/')) -ceq $folderPath }).Count
        if ($count -eq 0) {
            Write-Message "Build-Diagrams: $folderPath holds no tracked slide; skipped."
            continue
        }
        foreach ($name in $stages) {
            # The prepare stage writes the folder's slide list in one call; the per-slide stages run in slices of -Batch.
            $slices = [System.Collections.Generic.List[pscustomobject]]::new()
            if ($name -eq 'prepare') {
                $slices.Add([pscustomobject]@{ Start = $null; End = $null })
            }
            else {
                for ($start = 0; $start -lt $count; $start += $Batch) {
                    $slices.Add([pscustomobject]@{ Start = $start; End = [Math]::Min($start + $Batch, $count) })
                }
            }
            foreach ($slice in $slices) {
                $arguments = "run --with pillow python `"$renderer`" --all `"$(Join-Path $root $folderPath)`" --stage $name"
                if ($null -ne $slice.Start) {
                    $arguments += " --start $($slice.Start) --end $($slice.End)"
                }
                $run = [pscustomobject]@{ Folder = $folderPath; Stage = $name; Start = $slice.Start; End = $slice.End; ExitCode = $null; Status = 'dry-run' }
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
                    Write-Message "Build-Diagrams: $folderPath $name $($slice.Start)..$($slice.End) finished with warnings; see out/drawio/$(Split-Path $folderPath -Leaf)/bulk.md." -Warning
                }
                Assert-True ($run.Status -ne 'failed') -ErrorText "Build-Diagrams: the renderer failed on $folderPath, stage $name (exit $($result.ExitCode)): $(@($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ')"
            }
        }
        Write-Message "Build-Diagrams: $folderPath, $count slide(s), stages $($stages -join ', ') done."
    }

    if ($PassThru) {
        return $runs.ToArray()
    }
}
