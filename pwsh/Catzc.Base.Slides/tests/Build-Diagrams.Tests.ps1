Describe 'Build-Diagrams' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES#7' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'diagram-repository'
        $pages = [ordered]@{
            'kit/drawio_forward.py'  = "# renderer stand-in`n"
            'docs/widgets/index.md'  = "# Widgets`n`n![Widget A](.assets/widget-a/diagram.drawio.png)`n`n![Widget B](./.assets/widget-b/diagram.drawio.png)`n"
            'docs/widgets/plain.md'  = "# Plain`n`n[a link](.assets/widget-a/diagram.drawio.md)`n"
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
            'docs/widgets/.assets/widget-a/diagram.drawio.png', 'docs/widgets/.assets/widget-a/diagram.drawio.md', 'docs/widgets/.assets/widget-a/grid.png',
            'docs/widgets/.assets/widget-b/diagram.drawio.png', 'docs/gadgets/.assets/gadget/diagram.drawio.png',
            'docs/gizmos/.assets/gizmo/diagram.drawio.png', 'docs/widgets/.assets/loose.drawio.png')
    }

    BeforeEach {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked | Where-Object { $_ -notlike 'docs/gadgets/*' } }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Found = $true; Path = 'C:/tools/uv.exe' } }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 0; Output = '' } }
        Mock Write-Message -ModuleName Catzc.Base.Slides { }
        $script:build = {
            param([hashtable] $Arguments = @{})
            Build-Diagrams -Kit kit -RepositoryRoot $script:widgetRoot -PassThru @Arguments
        }
    }

    It 'rebuilds one diagram folder, every stage, with its article found beside its .assets' {
        $runs = @(& $script:build @{ Path = 'docs/widgets/.assets/widget-a' })
        @($runs | ForEach-Object { "$($_.Folder) $($_.Stage)" }) | Should -Be @(
            'docs/widgets/.assets/widget-a prepare', 'docs/widgets/.assets/widget-a highlight', 'docs/widgets/.assets/widget-a join')
        @($runs.Article | Sort-Object -Unique) | Should -Be @('docs/widgets/index.md')
        @($runs.Status | Sort-Object -Unique) | Should -Be @('clean')
    }

    It 'with no path, rebuilds every diagram folder under docs/**/.assets/**, and nothing that is not one' {
        $folders = @(& $script:build @{ Stage = 'prepare' }).Folder
        $folders | Should -Be @('docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b', 'docs/gizmos/.assets/gizmo')
    }

    It 'calls the kit''s renderer through uv with Pillow, the folder absolute, one stage per call' {
        & $script:build @{ Path = 'docs/widgets/.assets/widget-b'; Stage = 'highlight' } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
            $Command -like '"C:/tools/uv.exe" run --with pillow python "*kit*drawio_forward.py" --all "*docs*widgets*.assets*widget-b" --stage highlight'
        }
    }

    It 'reports an orphan and still renders it: the locality gate finds no article for a folder its page embeds from elsewhere' {
        $runs = @(& $script:build @{ Path = 'docs/gizmos/.assets/gizmo'; Stage = 'prepare' })
        $runs.Status | Should -Be @('clean')
        $runs[0].Article | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -ParameterFilter { $Warning -and $Message -like '*docs/gizmos/.assets/gizmo is an orphan*' } -Times 1 -Exactly
    }

    It 'fails when two pages embed one diagram' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides { $script:tracked }
        { & $script:build @{ Path = 'docs/gadgets/.assets/gadget' } } | Should -Throw '*embedded by 2 pages (docs/gadgets/index.md, docs/gadgets/second.md)*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0
    }

    It 'refuses a path that is not a diagram folder' {
        { & $script:build @{ Path = 'docs/widgets/.assets' } } | Should -Throw '*is not a diagram folder*'
    }

    It 'lists the calls per folder under -DryRun and runs none' -Tag 'ADR-AUTO-DRYRUN#2' {
        $runs = @(& $script:build @{ DryRun = $true; Path = 'docs/widgets/.assets/widget-a', 'docs/widgets/.assets/widget-b' })
        $runs.Count | Should -Be 6
        @($runs.Status | Sort-Object -Unique) | Should -Be @('dry-run')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Slides -Times 0
    }

    It 'reports warnings and goes on, takes nothing to render as done, and stops on any other exit' {
        $one = @{ Path = 'docs/widgets/.assets/widget-a'; Stage = 'join' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 2; Output = '' } }
        @(& $script:build $one).Status | Should -Be @('warnings')
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -ParameterFilter { $Warning } -Times 1 -Exactly
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 3; Output = '' } }
        @(& $script:build $one).Status | Should -Be @('nothing')
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 1; Output = "line one`nTraceback: widget" } }
        { & $script:build $one } | Should -Throw '*renderer failed on docs/widgets/.assets/widget-a, stage join (exit 1)*Traceback: widget*'
    }

    It 'stops when the kit has no renderer' {
        { Build-Diagrams -Kit missing -RepositoryRoot $script:widgetRoot } | Should -Throw '*no drawio_forward.py*'
    }
}
