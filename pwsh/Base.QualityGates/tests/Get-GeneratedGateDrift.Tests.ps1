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

    Context 'a slide output, judged on its own slide and picture' {
        BeforeEach {
            if ($script:skip) {
                return
            }
            $script:slideRows = @(
                [Catzc.Base.Variants.GeneratedWriterRow]::new('Crop-Gadget', [ordered]@{ class = 'rollable'; check = 'gate'; gate = 'Test-Gadgets'; inputs = @('deck/*.slide.md', 'gadget/*.png'); outputs = @('deck/.assets/*.png') })
                [Catzc.Base.Variants.GeneratedWriterRow]::new('Frame-Gadget', [ordered]@{ class = 'rollable'; check = 'gate'; gate = 'Test-Gadgets'; inputs = @('deck/*.slide.md', 'deck/.assets/*.png'); outputs = @('deck/.assets/*.slide.png') })
            )
            $script:slideGenerated = @(
                [Catzc.Base.Variants.GeneratedTarget]::new('deck/.assets/one.png', 'Crop-Gadget', 'rollable')
                [Catzc.Base.Variants.GeneratedTarget]::new('deck/.assets/two.png', 'Crop-Gadget', 'rollable')
                [Catzc.Base.Variants.GeneratedTarget]::new('deck/.assets/one.slide.png', 'Frame-Gadget', 'rollable')
                [Catzc.Base.Variants.GeneratedTarget]::new('deck/.assets/two.slide.png', 'Frame-Gadget', 'rollable')
            )
            [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'deck/.assets')) | Out-Null
            [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'gadget')) | Out-Null
            foreach ($name in 'one', 'two') {
                & $script:commit "gadget/$name.png" "source $name"
                & $script:commit "deck/$name.slide.md" "---`ncatzc:`n  config:`n    picture:`n      source: ../gadget/$name.png`n---`n`n# Gadget $name`n`n## Image`n`n[$name](.assets/$name.png)`n"
                & $script:commit "deck/.assets/$name.png" "picture $name"
                & $script:commit "deck/.assets/$name.slide.png" "slide $name"
            }
            $script:slideDrift = {
                param([string] $Name)
                InModuleScope Catzc.Base.QualityGates -Parameters @{ Name = $Name; Rows = $script:slideRows; Generated = $script:slideGenerated; Root = $script:widgetRoot } {
                    param($Name, $Rows, $Generated, $Root)
                    Get-GeneratedGateDrift -Writer ($Rows | Where-Object name -CEQ $Name | Select-Object -First 1) -Writers $Rows -Generated $Generated -RepositoryRoot $Root
                }
            }
        }

        It 'passes when no slide input is newer than its output' {
            if ($script:skip) {
                Set-ItResult -Skipped -Because $script:skip; return
            }
            @(& $script:slideDrift 'Crop-Gadget') | Should -BeNullOrEmpty
            @(& $script:slideDrift 'Frame-Gadget') | Should -BeNullOrEmpty
        }

        It 'flags only the picture whose source changed' {
            if ($script:skip) {
                Set-ItResult -Skipped -Because $script:skip; return
            }
            & $script:commit 'gadget/two.png' 'source two, changed'
            $reasons = @(& $script:slideDrift 'Crop-Gadget')
            $reasons | Should -HaveCount 1
            $reasons[0] | Should -BeLike 'gadget/two.png committed in * after deck/.assets/two.png'
        }

        It 'flags only the slide whose picture changed' {
            if ($script:skip) {
                Set-ItResult -Skipped -Because $script:skip; return
            }
            & $script:commit 'deck/.assets/one.png' 'picture one, changed'
            $reasons = @(& $script:slideDrift 'Frame-Gadget')
            $reasons | Should -HaveCount 1
            $reasons[0] | Should -BeLike 'deck/.assets/one.png committed in * after deck/.assets/one.slide.png'
        }

        It 'flags the slide whose own file changed' {
            if ($script:skip) {
                Set-ItResult -Skipped -Because $script:skip; return
            }
            & $script:commit 'deck/two.slide.md' "---`ncatzc:`n  config:`n    picture:`n      source: ../gadget/two.png`n---`n`n# Gadget two, reworded`n`n## Image`n`n[two](.assets/two.png)`n"
            @(& $script:slideDrift 'Frame-Gadget') | Should -HaveCount 1
        }
    }
}
