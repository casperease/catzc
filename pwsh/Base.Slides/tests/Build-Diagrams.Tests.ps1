Describe 'Build-Diagrams' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'diagram-repository'
        $pages = [ordered]@{
            'kit/drawio_forward.py'  = "# renderer stand-in`n"
            'kit/pyproject.toml'     = "[tool.setuptools]`npackages = [`"catzc.kit`"]`n"
            'kit/configs/drawio.yml' = "renderer:`n  carrier: file`n  findings-fail: yes`n"
            'docs/widgets/index.md'  = "# Widgets`n`n![Widget A](.assets/widget-a.drawio.png)`n`n![Widget B](./.assets/widget-b.drawio.png)`n"
            'docs/widgets/plain.md'  = "# Plain`n`n[a link](.assets/widget-a.drawio.yml)`n"
            'docs/gadgets/index.md'  = "# Gadgets`n`n![Gadget](.assets/gadget.drawio.png)`n"
            'docs/gadgets/second.md' = "# Second`n`n![Gadget again](.assets/gadget.drawio.png)`n"
            'docs/gizmos/index.md'   = "# Gizmos`n`n![Gizmo](.assets/gizmo.drawio.png)`n"
        }
        foreach ($file in $pages.Keys) {
            $full = Join-Path $script:widgetRoot $file
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $pages[$file])
        }
        $script:tracked = @($pages.Keys | Where-Object { $_ -like 'docs/*' }) + @(
            'docs/widgets/.assets/widget-a.drawio.png', 'docs/widgets/.assets/widget-a.drawio.yml',
            'docs/widgets/.assets/widget-b.drawio.png', 'docs/gadgets/.assets/gadget.drawio.png',
            'docs/gizmos/.assets/gizmo.drawio.png', 'docs/widgets/loose.drawio.png',
            'docs/widgets/.assets/nested/deep.drawio.png')
    }

    BeforeEach {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked |
                Where-Object { $_ -notlike 'docs/gadgets/*' } }
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides { }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Found = $true; Path = 'C:/tools/uv.exe' } }
        Mock Write-DiagramMinimapData -ModuleName Catzc.Base.Slides { }
        Mock Write-DiagramQueryRows -ModuleName Catzc.Base.Slides { $Path }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
            $rows = @(if ($Command -match '--all (.+)$') {
                    [regex]::Matches($Matches[1], '"([^"]+)"') |
                        ForEach-Object { @{ diagram = $_.Groups[1].Value; exit = 0 } | ConvertTo-Json -Compress }
                })
            [pscustomobject]@{ ExitCode = 0; Output = $rows -join "`n" }
        }
        Mock Write-Message -ModuleName Catzc.Base.Slides { }
        Mock Set-GeneratedFileHead -ModuleName Catzc.Base.Slides { }
        $script:build = {
            param([hashtable] $Arguments = @{})
            Build-Diagrams -Kit kit -RepositoryRoot $script:widgetRoot -PassThru @Arguments
        }
    }

    It 'renders one diagram in one call, named by its stem, with the pages that embed it' {
        $runs = @(& $script:build @{ Path = 'docs/widgets/.assets/widget-a' })
        @($runs | ForEach-Object { "$($_.Folder) $($_.Stage)" }) | Should -Be @('docs/widgets/.assets/widget-a render')
        @($runs.Articles | Sort-Object -Unique) | Should -Be @('docs/widgets/index.md')
        @($runs.Status | Sort-Object -Unique) | Should -Be @('clean')
    }

    It 'writes the minimap data of every declared folder in one call, one progress line per folder' {
        $declarations = @('docs/widgets/.assets/widget-a',
            'docs/widgets/.assets/widget-b' | ForEach-Object { Join-Path $script:widgetRoot "$_.drawio.yml" })
        Mock Write-DiagramMinimapData -ModuleName Catzc.Base.Slides { foreach ($item in $Stem) {
                "out/minimaps/$item"
            } }
        try {
            foreach ($declaration in $declarations) {
                [System.IO.Directory]::CreateDirectory((Split-Path $declaration -Parent)) | Out-Null
                [System.IO.File]::WriteAllText($declaration, "about: {}`n")
            }
            $null = & $script:build @{ Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b' }
        }
        finally {
            $declarations | ForEach-Object { [System.IO.File]::Delete($_) }
        }
        Should -Invoke Write-DiagramMinimapData -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter { $Stem.Count -eq 2 }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter { $Message -like 'minimaps 1/2 docs/widgets/.assets/widget-a (*' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter { $Message -like 'minimaps 2/2 docs/widgets/.assets/widget-b (*' }
    }

    It 'with no path, rebuilds every diagram pair in a docs/**/.assets/ folder, and nothing outside one or nested below it' {
        $folders = @(& $script:build).Folder
        $folders | Should -Be @('docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b',
            'docs/gizmos/.assets/gizmo')
    }

    It 'finds a legend drawio.yml roles names before its png exists, so an empty tree renders it from the glyph library' -Tag 'ADR-REPO-ROOTCFG-ROLLOFFROUNDTRIP' {
        $config = Join-Path $script:widgetRoot 'kit/configs/drawio.yml'
        $page = Join-Path $script:widgetRoot 'docs/widgets/key.md'
        $shipped = [System.IO.File]::ReadAllText($config)
        try {
            [System.IO.File]::WriteAllText($config, "$($shipped)roles:`n  docs/widgets/.assets/widget-key: legend`n  docs/widgets/.assets/widget-a: slide`n")
            [System.IO.File]::WriteAllText($page, "# Key`n`n![Key](.assets/widget-key.drawio.png)`n")
            Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { @($script:tracked | Where-Object { $_ -notlike 'docs/gadgets/*' }) + 'docs/widgets/key.md' }
            $runs = @(& $script:build)
        }
        finally {
            [System.IO.File]::WriteAllText($config, $shipped)
            [System.IO.File]::Delete($page)
        }
        $runs.Folder | Should -Be @('docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b',
            'docs/gizmos/.assets/gizmo', 'docs/widgets/.assets/widget-key')
        @($runs | Where-Object Folder -EQ 'docs/widgets/.assets/widget-key').Status | Should -Be 'clean'
    }

    It 'calls the kit''s renderer through uv in the kit''s own project, every folder absolute, in one call' {
        & $script:build @{ Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b' } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
            $Command -like '"C:/tools/uv.exe" run --project "*kit*" python -m catzc.kit.drawio_forward --theme dark --workers 3 --rows "*query-rows.json" --all "*docs*widgets*.assets*widget-a" "*docs*widgets*.assets*widget-b"'
        }
    }

    It 'splits the renders across the workers it is given, the default 3 declared once on SlidesConfig' {
        [Catzc.Base.Slides.SlidesConfig]::DefaultRenderParallel | Should -Be 3
        & $script:build @{ Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b'; Workers = 1 } |
            Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter { $Command -like '* --workers 1 --rows "*" --all *' }
    }

    It 'renders every folder before it refuses the one the renderer failed on' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
            [pscustomobject]@{ ExitCode = 1; Output = (@{ diagram = (Join-Path $script:widgetRoot 'docs/widgets/.assets/widget-a'); exit = 0 } | ConvertTo-Json -Compress) }
        }
        { & $script:build @{ Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b' } } |
            Should -Throw '*the renderer failed on docs/widgets/.assets/widget-b (exit 1)*'
    }

    It 'refuses an orphan as an error: no page embeds its png' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { @($script:tracked) + 'docs/gizmos/.assets/lone.drawio.png' }
        { & $script:build @{ Path = 'docs/gizmos/.assets/lone' } } |
            Should -Throw '*E_ORPHAN docs/gizmos/.assets/lone: no page embeds its .drawio.png*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0
    }

    It 'finds every page that embeds one diagram, a second article included, and builds clean' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked }
        $runs = @(& $script:build @{ Path = 'docs/gadgets/.assets/gadget' })
        $runs[0].Articles | Should -Be @('docs/gadgets/index.md', 'docs/gadgets/second.md')
        $runs.Status | Should -Be @('clean')
    }

    It 'holds each embedding page''s Supports line against the yml, refusing the one that disagrees' -Tag 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
        $folder = Join-Path $script:widgetRoot 'docs/gadgets/.assets'
        [System.IO.Directory]::CreateDirectory($folder) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $folder 'gadget.drawio.yml'),
            "about:`n  lens: architecture`n  rules: [ADR-WIDGET-GADGET]`ncontent: {}`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadgets/index.md'),
            "# Gadgets`n`nSupports ADR-WIDGET-GADGET (architecture lens).`n`n![Gadget](.assets/gadget.drawio.png)`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadgets/second.md'),
            "# Second`n`nSupports ADR-WIDGET-COG (architecture lens).`n`n![Gadget again](.assets/gadget.drawio.png)`n")
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked }
        $message = try {
            & $script:build @{ Path = 'docs/gadgets/.assets/gadget' }; ''
        }
        catch {
            $_.Exception.Message
        }
        $message |
            Should -BeLike '*E_SUPPORTS docs/gadgets/second.md says Supports ADR-WIDGET-COG (architecture lens) for docs/gadgets/.assets/gadget; its yml says ADR-WIDGET-GADGET (architecture lens)*'
        $message | Should -Not -BeLike '*docs/gadgets/index.md says*'
    }

    It 'gives an untracked declaration its first put, named by the yml itself' {
        $source = Join-Path $script:widgetRoot 'docs/widgets/.assets/sprocket.drawio.yml'
        [System.IO.Directory]::CreateDirectory((Split-Path $source -Parent)) | Out-Null
        [System.IO.File]::WriteAllText($source, "content: {}`n")
        $page = Join-Path $script:widgetRoot 'docs/widgets/sprocket.md'
        [System.IO.File]::WriteAllText($page, "# Sprocket`n`n![Sprocket](.assets/sprocket.drawio.png)`n")
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides { 'docs/widgets/.assets/sprocket.drawio.yml' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { @($script:tracked) + 'docs/widgets/sprocket.md' }
        try {
            $runs = @(& $script:build @{ Path = 'docs/widgets/.assets/sprocket.drawio.yml' })
            $runs.Folder | Should -Be @('docs/widgets/.assets/sprocket')
            $runs.Status | Should -Be @('clean')
        }
        finally {
            [System.IO.File]::Delete($page)
        }
    }

    It 'refuses a path that is not a diagram' {
        { & $script:build @{ Path = 'docs/widgets/.assets' } } | Should -Throw '*is not a diagram (*'
    }

    It 'finds a diagram an article declares before its first put, from its block, and writes its minimap data from the block' -Tag 'ADR-REPO-SLIDES-DECLARATION' {
        $page = Join-Path $script:widgetRoot 'docs/gizmos/cog.md'
        [System.IO.File]::WriteAllText($page,
            "# Cog`n`n``````yml drawio`nabout: { lens: architecture, rules: [ADR-WIDGET-GADGET] }`ncontent: {}`n```````n`n![Cog](.assets/cog.drawio.png)`n")
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides { 'docs/gizmos/cog.md' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { @($script:tracked) + 'docs/gizmos/cog.md' }
        Mock Write-DiagramMinimapData -ModuleName Catzc.Base.Slides { foreach ($item in $Stem) {
                "out/minimaps/$item"
            } }
        try {
            $runs = @(& $script:build @{ Path = 'docs/gizmos/.assets/cog' })
            $runs.Folder | Should -Be @('docs/gizmos/.assets/cog')
            Should -Invoke Write-DiagramMinimapData -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter { @($Stem) -ceq 'docs/gizmos/.assets/cog' }
        }
        finally {
            [System.IO.File]::Delete($page)
        }
    }

    It 'lists the calls per folder under -DryRun and runs none' -Tag 'ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT' {
        $runs = @(& $script:build @{ DryRun = $true; Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b' })
        $runs.Count | Should -Be 2
        @($runs.Status | Sort-Object -Unique) | Should -Be @('dry-run')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Slides -Times 0
    }

    It 'stops on the renderer findings, takes nothing to render as done, and stops on any other exit' {
        $one = @{ Path = 'docs/widgets/.assets/widget-a' }
        $script:row = { param($exit) @{ diagram = (Join-Path $script:widgetRoot 'docs/widgets/.assets/widget-a'); exit = $exit } | ConvertTo-Json -Compress }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 2; Output = (& $script:row 2) } }
        { & $script:build $one } | Should -Throw '*reported findings on docs/widgets/.assets/widget-a, each an error*'
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 3; Output = (& $script:row 3) } }
        @(& $script:build $one).Status | Should -Be @('nothing')
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 1; Output = "line one`nTraceback: widget" } }
        { & $script:build $one } |
            Should -Throw '*renderer failed on docs/widgets/.assets/widget-a (exit 1)*Traceback: widget*'
    }

    It 'stamps every png the renderer delivered through the one head renderer, findings included, and none it did not' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        $script:exitOf = @{ 'widget-a' = 0; 'widget-b' = 2; 'gizmo' = 3 }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
            $rows = @([regex]::Matches(($Command -split '--all ', 2)[1], '"([^"]+)"') | ForEach-Object {
                    @{ diagram = $_.Groups[1].Value; exit = $script:exitOf[(Split-Path $_.Groups[1].Value -Leaf)] } | ConvertTo-Json -Compress
                })
            [pscustomobject]@{ ExitCode = 2; Output = $rows -join "`n" }
        }
        { & $script:build @{ Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b', 'docs/gizmos/.assets/gizmo' } } |
            Should -Throw '*reported findings on docs/widgets/.assets/widget-b*'
        foreach ($stamped in 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b') {
            Should -Invoke Set-GeneratedFileHead -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
                $Writer -ceq 'Build-Diagrams' -and $Path -ceq (Join-Path $script:widgetRoot "$stamped.drawio.png")
            }
        }
        Should -Invoke Set-GeneratedFileHead -ModuleName Catzc.Base.Slides -Times 2 -Exactly
    }

    It 'stops when the kit has no renderer' {
        { Build-Diagrams -Kit missing -RepositoryRoot $script:widgetRoot } | Should -Throw '*no drawio_forward.py*'
    }

    Context '-FromDrawing' -Tag 'ADR-REPO-SLIDES-CONFLICTNEEDSAPICK' {
        BeforeAll {
            $source = Join-Path $script:widgetRoot 'docs/widgets/.assets/widget-b.drawio.yml'
            [System.IO.Directory]::CreateDirectory((Split-Path $source -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($source, "content: {}`n")
        }

        BeforeEach {
            Mock Test-Diagrams -ModuleName Catzc.Base.Slides { }
        }

        It 'syncs a folder after a draw.io edit through the kit''s sync, then runs the drift gate on it' {
            Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
                [pscustomobject]@{ ExitCode = 0; Output = '{"diagram": "docs/widgets/.assets/widget-b", "ran": ["get", "put"]}' }
            }
            $runs = @(& $script:build @{ Path = 'docs/widgets/.assets/widget-b'; FromDrawing = $true })
            $runs.Stage | Should -Be @('sync (get, put)')
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
                $Command -like '*python -m catzc.kit.declaration sync "docs/widgets/.assets/widget-b"'
            }
            Should -Invoke Test-Diagrams -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter { $Path -ceq 'docs/widgets/.assets/widget-b' }
            # The put wrote the png bare, so it is stamped through the one head renderer.
            Should -Invoke Set-GeneratedFileHead -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
                $Writer -ceq 'Build-Diagrams' -and $Path -ceq (Join-Path $script:widgetRoot 'docs/widgets/.assets/widget-b.drawio.png')
            }
        }

        It 'stops on a conflict before put, naming the cells, and runs no drift gate' {
            Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
                [pscustomobject]@{ ExitCode = 0; Output = '{"diagram": "docs/widgets/.assets/widget-b", "error": "the yml and the png both moved from HEAD and disagree in widget-a"}' }
            }
            { & $script:build @{ Path = 'docs/widgets/.assets/widget-b'; FromDrawing = $true } } |
                Should -Throw '*sync of docs/widgets/.assets/widget-b stopped*disagree in widget-a*'
            Should -Invoke Test-Diagrams -ModuleName Catzc.Base.Slides -Times 0 -Exactly
        }

        It 'syncs only the diagrams it is given' {
            { & $script:build @{ FromDrawing = $true } } | Should -Throw '*-FromDrawing syncs the diagrams it is given*'
        }

        It 'refuses a diagram without a declaration' {
            { & $script:build @{ Path = 'docs/widgets/.assets/widget-a'; FromDrawing = $true } } |
                Should -Throw '*widget-a has no declaration to sync*'
        }
    }

    Context '-Stale' -Tag 'ADR-REPO-SLIDES-TWODIRECTIONS' {
        It 'rebuilds only the diagrams Test-Diagrams reports stale' {
            Mock Test-Diagrams -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Facts = @{ StaleDiagrams = @('docs/widgets/.assets/widget-b') } } }
            $runs = @(& $script:build @{ Stale = $true })
            $runs.Folder | Should -Be @('docs/widgets/.assets/widget-b')
        }

        It 'writes no minimap data of its own, since Test-Diagrams has just written it' {
            Mock Test-Diagrams -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Facts = @{ StaleDiagrams = @('docs/widgets/.assets/widget-b') } } }
            $null = @(& $script:build @{ Stale = $true })
            Should -Invoke Write-DiagramMinimapData -ModuleName Catzc.Base.Slides -Times 0 -Exactly
        }

        It 'rebuilds nothing when no minimap is stale' {
            Mock Test-Diagrams -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Facts = @{ StaleDiagrams = @() } } }
            @(& $script:build @{ Stale = $true }) | Should -BeNullOrEmpty
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0 -Exactly
        }

        It 'finds its diagrams itself' {
            { & $script:build @{ Stale = $true; Path = 'docs/widgets/.assets/widget-b' } } |
                Should -Throw '*-Stale finds its diagrams itself*'
        }
    }
}
