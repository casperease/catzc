Describe 'Build-Diagrams' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'diagram-repository'
        $pages = [ordered]@{
            'kit/drawio_forward.py'  = "# renderer stand-in`n"
            'docs/widgets/index.md'  = "# Widgets`n`n![Widget A](.assets/widget-a/diagram.drawio.png)`n`n![Widget B](./.assets/widget-b/diagram.drawio.png)`n"
            'docs/widgets/plain.md'  = "# Plain`n`n[a link](.assets/widget-a/diagram.drawio.yml)`n"
            'docs/gadgets/index.md'  = "# Gadgets`n`n![Gadget](.assets/gadget/diagram.drawio.png)`n"
            'docs/gadgets/second.md' = "# Second`n`n![Gadget again](.assets/gadget/diagram.drawio.png)`n"
            'docs/gizmos/index.md'   = "# Gizmos`n`n![Elsewhere](../widgets/.assets/gizmo/diagram.drawio.png)`n"
        }
        foreach ($file in $pages.Keys) {
            $full = Join-Path $script:widgetRoot $file
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $pages[$file])
        }
        $script:tracked = @($pages.Keys | Where-Object { $_ -like 'docs/*' }) + @(
            'docs/widgets/.assets/widget-a/diagram.drawio.png', 'docs/widgets/.assets/widget-a/diagram.drawio.yml',
            'docs/widgets/.assets/widget-b/diagram.drawio.png', 'docs/gadgets/.assets/gadget/diagram.drawio.png',
            'docs/gizmos/.assets/gizmo/diagram.drawio.png', 'docs/widgets/.assets/loose.drawio.png')
    }

    BeforeEach {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked | Where-Object { $_ -notlike 'docs/gadgets/*' } }
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides { }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Found = $true; Path = 'C:/tools/uv.exe' } }
        Mock Write-DiagramMinimapData -ModuleName Catzc.Base.Slides { }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 0; Output = '' } }
        Mock Write-Message -ModuleName Catzc.Base.Slides { }
        $script:build = {
            param([hashtable] $Arguments = @{})
            Build-Diagrams -Kit kit -RepositoryRoot $script:widgetRoot -PassThru @Arguments
        }
    }

    It 'renders one diagram folder in one call, with the pages that embed it' {
        $runs = @(& $script:build @{ Path = 'docs/widgets/.assets/widget-a' })
        @($runs | ForEach-Object { "$($_.Folder) $($_.Stage)" }) | Should -Be @('docs/widgets/.assets/widget-a render')
        @($runs.Articles | Sort-Object -Unique) | Should -Be @('docs/widgets/index.md')
        @($runs.Status | Sort-Object -Unique) | Should -Be @('clean')
    }

    It 'with no path, rebuilds every diagram folder under docs/**/.assets/**, and nothing that is not one' {
        $folders = @(& $script:build).Folder
        $folders | Should -Be @('docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b', 'docs/gizmos/.assets/gizmo')
    }

    It 'calls the kit''s renderer through uv in the kit''s own project, the folder absolute, one call per folder' {
        & $script:build @{ Path = 'docs/widgets/.assets/widget-b' } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
            $Command -like '"C:/tools/uv.exe" run --project "*kit*" python "*kit*drawio_forward.py" --all "*docs*widgets*.assets*widget-b" --theme dark'
        }
    }

    It 'reports an orphan and still renders it: no page embeds its png' {
        $runs = @(& $script:build @{ Path = 'docs/gizmos/.assets/gizmo' })
        $runs.Status | Should -Be @('clean')
        $runs[0].Articles | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -ParameterFilter { $Warning -and $Message -like '*docs/gizmos/.assets/gizmo is an orphan*' } -Times 1 -Exactly
    }

    It 'finds every page that embeds one diagram, a second article included, and builds clean' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked }
        $runs = @(& $script:build @{ Path = 'docs/gadgets/.assets/gadget' })
        $runs[0].Articles | Should -Be @('docs/gadgets/index.md', 'docs/gadgets/second.md')
        $runs.Status | Should -Be @('clean')
    }

    It 'holds each embedding page''s Supports line against the yml, warning for the one that disagrees' -Tag 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
        $folder = Join-Path $script:widgetRoot 'docs/gadgets/.assets/gadget'
        [System.IO.Directory]::CreateDirectory($folder) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $folder 'diagram.drawio.yml'), "about:`n  lens: architecture`n  adrs: [ADR-WIDGET-GADGET]`ncontent: {}`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadgets/index.md'),
            "# Gadgets`n`nSupports ADR-WIDGET-GADGET (architecture lens).`n`n![Gadget](.assets/gadget/diagram.drawio.png)`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadgets/second.md'),
            "# Second`n`nSupports ADR-WIDGET-COG (architecture lens).`n`n![Gadget again](.assets/gadget/diagram.drawio.png)`n")
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked }
        $null = & $script:build @{ Path = 'docs/gadgets/.assets/gadget' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
            $Warning -and $Message -like '*docs/gadgets/second.md says Supports ADR-WIDGET-COG (architecture lens) for docs/gadgets/.assets/gadget; its yml says ADR-WIDGET-GADGET (architecture lens)*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -Times 0 -ParameterFilter { $Warning -and $Message -like '*docs/gadgets/index.md says*' }
    }

    It 'gives an untracked folder holding only its declaration its first put' {
        $source = Join-Path $script:widgetRoot 'docs/widgets/.assets/sprocket/diagram.drawio.yml'
        [System.IO.Directory]::CreateDirectory((Split-Path $source -Parent)) | Out-Null
        [System.IO.File]::WriteAllText($source, "content: {}`n")
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides { 'docs/widgets/.assets/sprocket/diagram.drawio.yml' }
        $runs = @(& $script:build @{ Path = 'docs/widgets/.assets/sprocket' })
        $runs.Folder | Should -Be @('docs/widgets/.assets/sprocket')
        $runs.Status | Should -Be @('clean')
    }

    It 'refuses a path that is not a diagram folder' {
        { & $script:build @{ Path = 'docs/widgets/.assets' } } | Should -Throw '*is not a diagram folder*'
    }

    It 'lists the calls per folder under -DryRun and runs none' -Tag 'ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT' {
        $runs = @(& $script:build @{ DryRun = $true; Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b' })
        $runs.Count | Should -Be 2
        @($runs.Status | Sort-Object -Unique) | Should -Be @('dry-run')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Slides -Times 0
    }

    It 'reports warnings and goes on, takes nothing to render as done, and stops on any other exit' {
        $one = @{ Path = 'docs/widgets/.assets/widget-a' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 2; Output = '' } }
        @(& $script:build $one).Status | Should -Be @('warnings')
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -ParameterFilter { $Warning } -Times 1 -Exactly
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 3; Output = '' } }
        @(& $script:build $one).Status | Should -Be @('nothing')
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 1; Output = "line one`nTraceback: widget" } }
        { & $script:build $one } | Should -Throw '*renderer failed on docs/widgets/.assets/widget-a (exit 1)*Traceback: widget*'
    }

    It 'stops when the kit has no renderer' {
        { Build-Diagrams -Kit missing -RepositoryRoot $script:widgetRoot } | Should -Throw '*no drawio_forward.py*'
    }

    Context '-FromDrawing' -Tag 'ADR-REPO-SLIDES-CONFLICTNEEDSAPICK' {
        BeforeAll {
            $source = Join-Path $script:widgetRoot 'docs/widgets/.assets/widget-b/diagram.drawio.yml'
            [System.IO.Directory]::CreateDirectory((Split-Path $source -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($source, "content: {}`n")
        }

        BeforeEach {
            Mock Test-Diagrams -ModuleName Catzc.Base.Slides { }
        }

        It 'syncs a folder after a draw.io edit through the kit''s sync, then runs the drift gate on it' {
            Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
                [pscustomobject]@{ ExitCode = 0; Output = '{"folder": "docs/widgets/.assets/widget-b", "ran": ["get", "put"]}' }
            }
            $runs = @(& $script:build @{ Path = 'docs/widgets/.assets/widget-b'; FromDrawing = $true })
            $runs.Stage | Should -Be @('sync (get, put)')
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
                $Command -like '*python "*kit*declaration.py" sync "docs/widgets/.assets/widget-b"'
            }
            Should -Invoke Test-Diagrams -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter { $Path -ceq 'docs/widgets/.assets/widget-b' }
        }

        It 'stops on a conflict before put, naming the cells, and runs no drift gate' {
            Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
                [pscustomobject]@{ ExitCode = 0; Output = '{"folder": "docs/widgets/.assets/widget-b", "error": "the yml and the png both moved from HEAD and disagree in widget-a"}' }
            }
            { & $script:build @{ Path = 'docs/widgets/.assets/widget-b'; FromDrawing = $true } } | Should -Throw '*sync of docs/widgets/.assets/widget-b stopped*disagree in widget-a*'
            Should -Invoke Test-Diagrams -ModuleName Catzc.Base.Slides -Times 0 -Exactly
        }

        It 'syncs only the folders it is given' {
            { & $script:build @{ FromDrawing = $true } } | Should -Throw '*-FromDrawing syncs the folders it is given*'
        }

        It 'refuses a folder without a declaration' {
            { & $script:build @{ Path = 'docs/widgets/.assets/widget-a'; FromDrawing = $true } } | Should -Throw '*widget-a has no diagram.drawio.yml to sync*'
        }
    }

    Context '-Stale' -Tag 'ADR-REPO-SLIDES-TWODIRECTIONS' {
        It 'rebuilds only the diagrams Test-Diagrams reports stale' {
            Mock Test-Diagrams -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Facts = @{ StaleFolders = @('docs/widgets/.assets/widget-b') } } }
            $runs = @(& $script:build @{ Stale = $true })
            $runs.Folder | Should -Be @('docs/widgets/.assets/widget-b')
        }

        It 'rebuilds nothing when no minimap is stale' {
            Mock Test-Diagrams -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Facts = @{ StaleFolders = @() } } }
            @(& $script:build @{ Stale = $true }) | Should -BeNullOrEmpty
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0 -Exactly
        }

        It 'finds its folders itself' {
            { & $script:build @{ Stale = $true; Path = 'docs/widgets/.assets/widget-b' } } | Should -Throw '*-Stale finds its folders itself*'
        }
    }
}
