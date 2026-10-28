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

    It 'runs the regenerate command of a due writer that is no command of the session, then stamps it' {
        $kept = $script:rows
        try {
            $script:rows = @(
                [Catzc.Base.Variants.GeneratedWriterRow]::new('gadget_kit.py', [ordered]@{ class = 'rollable'; regenerate = 'uv run gadget'; inputs = @('gadget.yml'); outputs = @('gadgets/*.svg') })
                [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{ class = 'rollable'; inputs = @('gadgets/*.svg'); outputs = @('docs/index.md') })
            )
            $script:dueNames = @('gadget_kit.py')
            Mock Invoke-GeneratedWriterRegenerate -ModuleName Catzc.Base.GeneratedFiles { }
            @(& $script:run) | Should -Be @('gadget_kit.py')
            Should -Invoke Invoke-GeneratedWriterRegenerate -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly -ParameterFilter {
                $Writer.name -ceq 'gadget_kit.py' -and $RepositoryRoot -ceq 'widget-root' -and @($Writers | ForEach-Object name).Count -eq 2
            }
            Should -Invoke Save-GeneratedWriterStamp -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly -ParameterFilter { $Name -ceq 'gadget_kit.py' }
        }
        finally {
            $script:rows = $kept
        }
    }

    It 'throws, naming the writer, when a due writer is no command of the session and has no regenerate command' {
        $kept = $script:rows
        try {
            $script:rows = @([Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Ghost', [ordered]@{ class = 'rollable'; inputs = @('ghost/**'); outputs = @('docs/ghost.md') }))
            $script:dueNames = @('Build-Ghost')
            { & $script:run } | Should -Throw "*'Build-Ghost' is not a command in this session and its row has no regenerate command*"
        }
        finally {
            $script:rows = $kept
        }
    }
}

Describe 'Restore-Generated (shipped writer registry)' -Tag 'L1', 'integrity', 'ADR-REPO-ROOTCFG-ROLLOFFROUNDTRIP' {
    It 'gives every rollable writer a way to run: a command of the session, or a regenerate command whose tool tools.yml declares' {
        $tools = Get-Config -Config tools
        $withoutRun = @(Get-GeneratedWriterOrder | Where-Object { $_.class -ceq 'rollable' } | Where-Object {
                -not (Get-Command $_.name -ErrorAction Ignore) -and
                (-not $_.regenerate -or $null -eq $tools[($_.regenerate.Trim() -split '\s+', 2)[0]])
            } | ForEach-Object name)
        $withoutRun | Should -BeNullOrEmpty
    }

    It 'runs every rollable writer that is a command with no argument: none has a mandatory parameter' {
        $needsArguments = @(Get-GeneratedWriterOrder | Where-Object { $_.class -ceq 'rollable' } |
                ForEach-Object { Get-Command $_.name -ErrorAction Ignore } |
                Where-Object { $_.CommandType -in 'Function', 'Cmdlet', 'ExternalScript' } | ForEach-Object {
                    $mandatory = @($_.Parameters.Values | Where-Object {
                            @($_.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }).Count
                        } | ForEach-Object Name)
                    if ($mandatory.Count) {
                        "$($_.Name) -$($mandatory -join ' -')"
                    }
                })
        $needsArguments | Should -BeNullOrEmpty
    }
}
