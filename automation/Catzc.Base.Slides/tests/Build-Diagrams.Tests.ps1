Describe 'Build-Diagrams' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'diagram-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'kit')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'kit/drawio_forward.py'), "# renderer stand-in`n")
    }

    BeforeEach {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides {
            'docs/widgets/.assets/a.drawio.png', 'docs/widgets/.assets/b.drawio.png', 'docs/widgets/.assets/c.drawio.png',
            'docs/gadgets/.assets/d.drawio.png', 'docs/gadgets/.assets/d.drawio.md', 'docs/gadgets/plain.md'
        }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Found = $true; Path = 'C:/tools/uv.exe' } }
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 0; Output = '' } }
        Mock Write-Message -ModuleName Catzc.Base.Slides { }
        $script:build = {
            param([hashtable] $Arguments = @{})
            Build-Diagrams -Kit kit -RepositoryRoot $script:widgetRoot -PassThru @Arguments
        }
    }

    It 'renders every folder that holds a tracked slide, prepare once, then highlight and join in slices of the batch' {
        $runs = @(& $script:build @{ Batch = 2 })
        @($runs | ForEach-Object { "$($_.Folder) $($_.Stage) $($_.Start)..$($_.End)" }) | Should -Be @(
            'docs/gadgets/.assets prepare ..', 'docs/gadgets/.assets highlight 0..1', 'docs/gadgets/.assets join 0..1',
            'docs/widgets/.assets prepare ..', 'docs/widgets/.assets highlight 0..2', 'docs/widgets/.assets highlight 2..3',
            'docs/widgets/.assets join 0..2', 'docs/widgets/.assets join 2..3')
        @($runs.Status | Sort-Object -Unique) | Should -Be @('clean')
    }

    It 'calls the kit''s renderer through uv with Pillow, the folder absolute, one stage and one slice per call' {
        & $script:build @{ Folder = 'docs/widgets/.assets'; Stage = 'highlight'; Batch = 5 } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
            $Command -like '"C:/tools/uv.exe" run --with pillow python "*kit*drawio_forward.py" --all "*docs*widgets*.assets" --stage highlight --start 0 --end 3'
        }
    }

    It 'lists the calls under -DryRun and runs none' -Tag 'ADR-AUTO-DRYRUN#2' {
        $runs = @(& $script:build @{ DryRun = $true; Stage = 'prepare' })
        $runs.Count | Should -Be 2
        @($runs.Status | Sort-Object -Unique) | Should -Be @('dry-run')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Slides -Times 0
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Slides -Times 0
    }

    It 'reports warnings and goes on, takes nothing to render as done, and stops on any other exit' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 2; Output = '' } }
        @(& $script:build @{ Folder = 'docs/gadgets/.assets'; Stage = 'join' }).Status | Should -Be @('warnings')
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -ParameterFilter { $Warning } -Times 1 -Exactly
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 3; Output = '' } }
        @(& $script:build @{ Folder = 'docs/gadgets/.assets'; Stage = 'join' }).Status | Should -Be @('nothing')
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ ExitCode = 1; Output = "line one`nTraceback: widget" } }
        { & $script:build @{ Folder = 'docs/gadgets/.assets'; Stage = 'join' } } | Should -Throw '*renderer failed on docs/gadgets/.assets, stage join (exit 1)*Traceback: widget*'
    }

    It 'skips a named folder that holds no tracked slide' {
        @(& $script:build @{ Folder = 'docs/plain' }).Count | Should -Be 0
    }

    It 'stops when the kit has no renderer' {
        { Build-Diagrams -Kit missing -RepositoryRoot $script:widgetRoot } | Should -Throw '*no drawio_forward.py*'
    }
}
