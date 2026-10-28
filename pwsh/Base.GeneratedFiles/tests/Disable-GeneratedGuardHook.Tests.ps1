Describe 'Disable-GeneratedGuardHook' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive "widget-repo-$([guid]::NewGuid())"
        $script:hooks = Join-Path $script:repo 'custom-hooks'
        $script:hook = Join-Path $script:hooks 'pre-commit'
        Mock Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ Output = "custom-hooks`n" } }
        New-Item -ItemType Directory -Path $script:hooks -Force | Out-Null
    }

    It 'removes the shim Enable-GeneratedGuardHook wrote and returns its path' {
        Enable-GeneratedGuardHook -RepositoryRoot $script:repo | Out-Null
        Disable-GeneratedGuardHook -RepositoryRoot $script:repo | Should -Be ([System.IO.Path]::GetFullPath($script:hook))
        [System.IO.File]::Exists($script:hook) | Should -BeFalse
    }

    It 'does nothing when no pre-commit hook exists' {
        Disable-GeneratedGuardHook -RepositoryRoot $script:repo | Should -BeNullOrEmpty
    }

    It 'refuses a foreign pre-commit hook and leaves it in place' {
        [System.IO.File]::WriteAllText($script:hook, "#!/bin/sh`necho gadget`n")
        { Disable-GeneratedGuardHook -RepositoryRoot $script:repo } | Should -Throw '*did not write*'
        [System.IO.File]::Exists($script:hook) | Should -BeTrue
    }

    It 'removes nothing with -WhatIf' {
        Enable-GeneratedGuardHook -RepositoryRoot $script:repo | Out-Null
        Disable-GeneratedGuardHook -RepositoryRoot $script:repo -WhatIf | Out-Null
        [System.IO.File]::Exists($script:hook) | Should -BeTrue
    }
}
