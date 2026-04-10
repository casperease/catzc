Describe 'Copy-Automation' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # UTF-8 without BOM — for the two It blocks that seed a stray/conflicting file into the destination.
        $script:utf8 = [System.Text.UTF8Encoding]::new($false)

        # Fake repo root (source): named + hidden module folders, and root artifacts (packages) — via TestKit.
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Alpha'      = @{ Public = 'Get-Alpha' }
            '.vendor'               = @{ Files = @{ 'PkgX/x.psm1' = '# vendor' } }
            '.internal'             = @{ Files = @{ 'Catzc.Internal.Bootstrap.psm1' = '# bootstrap' } }
            'Catzc.Base.Repository' = @{ Public = 'Get-Repo' }
        } -Files @{
            'importer.ps1'  = '# importer'
            '.editorconfig' = 'root = true'
            '.gitignore'    = 'out/'
        }

        Mock Write-Message -ModuleName Catzc.Base.ModuleSystem { }
        Mock Get-BaseModule -ModuleName Catzc.Base.ModuleSystem {
            @(
                [Catzc.Base.ModuleSystem.DiskModule]::new('Catzc.Base.Alpha', 'automation/Catzc.Base.Alpha', $false, @())
                [Catzc.Base.ModuleSystem.DiskModule]::new('.vendor', 'automation/.vendor', $true, @())
                [Catzc.Base.ModuleSystem.DiskModule]::new('.internal', 'automation/.internal', $true,
                    @([Catzc.Base.ModuleSystem.ModulePackage]::new('entrypoint', [string[]] @('importer.ps1'))))
                [Catzc.Base.ModuleSystem.DiskModule]::new('Catzc.Base.Repository', 'automation/Catzc.Base.Repository', $false,
                    @(
                        [Catzc.Base.ModuleSystem.ModulePackage]::new('root_configs', [string[]] @('.editorconfig'))
                        [Catzc.Base.ModuleSystem.ModulePackage]::new('gitignore', [string[]] @('.gitignore'))
                    ))
            )
        }

        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ profiles = [ordered]@{ demo = @('Catzc.Base.Alpha') } }
        }
        Mock Get-ModuleProfile -ModuleName Catzc.Base.ModuleSystem { @('Catzc.Base.Alpha') }

        $script:newDest = { Join-Path $script:fake.Root ('_dest_' + [guid]::NewGuid().ToString('N')) }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'copies every module folder and package by default' {
        $dest = & $script:newDest
        Copy-Automation -Destination $dest -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeTrue
        Test-Path (Join-Path $dest 'automation/.vendor/PkgX/x.psm1') | Should -BeTrue
        Test-Path (Join-Path $dest 'automation/.internal/Catzc.Internal.Bootstrap.psm1') | Should -BeTrue
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Repository/Get-Repo.ps1') | Should -BeTrue
        Test-Path (Join-Path $dest 'importer.ps1') | Should -BeTrue        # .internal/entrypoint package
        Test-Path (Join-Path $dest '.editorconfig') | Should -BeTrue       # Repository/root_configs package
        Test-Path (Join-Path $dest '.gitignore') | Should -BeTrue          # Repository/gitignore package
    }

    It 'drops a single package by name (-ExcludePackages) but keeps the module and its other packages' {
        $dest = & $script:newDest
        Copy-Automation -Destination $dest -ExcludePackages gitignore -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Repository/Get-Repo.ps1') | Should -BeTrue
        Test-Path (Join-Path $dest '.editorconfig') | Should -BeTrue
        Test-Path (Join-Path $dest '.gitignore') | Should -BeFalse
    }

    It 'copies only the named module (with its packages)' {
        $dest = & $script:newDest
        Copy-Automation -Destination $dest -ModuleNames Catzc.Base.Alpha -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeTrue
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Repository') | Should -BeFalse
        Test-Path (Join-Path $dest 'importer.ps1') | Should -BeFalse
    }

    It 'with -DryRun writes nothing but returns the plan' {
        $dest = & $script:newDest
        $copied = Copy-Automation -Destination $dest -DryRun
        Test-Path $dest | Should -BeFalse
        @($copied).Count | Should -BeGreaterThan 0
    }

    It 'with -EmptyDestination throws when the target is not empty' {
        $dest = & $script:newDest
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $dest 'stray.txt'), 'x', $script:utf8)
        { Copy-Automation -Destination $dest -EmptyDestination } | Should -Throw '*not empty*'
    }

    It 'throws on a pre-existing conflict by default; -Force overwrites' {
        $dest = & $script:newDest
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $dest '.editorconfig'), 'OLD', $script:utf8)
        { Copy-Automation -Destination $dest } | Should -Throw '*already exist*'
        Copy-Automation -Destination $dest -Force | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $dest '.editorconfig')) | Should -Be 'root = true'
    }

    It 'throws on an unknown package name (ValidateScript)' {
        $dest = & $script:newDest
        { Copy-Automation -Destination $dest -ExcludePackages nope } | Should -Throw
    }

    It 'accepts a -ModuleProfile and copies its resolved module set' {
        $dest = & $script:newDest
        Copy-Automation -Destination $dest -ModuleProfile demo -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeTrue
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Repository') | Should -BeFalse
    }
}
