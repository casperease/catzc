Describe 'Test-IsWslSession' -Tag 'L0', 'logic' {
    It 'is false outside Linux' {
        if ($IsLinux) {
            Set-ItResult -Skipped -Because 'windows_not_linux_host'; return
        }
        InModuleScope Catzc.Tooling.Provisioning { Test-IsWslSession } | Should -BeFalse
    }

    It 'is true on Linux when the WSL distribution variable is set' {
        if (-not $IsLinux) {
            Set-ItResult -Skipped -Because 'unix_only_wsl_detection'; return
        }
        $previous = $env:WSL_DISTRO_NAME
        try {
            $env:WSL_DISTRO_NAME = 'Ubuntu'
            InModuleScope Catzc.Tooling.Provisioning { Test-IsWslSession } | Should -BeTrue
        }
        finally {
            $env:WSL_DISTRO_NAME = $previous
        }
    }
}
