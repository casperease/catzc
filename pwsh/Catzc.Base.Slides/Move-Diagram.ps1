<#
---
catzc:
  immutable:
    with_body_sha: "8552bd414e66"
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Move-Diagram.Tests.ps1
    docs: "[Move-Diagram.ps1.md](docs/references/pwsh/catzc-base-slides/Move-Diagram.ps1.md)"
    cites:
      - ADR-REPO-LINK-MARKDOWNRELATIVE
---
#>

function Move-Diagram {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [string] $Destination,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $relative = {
        param([string] $Value)
        ([System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath((Join-Path $root $Value))) -replace '\\', '/').TrimEnd('/')
    }
    $from = & $relative $Path
    $to = & $relative $Destination
    Assert-False ($from -eq '.' -or $from.StartsWith('../') -or $to -eq '.' -or $to.StartsWith('../')) -ErrorText "Move-Diagram: '$Path' and '$Destination' must both lie inside the repository '$root'."
    Assert-False ($to -ceq $from -or $to.StartsWith("$from/")) -ErrorText "Move-Diagram: '$Destination' is '$Path' or lies inside it."
    Assert-False (Test-Path -LiteralPath (Join-Path $root $to)) -ErrorText "Move-Diagram: '$to' already exists; a move never merges into an existing path."

    $listed = Invoke-Executable "git ls-files -z -- `"$from`"" -WorkingDirectory $root -PassThru -Silent
    $tracked = @($listed.Output -split "`0" | Where-Object { $_ })
    Assert-True ($tracked.Count -gt 0) -ErrorText "Move-Diagram: '$from' holds no tracked file."
    $moves = @(foreach ($file in $tracked) {
            [pscustomobject]@{ From = $file; To = $to + $file.Substring($from.Length) }
        })

    # A page that links into the moved path names its last segment, so only those pages are read in full.
    $leaf = $from.Substring($from.LastIndexOf('/') + 1)
    $all = Invoke-Executable 'git ls-files -z -- "*.md"' -WorkingDirectory $root -PassThru -Silent
    $edits = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($page in @($all.Output -split "`0" | Where-Object { $_ })) {
        $move = $moves | Where-Object { $_.From -ceq $page } | Select-Object -First 1
        $text = [System.IO.File]::ReadAllText((Join-Path $root $page))
        if (-not $move -and -not $text.Contains($leaf)) {
            continue
        }
        $target = if ($move) {
            $move.To
        }
        else {
            $page
        }
        $folder = if ($target.Contains('/')) {
            $target.Substring(0, $target.LastIndexOf('/'))
        }
        else {
            ''
        }
        $rebased = [Catzc.Base.MarkdownMeta.MarkdownLinkRebaser]::Rebase($text, $page, $folder, $from, $to)
        if ($rebased -cne $text) {
            $edits.Add([pscustomobject]@{ Page = $target; Text = $rebased })
        }
    }

    if ($DryRun) {
        foreach ($move in $moves) {
            Write-Message "Would move: $($move.From) -> $($move.To)"
        }
        foreach ($edit in $edits) {
            Write-Message "Would re-point the links of $($edit.Page)"
        }
    }
    else {
        $parent = Split-Path (Join-Path $root $to) -Parent
        [System.IO.Directory]::CreateDirectory($parent) | Out-Null
        Invoke-Executable "git mv -- `"$from`" `"$to`"" -WorkingDirectory $root -Silent | Out-Null
        foreach ($edit in $edits) {
            Write-FileIfChanged -Path (Join-Path $root $edit.Page) -Content $edit.Text | Out-Null
        }
        # A re-pointed link changes its line's length, so every rewritten page is formatted again, as the repository formats it.
        $pages = @(foreach ($edit in $edits) {
                if ($edit.Page.EndsWith('.md', [System.StringComparison]::OrdinalIgnoreCase)) {
                    [System.IO.Path]::GetFullPath((Join-Path $root $edit.Page))
                }
            })
        if ($pages.Count -gt 0) {
            Format-Code -Language markdown -Path $pages | Out-Null
        }
        Write-Message "Move-Diagram: $from -> $to, $($moves.Count) file(s) moved, the links of $($edits.Count) page(s) re-pointed."
    }

    if ($PassThru) {
        $pages = @(foreach ($edit in $edits) {
                $edit.Page
            })
        return [pscustomobject]@{ From = $from; To = $to; Moves = $moves; Pages = $pages; DryRun = [bool] $DryRun }
    }
}
