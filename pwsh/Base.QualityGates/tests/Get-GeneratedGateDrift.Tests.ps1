# A fixture repository is committed with real git, since the drift is read from its commits: L2.
Describe 'Get-GeneratedGateDrift' -Tag 'L2', 'logic', 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
    BeforeAll {
        $script:skip = if (Get-Command git -ErrorAction Ignore) {
            $null
        }
        else {
            'tool_git_missing'
        }
        $script:rows = @(
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Draw-Widget', [ordered]@{ class = 'rollable'; check = 'gate'; gate = 'Test-Widgets'; outputs = @('widget/*.png') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Render-Widget', [ordered]@{ class = 'rollable'; check = 'gate'; gate = 'Test-Widgets'; inputs = @('widget/*.png'); outputs = @('widget/*.slide.png') })
        )
        $script:generated = @(
            [Catzc.Base.Variants.GeneratedTarget]::new('widget/cog.png', 'Draw-Widget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('widget/cog.slide.png', 'Render-Widget', 'rollable')
        )
    }

    BeforeEach {
        if ($script:skip) {
            return
        }
        $script:widgetRoot = Join-Path $TestDrive "widget-repository-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'widget')) | Out-Null
        $script:commit = {
            param([string] $File, [string] $Text)
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $File), $Text)
            foreach ($command in 'git add -A', 'git -c user.name=widget -c user.email=widget@example.invalid commit --quiet --no-verify -m widget') {
                Invoke-Executable $command -WorkingDirectory $script:widgetRoot -Silent | Out-Null
            }
        }
        Invoke-Executable 'git init --quiet' -WorkingDirectory $script:widgetRoot -Silent | Out-Null
        & $script:commit 'widget/cog.png' 'picture one'
        & $script:commit 'widget/cog.slide.png' 'slide one'
        $script:drift = {
            param([string] $Name)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Name = $Name; Rows = $script:rows; Generated = $script:generated; Root = $script:widgetRoot } {
                param($Name, $Rows, $Generated, $Root)
                Get-GeneratedGateDrift -Writer ($Rows | Where-Object name -CEQ $Name | Select-Object -First 1) -Writers $Rows -Generated $Generated -RepositoryRoot $Root
            }
        }
    }

    It 'passes outputs committed after every generated input' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        @(& $script:drift 'Render-Widget') | Should -BeNullOrEmpty
        @(& $script:drift 'Draw-Widget') | Should -BeNullOrEmpty -Because 'the slide its broader glob also takes is the render''s, so it is no output of the picture writer'
    }

    It 'fails a stale output: a generated input committed after it, named by its writer' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        & $script:commit 'widget/cog.png' 'picture two'
        $reasons = @(& $script:drift 'Render-Widget')
        $reasons | Should -HaveCount 1
        $reasons[0] | Should -BeLike 'Draw-Widget committed its output in * after the last commit of these outputs'
    }

    It 'passes again once the output is committed anew' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        & $script:commit 'widget/cog.png' 'picture two'
        & $script:commit 'widget/cog.slide.png' 'slide two'
        @(& $script:drift 'Render-Widget') | Should -BeNullOrEmpty
    }
}
