Describe 'Install-Catzc' -Tag 'L0', 'logic' {
    BeforeEach {
        # A fixture build with neutral names; its integrity guard is a boundary here, tested on its own.
        $script:source = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))/Catzc/1.2.3"
        [System.IO.Directory]::CreateDirectory((Join-Path $source 'Catzc.Base.Widget')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $source 'Catzc.Base.Widget/Catzc.Base.Widget.ps1'),
            'function Get-Widget { }')
        [System.IO.File]::WriteAllText((Join-Path $source 'Import-Catzc.ps1'), @'
param([string] $RepositoryRoot, [switch] $AllowWarnings)
[System.IO.File]::WriteAllText((Join-Path $RepositoryRoot 'invoked.json'), (@{ From = $PSScriptRoot; RepositoryRoot = $RepositoryRoot; AllowWarnings = [bool] $AllowWarnings } | ConvertTo-Json))
'@)
        [System.IO.File]::WriteAllText((Join-Path $source 'build.json'),
            (@{ version = '1.2.3'; contentHash = 'aaa111' } | ConvertTo-Json))

        $script:root = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))"
        $script:userModules = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))"
        Mock Assert-CatzcBundle { } -ModuleName Catzc.Base.Exporter
        Mock Get-UserModulePath { $userModules } -ModuleName Catzc.Base.Exporter
        Mock Write-Message { } -ModuleName Catzc.Base.Exporter
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = "widget.yml`ngadget.yml"; Full = '' }
        } -ModuleName Catzc.Base.Exporter
    }

    It 'renders the root files through the root importer alone in one child process and reports the consumer targets on disk' {
        Mock Invoke-Executable {
            [System.IO.File]::WriteAllText((Join-Path $root 'widget.yml'), '')
            [pscustomobject]@{ ExitCode = 0; Output = "widget.yml`ngadget.yml"; Full = '' }
        } -ModuleName Catzc.Base.Exporter
        $result = Install-Catzc -Root $root -Source $source -Silent
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $Command -like 'pwsh -NoProfile -NonInteractive -Command *importer.ps1*Get-RootConfigTargets*-Consumer*' -and
            $Command -notlike '*Build-RootConfig*' -and
            $WorkingDirectory -eq $root
        }
        $result.RootConfigs | Should -Be @('widget.yml')
    }

    It 'throws with the child output when rendering the root files fails' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 1; Output = ''; Full = 'gadget asset missing' }
        } -ModuleName Catzc.Base.Exporter
        { Install-Catzc -Root $root -Source $source -Silent } | Should -Throw -ExpectedMessage '*gadget asset missing*'
    }

    It '-Scope CurrentUser and -DryRun render no root files' {
        Install-Catzc -Scope CurrentUser -Source $source -Silent | Out-Null
        Install-Catzc -Root $root -Source $source -DryRun -Silent | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Exporter -Times 0
    }

    It 'makes a shipped shell script with a shebang executable again on Unix, and leaves one without alone' -Skip:$IsWindows {
        $scripts = Join-Path $source 'Catzc.Base.Widget/assets/scripts'
        [System.IO.Directory]::CreateDirectory($scripts) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $scripts 'widget.sh'), "#!/usr/bin/env bash`necho widget`n")
        [System.IO.File]::WriteAllText((Join-Path $scripts 'gadget.sh'), "echo gadget`n")
        $null = Install-Catzc -Root $root -Source $source -Silent
        $installed = Join-Path $root '.vendor/Catzc/1.2.3/Catzc.Base.Widget/assets/scripts'
        [System.IO.File]::GetUnixFileMode((Join-Path $installed 'widget.sh')).HasFlag([System.IO.UnixFileMode]::UserExecute) | Should -BeTrue
        [System.IO.File]::GetUnixFileMode((Join-Path $installed 'gadget.sh')).HasFlag([System.IO.UnixFileMode]::UserExecute) | Should -BeFalse
    }

    It 'verifies the build before touching the destination' {
        Mock Assert-CatzcBundle { throw 'Catzc build is invalid' } -ModuleName Catzc.Base.Exporter
        { Install-Catzc -Root $root -Source $source -Silent } | Should -Throw -ExpectedMessage '*invalid*'
        Test-Path $root | Should -BeFalse
    }

    It 'a -Root install copies the build to .vendor/Catzc/1.2.3 and writes the importer at the root' {
        $result = Install-Catzc -Root $root -Source $source -Silent
        Should -Invoke Assert-CatzcBundle -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Path -eq $source }
        Test-Path (Join-Path $root '.vendor/Catzc/1.2.3/Catzc.Base.Widget/Catzc.Base.Widget.ps1') | Should -BeTrue
        Test-Path (Join-Path $root '.vendor/Catzc/1.2.3/build.json') | Should -BeTrue
        $result.Version | Should -Be '1.2.3'
        $result.ModulePath | Should -Be (Join-Path $root '.vendor/Catzc/1.2.3')
        $result.Importer | Should -Be (Join-Path $root 'importer.ps1')
        Test-Path $result.Importer | Should -BeTrue
    }

    It 'a -Root install writes a shell importer that names the importer and the lookup and sources the shipped asset' {
        Install-Catzc -Root $root -Source $source -Silent | Out-Null
        $full = ([System.IO.Path]::GetFullPath($root) -replace '\\', '/')
        $lines = @([System.IO.File]::ReadAllText((Join-Path $root 'importer.sh')) -split "`n")
        $lines | Should -Contain "export CATZC_IMPORTER='$full/importer.ps1'"
        $lines | Should -Contain "export CATZC_COMMAND_LOOKUP='$full/.vendor/Catzc/1.2.3/.internal/assets/importer-commands.sh'"
        $lines | Should -Contain ". '$full/.vendor/Catzc/1.2.3/Catzc.Base.RootConfig/assets/root/importer.sh'"
    }

    It 'a -Scope CurrentUser install writes no shell importer' {
        Install-Catzc -Scope CurrentUser -Source $source -Silent | Out-Null
        Test-Path (Join-Path $root 'importer.sh') | Should -BeFalse
    }

    It 'the root importer enters the installed Import-Catzc.ps1 with the destination as the working root' {
        Install-Catzc -Root $root -Source $source -Silent | Out-Null
        & { . (Join-Path $root 'importer.ps1') -AllowWarnings }
        $invoked = [System.IO.File]::ReadAllText((Join-Path $root 'invoked.json')) | ConvertFrom-Json
        $invoked.From | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $root '.vendor/Catzc/1.2.3')))
        $invoked.RepositoryRoot | Should -Be ([System.IO.Path]::GetFullPath($root))
        $invoked.AllowWarnings | Should -BeTrue
    }

    It 'is idempotent — a re-install of the same content keeps the module and reports already-current' {
        Install-Catzc -Root $root -Source $source -Silent | Out-Null
        $marker = Join-Path $root '.vendor/Catzc/1.2.3/marker.txt'
        [System.IO.File]::WriteAllText($marker, 'kept')
        $again = Install-Catzc -Root $root -Source $source
        $again.AlreadyCurrent | Should -BeTrue
        Test-Path $marker | Should -BeTrue
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Message -like 'Already current: Catzc 1.2.3*' }
    }

    It 're-copies cleanly on -Force or when the content hash differs' {
        Install-Catzc -Root $root -Source $source -Silent | Out-Null
        $marker = Join-Path $root '.vendor/Catzc/1.2.3/marker.txt'
        [System.IO.File]::WriteAllText($marker, 'wiped')
        (Install-Catzc -Root $root -Source $source -Force -Silent).AlreadyCurrent | Should -BeFalse
        Test-Path $marker | Should -BeFalse

        [System.IO.File]::WriteAllText($marker, 'wiped')
        [System.IO.File]::WriteAllText((Join-Path $source 'build.json'),
            (@{ version = '1.2.3'; contentHash = 'bbb222' } | ConvertTo-Json))
        (Install-Catzc -Root $root -Source $source -Silent).AlreadyCurrent | Should -BeFalse
        Test-Path $marker | Should -BeFalse
    }

    It '-Scope CurrentUser copies the build into the user module path, without a root importer' {
        $result = Install-Catzc -Scope CurrentUser -Source $source -Silent
        $result.ModulePath | Should -Be (Join-Path $userModules 'Catzc/1.2.3')
        $result.Importer | Should -BeNullOrEmpty
        Test-Path (Join-Path $userModules 'Catzc/1.2.3/Catzc.Base.Widget/Catzc.Base.Widget.ps1') | Should -BeTrue
    }

    It '-DryRun writes nothing' {
        Install-Catzc -Root $root -Source $source -DryRun | Out-Null
        Test-Path $root | Should -BeFalse
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Message -like 'Would install Catzc 1.2.3*' }
    }

    It 'defaults the source to the default bundle''s devbox build under the output root' {
        Mock Get-OutputRoot { Join-Path $TestDrive 'missing-out' } -ModuleName Catzc.Base.Exporter
        Mock Get-Config { [ordered]@{ direct_install_version = '6.6.666'; default_bundle = 'widgets' } } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Config -eq 'exporter' }
        Mock Assert-CatzcBundle { throw "no build at $Path" } -ModuleName Catzc.Base.Exporter
        { Install-Catzc -Root $root -Silent } |
            Should -Throw -ExpectedMessage "*$(Join-Path (Join-Path $TestDrive 'missing-out') 'pwsh/built/widgets/Catzc/6.6.666')*"
        { Install-Catzc -Root $root -Bundle gadgets -Silent } |
            Should -Throw -ExpectedMessage "*$(Join-Path (Join-Path $TestDrive 'missing-out') 'pwsh/built/gadgets/Catzc/6.6.666')*"
    }
}
