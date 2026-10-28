Describe 'Restore-Generated' -Tag 'L0', 'logic' {
    BeforeAll {
        # The writers are commands the session knows; the module's mocks stand in for them.
        foreach ($name in 'Build-Widget', 'Build-Gadget', 'Build-Sprocket', 'Build-Cog') {
            Set-Item -Path "function:global:$name" -Value { }
        }
        $script:rows = @(
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{ class = 'rollable'; inputs = @('widget/**'); outputs = @('docs/index.md') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Gadget', [ordered]@{ class = 'rollable'; inputs = @('docs/index.md'); outputs = @('docs/gadget.md') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Sprocket', [ordered]@{ class = 'import-critical'; inputs = @('.sprocket.yml'); outputs = @('.sprocket.yml') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Cog', [ordered]@{ class = 'rollable'; inputs = @('cogs/*.toml'); outputs = @('cogs/cog.lock') })
        )
        $script:run = {
            param([hashtable] $Splat = @{})
            InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Splat = $Splat } {
                param($Splat)
                Restore-Generated -RepositoryRoot 'widget-root' -MemoPath 'widget-memo.json' @Splat
            }
        }
    }

    AfterAll {
        foreach ($name in 'Build-Widget', 'Build-Gadget', 'Build-Sprocket', 'Build-Cog') {
            Remove-Item -Path "function:global:$name" -ErrorAction Ignore
        }
    }

    BeforeEach {
        $script:dueNames = @('Build-Widget', 'Build-Gadget', 'Build-Sprocket')
        Mock Get-GeneratedWriterOrder -ModuleName Catzc.Base.GeneratedFiles { $script:rows }
        Mock Get-GeneratedWriterDue -ModuleName Catzc.Base.GeneratedFiles {
            [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new($Name[0], $Name[0] -in $script:dueNames)
        }
        Mock Save-GeneratedWriterStamp -ModuleName Catzc.Base.GeneratedFiles { }
        foreach ($name in 'Build-Widget', 'Build-Gadget', 'Build-Sprocket', 'Build-Cog') {
            Mock $name -ModuleName Catzc.Base.GeneratedFiles { }
        }
    }

    It 'runs the due rollable writers in the registry order and stamps each after its run' {
        @(& $script:run) | Should -Be @('Build-Widget', 'Build-Gadget')
        Should -Invoke Save-GeneratedWriterStamp -ModuleName Catzc.Base.GeneratedFiles -Times 2 -Exactly
        Should -Invoke Build-Widget -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly
        Should -Invoke Build-Gadget -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly
    }

    It 'never runs a writer of another class, even when it is due' {
        @(& $script:run) | Should -Not -Contain 'Build-Sprocket'
        Should -Invoke Build-Sprocket -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'skips a rollable writer that is not due' {
        @(& $script:run) | Should -Not -Contain 'Build-Cog'
        Should -Invoke Build-Cog -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'limits the run to the writers named' {
        @(& $script:run @{ Name = 'Build-Gadget' }) | Should -Be @('Build-Gadget')
        Should -Invoke Build-Widget -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'runs nothing under -WhatIf' {
        @(& $script:run @{ WhatIf = $true }) | Should -BeNullOrEmpty
        Should -Invoke Build-Widget -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
        Should -Invoke Save-GeneratedWriterStamp -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'throws when a due writer is no command of the session' {
        $kept = $script:rows
        try {
            $script:rows = @([Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Ghost', [ordered]@{ class = 'rollable'; inputs = @('ghost/**'); outputs = @('docs/ghost.md') }))
            $script:dueNames = @('Build-Ghost')
            { & $script:run } | Should -Throw "*'Build-Ghost' is not a command*"
        }
        finally {
            $script:rows = $kept
        }
    }
}
