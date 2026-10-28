Describe 'Enable-GeneratedGuardHook' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive "widget-repo-$([guid]::NewGuid())"
        $script:hooks = Join-Path $script:repo 'custom-hooks'
        $script:hook = Join-Path $script:hooks 'pre-commit'
        Mock Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ Output = "custom-hooks`n" } }
        New-Item -ItemType Directory -Path $script:repo -Force | Out-Null
    }

    It 'asks git where the hooks live, from the repository root' {
        Enable-GeneratedGuardHook -RepositoryRoot $script:repo | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly -ParameterFilter { $Command -eq 'git rev-parse --git-path hooks' }
    }

    It 'writes the shim with LF endings, the marker and the guard call, and returns its path' {
        $written = Enable-GeneratedGuardHook -RepositoryRoot $script:repo
        $written | Should -Be ([System.IO.Path]::GetFullPath($script:hook))
        $text = [System.IO.File]::ReadAllText($script:hook)
        $text | Should -BeLike '#!/bin/sh*'
        $text | Should -BeLike '*catzc-generated-guard-hook*'
        $text | Should -BeLike '*importer.ps1*Assert-GeneratedStaysCommitted*'
        $text | Should -Not -Match "`r"
    }

    It 'is idempotent when the shim is already there' {
        Enable-GeneratedGuardHook -RepositoryRoot $script:repo | Out-Null
        $before = [System.IO.File]::GetLastWriteTimeUtc($script:hook)
        Enable-GeneratedGuardHook -RepositoryRoot $script:repo | Should -BeNullOrEmpty
        [System.IO.File]::GetLastWriteTimeUtc($script:hook) | Should -Be $before
    }

    It 'rewrites a shim of its own whose body differs' {
        New-Item -ItemType Directory -Path $script:hooks -Force | Out-Null
        [System.IO.File]::WriteAllText($script:hook, "#!/bin/sh`n# catzc-generated-guard-hook: written by Enable-GeneratedGuardHook, removed by Disable-GeneratedGuardHook.`necho old`n")
        Enable-GeneratedGuardHook -RepositoryRoot $script:repo | Out-Null
        [System.IO.File]::ReadAllText($script:hook) | Should -BeLike '*Assert-GeneratedStaysCommitted*'
    }

    It 'refuses a foreign pre-commit hook and leaves it as it was' {
        New-Item -ItemType Directory -Path $script:hooks -Force | Out-Null
        [System.IO.File]::WriteAllText($script:hook, "#!/bin/sh`necho gadget`n")
        { Enable-GeneratedGuardHook -RepositoryRoot $script:repo } | Should -Throw '*did not write*'
        [System.IO.File]::ReadAllText($script:hook) | Should -Be "#!/bin/sh`necho gadget`n"
    }

    It 'writes nothing with -WhatIf' {
        Enable-GeneratedGuardHook -RepositoryRoot $script:repo -WhatIf | Should -BeNullOrEmpty
        [System.IO.File]::Exists($script:hook) | Should -BeFalse
    }

    It 'throws when git names no hooks folder' {
        Mock Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ Output = '' } }
        { Enable-GeneratedGuardHook -RepositoryRoot $script:repo } | Should -Throw '*named no hooks folder*'
    }
}
