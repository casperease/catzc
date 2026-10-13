# Hermetic logic (L1): the tool manager (Install-Tool), the installed-version probe, command resolution and the
# persistent user environment (Set-PermanentEnvironmentVariable) are mocked; the JDK layout is a fixture under
# $TestDrive. The real registry round trip is the seam's own L3 system test
# (Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1).
Describe 'Install-Java' -Tag 'L1', 'logic' {
    BeforeAll {
        # The managed body sets the session JAVA_HOME — restore it so the test leaves the process as it found it.
        $script:savedProcessJavaHome = $env:JAVA_HOME

        # A fixture JDK: <jdk>/bin/java(.exe), so the binary's grandparent is the home.
        $script:jdkHome = Join-Path $TestDrive 'jdk-21.0.4.7-hotspot'
        $script:javaExe = Join-Path $script:jdkHome 'bin/java.exe'
        [System.IO.Directory]::CreateDirectory((Split-Path $script:javaExe)) | Out-Null
        [System.IO.File]::WriteAllText($script:javaExe, '')
    }
    AfterAll {
        $env:JAVA_HOME = $script:savedProcessJavaHome
    }
    BeforeEach {
        $env:JAVA_HOME = $null
        Mock Get-ToolConfig {
            [Catzc.Tooling.Core.ToolConfig]::new(@{ version = '21'; command = 'java'; version_command = 'java -version'; version_pattern = '(?<ver>.+)' })
        } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { $null } -ModuleName Catzc.Tooling.Toolchain
        Mock Install-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-Command { [pscustomobject]@{ Source = $script:javaExe } } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Name -eq 'java' }
        # The winget JDK folder under %LOCALAPPDATA%\Programs\Microsoft: none by default (the fallback path).
        Mock Get-ChildItem { } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Filter -like 'jdk-*' }
        Mock Set-PermanentEnvironmentVariable { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'does nothing when the locked version is already installed' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '21.0.4' } -ModuleName Catzc.Tooling.Toolchain
        Install-Java
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Message -eq 'Java 21 is already installed' }
    }

    It 'installs the locked version through the tool manager, passing -Force on' {
        Install-Java -Force
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter {
            $Tool -eq 'java' -and $Version -eq '21' -and $Force
        }
    }

    It 'installs an explicit -Version over the locked one' {
        Install-Java -Version '17'
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Version -eq '17' }
    }

    It 'stops before any environment setup when no java command resolves after the install' {
        Mock Get-Command { $null } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Name -eq 'java' }
        Install-Java
        $env:JAVA_HOME | Should -BeNullOrEmpty
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'sets JAVA_HOME from the binary''s home, for the session and through the persistent seam (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
            return
        }
        Install-Java
        $env:JAVA_HOME | Should -Be $script:jdkHome
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Message -eq "Session: JAVA_HOME='$script:jdkHome'" }
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'JAVA_HOME' -and $Value -eq $script:jdkHome
        }
    }

    It 'prefers the winget JDK folder for the version when one exists (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
            return
        }
        $wingetJdk = Join-Path $TestDrive 'Programs/Microsoft/jdk-21.0.5.11-hotspot'
        [System.IO.Directory]::CreateDirectory($wingetJdk) | Out-Null
        Mock Get-ChildItem { Get-Item -LiteralPath $wingetJdk } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Filter -like 'jdk-*' }
        Install-Java
        $env:JAVA_HOME | Should -Be $wingetJdk
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Value -eq $wingetJdk }
    }

    It 'leaves the session alone when JAVA_HOME already holds the home, and still persists it (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
            return
        }
        $env:JAVA_HOME = $script:jdkHome
        Install-Java
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 0 -ParameterFilter { $Message -like 'Session: JAVA_HOME=*' }
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 1
    }

    It 'skips the environment setup when the resolved home does not exist' {
        $missing = Join-Path $TestDrive 'gone/bin/java.exe'
        Mock Get-Command { [pscustomobject]@{ Source = $missing } } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Name -eq 'java' }
        Install-Java
        $env:JAVA_HOME | Should -BeNullOrEmpty
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }
}
