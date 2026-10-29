function Move-Diagram {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [string] $Destination,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $Kit = (Get-Config -Config slides).drawio_kit,

        [switch] $DryRun,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $relative = {
        param([string] $Value)
        ([System.IO.Path]::GetRelativePath($root,
            [System.IO.Path]::GetFullPath((Join-Path $root $Value))) -replace '\\', '/').TrimEnd('/')
    }
    $from = & $relative $Path
    $to = & $relative $Destination
    Assert-False ($from -eq '.' -or $from.StartsWith('../') -or $to -eq '.' -or
        $to.StartsWith('../')) -ErrorText "Move-Diagram: '$Path' and '$Destination' must both lie inside the repository '$root'."
    # A diagram pair moves whole, named by either file or its stem; any other path moves as it is.
    $pair = $from -cmatch '\.drawio\.(png|yml)$' -or -not (Test-Path -LiteralPath (Join-Path $root $from))
    if ($pair) {
        $from = $from -creplace '\.drawio\.(png|yml)$', ''
        $to = $to -creplace '\.drawio\.(png|yml)$', ''
    }
    $sources = @(if ($pair) {
            "$from.drawio.png", "$from.drawio.yml"
        }
        else {
            $from
        })
    Assert-False ($to -ceq $from -or
        $to.StartsWith("$from/")) -ErrorText "Move-Diagram: '$Destination' is '$Path' or lies inside it."
    foreach ($target in @(if ($pair) {
                "$to.drawio.png", "$to.drawio.yml"
            }
            else {
                $to
            })) {
        Assert-False (Test-Path -LiteralPath (Join-Path $root $target)) -ErrorText "Move-Diagram: '$target' already exists; a move never merges into an existing path."
    }

    $quoted = ($sources | ForEach-Object { '"' + $_ + '"' }) -join ' '
    $listed = Invoke-Executable "git ls-files -z -- $quoted" -WorkingDirectory $root -PassThru -Silent
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
        # A page still in the index but deleted on disk links to nothing.
        $pagePath = Join-Path $root $page
        if (-not [System.IO.File]::Exists($pagePath)) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($pagePath)
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
        $rebased = $text
        foreach ($source in $sources) {
            $rebased = [Catzc.Base.MarkdownMeta.MarkdownLinkRebaser]::Rebase($rebased, $page, $folder, $source,
                $to + $source.Substring($from.Length))
        }
        if ($rebased -cne $text) {
            $edits.Add([pscustomobject]@{ Page = $target; Text = $rebased })
        }
    }

    # Roles are keyed by stem in the kit's drawio.yml; a png with no yml beside it is article-carried.
    $kitConfig = [Catzc.Base.Slides.DrawioKit]::new($root, $Kit).Config
    $configText = if ([System.IO.File]::Exists($kitConfig)) {
        [System.IO.File]::ReadAllText($kitConfig)
    }
    $articleCarried = $pair -and -not (Test-Path -LiteralPath (Join-Path $root "$from.drawio.yml") -PathType Leaf)
    $fromArticles = $from.Substring(0, [Math]::Max(0, $from.LastIndexOf('/'))) -replace '/?[^/]*$', ''
    $toArticles = $to.Substring(0, [Math]::Max(0, $to.LastIndexOf('/'))) -replace '/?[^/]*$', ''
    if ($articleCarried -and $fromArticles -cne $toArticles) {
        # The block declares only from a page beside its .assets, so it moves to the one page there that embeds the png.
        $imageOf = {
            param([string] $Name, [string] $Text)
            $labels = @((Get-DiagramImageReference -Text $Text).GetEnumerator() | Where-Object { $_.Value -ceq $Name } |
                    ForEach-Object { [regex]::Escape($_.Key) })
            $reference = ''
            if ($labels.Count) {
                $reference = '|\[(?i:' + ($labels -join '|') + ')\]'
            }
            '!\[[^\]]*\](?:\((?:\./)?\.assets/' + [regex]::Escape($Name) + '\.drawio\.png\)' + $reference + ')'
        }
        $blockOf = {
            param([string] $Name, [string] $Text)
            '(?m)^```yml drawio[ \t]*\r?\n(?:(?!```)[^\r\n]*\r?\n)*```[ \t]*\r?\n(?:[ \t]*\r?\n)*(?=' + (& $imageOf $Name $Text) + ')'
        }
        $textOf = {
            param([string] $Page)
            $edit = $edits | Where-Object { $_.Page -ceq $Page } | Select-Object -First 1
            if ($edit) {
                $edit.Text
            }
            else {
                [System.IO.File]::ReadAllText((Join-Path $root $Page))
            }
        }
        $pagesIn = {
            param([string] $Folder)
            @(Get-ChildPath -Path (Join-Path $root $Folder) -Depth 1 -Filter '*.md' -File | Where-Object { -not "$_".EndsWith('.slide.md') } | ForEach-Object {
                    ([System.IO.Path]::GetRelativePath($root, "$_") -replace '\\', '/')
                })
        }
        $fromName = $from.Substring($from.LastIndexOf('/') + 1)
        $toName = $to.Substring($to.LastIndexOf('/') + 1)
        $holders = @(foreach ($page in & $pagesIn $fromArticles) {
                $pageText = [System.IO.File]::ReadAllText((Join-Path $root $page))
                $found = [regex]::Match($pageText, (& $blockOf $fromName $pageText))
                if ($found.Success) {
                    [pscustomobject]@{ Page = $page; Block = $found.Value }
                }
            })
        Assert-True ($holders.Count -eq 1) -ErrorText "Move-Diagram: '$from' is article-carried but $($holders.Count) page(s) beside its .assets hold its block; Test-Diagrams names the fault."
        $targets = @(foreach ($page in & $pagesIn $toArticles) {
                $pageText = & $textOf $page
                foreach ($match in [regex]::Matches($pageText, '(?m)^' + (& $imageOf $toName $pageText))) {
                    [pscustomobject]@{ Page = $page; At = $match.Index }
                }
            })
        Assert-True ($targets.Count -eq 1) -ErrorText "Move-Diagram: '$from' is article-carried, and $($targets.Count) image(s) of $toName.drawio.png sit in a page beside '$to''s .assets; its block needs exactly one. Carry it to the file carrier first (declaration.py carry $from file)."
        $source = & $textOf $holders[0].Page
        $at = $source.IndexOf($holders[0].Block, [System.StringComparison]::Ordinal)
        $stripped = $source.Remove($at, $holders[0].Block.Length)
        $target = if ($targets[0].Page -ceq $holders[0].Page) {
            $stripped
        }
        else {
            & $textOf $targets[0].Page
        }
        $placed = $target.Insert([regex]::Match($target, '(?m)^' + (& $imageOf $toName $target)).Index,
            $holders[0].Block)
        foreach ($change in @([pscustomobject]@{ Page = $holders[0].Page; Text = $stripped }, [pscustomobject]@{ Page = $targets[0].Page; Text = $placed })) {
            # A page whose links were re-pointed already has an entry, which the block-moved text replaces; a page with none is added.
            $prior = $edits | Where-Object { $_.Page -ceq $change.Page } | Select-Object -First 1
            if ($null -ne $prior) {
                $edits.Remove($prior) | Out-Null
            }
            $edits.Add($change)
        }
    }
    # A stem's role entry follows it, so drawio.yml keeps naming the diagram after the move; the kit's one editor re-keys it.
    $rekey = $false
    if ($null -ne $configText) {
        $config = ConvertFrom-Yaml -Yaml $configText -Ordered
        $keys = @(foreach ($section in 'roles') {
                if ($config.Contains($section) -and $config[$section] -is [System.Collections.IDictionary]) {
                    $config[$section].Keys
                }
            })
        $rekey = @($keys | Where-Object { "$_" -ceq $from -or "$_".StartsWith("$from/",
                    [System.StringComparison]::Ordinal) }).Count -gt 0
    }

    if ($DryRun) {
        if ($rekey) {
            Write-Message "Would re-key $from to $to in $Kit/configs/drawio.yml"
        }
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
        foreach ($source in $sources) {
            if (Test-Path -LiteralPath (Join-Path $root $source)) {
                Invoke-Executable "git mv -- `"$source`" `"$to$($source.Substring($from.Length))`"" -WorkingDirectory $root -Silent | Out-Null
            }
        }
        foreach ($edit in $edits) {
            Write-FileIfChanged -Path (Join-Path $root $edit.Page) -Content $edit.Text | Out-Null
        }
        if ($rekey) {
            # The kit's code is the loaded repository's; the drawio.yml it edits is the target tree's.
            $kitCode = [Catzc.Base.Slides.DrawioKit]::new((Get-RepositoryRoot), $Kit)
            $tool = Resolve-ToolExecutable -Tool uv
            Assert-True $tool.Found -ErrorText 'Move-Diagram: uv is not installed (no managed uv found). Run Install-Uv.'
            Assert-DiagramKitSynced
            Invoke-Executable "`"$($tool.Path)`" run --no-sync --project `"$($kitCode.Folder)`" python -m $($kitCode.DeclarationModule()) rekey `"$from`" `"$to`" `"$kitConfig`"" -WorkingDirectory $root -Silent | Out-Null
        }
        # A re-pointed link changes its line's length, so every rewritten page is formatted again.
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
