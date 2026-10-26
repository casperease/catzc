<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-slides/Test-Diagrams.ps1.md"
  header: "generated"
---
#>

function Test-Diagrams {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [string] $Kit = (Get-Config -Config slides).drawio_kit,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $diagramKit = [Catzc.Base.Slides.DrawioKit]::new($root, $Kit)
    $declaration = $diagramKit.Declaration
    Assert-PathExist $declaration -PathType Leaf -ErrorText "Test-Diagrams: the draw.io kit '$Kit' has no declaration.py; slides.yml drawio_kit names the kit."

    # A yml under docs/**/.assets, tracked or not, declares a diagram; a new one is checked after its first put.
    $candidates = @(Get-GitTrackedPath '.') + @(Get-GitChangedPath 'docs')
    $found = @($candidates | Where-Object { $_ -cmatch '^docs/(.+/)?\.assets/[^/]+\.drawio\.(png|yml)$' } |
            ForEach-Object { $_ -creplace '\.drawio\.(png|yml)$', '' } |
            Select-Object -Unique |
            Where-Object { Test-Path -LiteralPath (Join-Path $root "$_.drawio.yml") -PathType Leaf })
    # A legend diagram has no yml: drawio.yml names its stem under roles, and its png is checked against the painted glyph library.
    $kitConfigPath = $diagramKit.Config
    $kitConfig = if ([System.IO.File]::Exists($kitConfigPath)) {
        ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($kitConfigPath)) -Ordered
    }
    $legends = @(if ($kitConfig -and $kitConfig.Contains('roles') -and $kitConfig['roles']) {
            $kitConfig['roles'].Keys |
                Where-Object { $kitConfig['roles'][$_] -ceq 'legend' -and (Test-Path -LiteralPath (Join-Path $root "$_.drawio.png") -PathType Leaf) }
        })
    $found = @($found) + @($legends | Where-Object { $found -cnotcontains $_ })
    # An article-carried diagram's stem is a tracked png with no yml, or an image a yml drawio block sits above.
    $pngStems = @($candidates | Where-Object { $_ -cmatch '^docs/(.+/)?\.assets/[^/]+\.drawio\.png$' } |
            ForEach-Object { $_ -creplace '\.drawio\.png$', '' })
    $articleCarried = @(@($pngStems) + @(Get-DiagramArticleStem -RepositoryRoot $root -Candidate $candidates) | Select-Object -Unique)
    $found = @($found) + @($articleCarried | Where-Object { $found -cnotcontains $_ })
    $folders = @(if ($Path) {
            foreach ($folderPath in $Path) {
                $relative = ([System.IO.Path]::GetRelativePath($root,
                        [System.IO.Path]::GetFullPath((Join-Path $root $folderPath))) -replace '\\',
                    '/') -creplace '\.drawio\.(png|yml)$', ''
                Assert-True ($found -ccontains $relative) -ErrorText "Test-Diagrams: '$relative' is not a declared diagram (a <name>.drawio.yml under docs/**/.assets/, a diagram the kit's drawio.yml puts in an article, or a legend it names)."
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
        $declared = @($folders | Where-Object { $legends -cnotcontains $_ -and $null -ne (Get-DiagramDeclarationText -Stem $_ -RepositoryRoot $root) })
        if ($declared.Count -gt 0) {
            $null = Write-DiagramMinimapData -Stem $declared -RepositoryRoot $root
        }
        $nameExempt = @((Get-Config -Config slides).name_mentions.Keys)
        foreach ($stem in $declared) {
            $declarationText = Get-DiagramDeclarationText -Stem $stem -RepositoryRoot $root
            foreach ($finding in @(Get-DiagramProofFinding -Stem $stem -Text $declarationText -RepositoryRoot $root)) {
                $issues.Add($finding)
            }
            foreach ($finding in @(Get-NameMentionFinding -Path $stem -Text $declarationText -Exempt $nameExempt)) {
                $issues.Add($finding)
            }
        }
        $quoted = ($folders | ForEach-Object { "`"$_`"" }) -join ' '
        # A C3 or C4 slide is checked against its query's rows, as Build-Diagrams rendered it.
        $rowsPath = Join-Path (Get-OutputRoot -EnsureExists) 'diagrams/query-rows.json'
        $null = Write-DiagramQueryRows -Stem $declared -RepositoryRoot $root -Path $rowsPath
        $result = Invoke-Executable "`"$($tool.Path)`" run --project `"$($diagramKit.Folder)`" python -m $($diagramKit.DeclarationModule()) --rows `"$rowsPath`" check $quoted" -WorkingDirectory $root -PassThru -NoAssert -Silent
        Assert-True ($result.ExitCode -eq 0) -ErrorText "Test-Diagrams: the drift check failed (exit $($result.ExitCode)): $(@($result.Output -split "`r?`n" | Select-Object -Last 5) -join ' | ')"
        # One JSON line per diagram: conflicted cells, drifted cells, stale minimaps, or an error.
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
    # Over the whole tree, a yml drawio block declares only the png embedded directly below it; any other block is a finding.
    if (-not $Path) {
        $bound = '(?m)^```yml drawio[ \t]*\r?\n(?:(?!```)[^\r\n]*\r?\n)*```[ \t]*\r?\n(?:[ \t]*\r?\n)*!\[[^\]]*\](?:\((?:\./)?\.assets/[^/)\s]+\.drawio\.png\)|\[([^\]]+)\])'
        foreach ($page in @($candidates | Where-Object { $_ -like 'docs/*.md' } | Select-Object -Unique)) {
            $full = Join-Path $root $page
            if (-not [System.IO.File]::Exists($full)) {
                continue
            }
            $text = [System.IO.File]::ReadAllText($full)
            $fences = @([regex]::Matches($text, '(?m)^```yml drawio[ \t]*$'))
            # A reference image binds its block only when its definition names a diagram's png.
            $references = Get-DiagramImageReference -Text $text
            $bounded = @([regex]::Matches($text,
                    $bound) | Where-Object { -not $_.Groups[1].Success -or $references.ContainsKey($_.Groups[1].Value.ToLowerInvariant()) })
            $unbound = $fences.Count - $bounded.Count
            if ($unbound -gt 0) {
                $issues.Add("${page}: $unbound ``yml drawio`` block(s) with no image of an .assets/<name>.drawio.png directly below")
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
