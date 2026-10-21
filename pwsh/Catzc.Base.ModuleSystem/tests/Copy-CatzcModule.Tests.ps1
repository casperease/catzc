<#
---
catzc:
  immutable:
    with_body_sha: e1b478f10ff4
  edges:
    code: pwsh/Catzc.Base.ModuleSystem/Copy-CatzcModule.ps1
---
#>

Describe 'Copy-CatzcModule' -Tag 'L0', 'logic' {
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

        $script:modules = Get-CatzcModulesFolder
        Mock Write-Message -ModuleName Catzc.Base.ModuleSystem { }
        # The fake root is not the loaded code root, so the run mode reads 'build'; the guard is the seam.
        Mock Assert-SourceTree -ModuleName Catzc.Base.ModuleSystem { }
        Mock Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem {
            'Catzc.Base.Alpha', 'Catzc.Base.Repository' | ForEach-Object {
                [Catzc.Base.Modules.Module]::new($_, 'widgets', 'widget-folder', $script:modules, "$($script:modules)/$_", 'folder', $null, $null, $null, $null)
            }
        }
        Mock Get-Track -ModuleName Catzc.Base.ModuleSystem { [Catzc.Base.Variants.VariantTrack]::new('widgets', @($script:modules), 'modules', $null, @()) }
        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Config -eq 'files' } {
            [Catzc.Base.ModuleSystem.FilesConfig]::new([ordered]@{ modules = [ordered]@{
                        '.internal'             = [ordered]@{ packages = [ordered]@{ entrypoint = @('importer.ps1') } }
                        'Catzc.Base.Repository' = [ordered]@{ packages = [ordered]@{ root_configs = @('.editorconfig'); gitignore = @('.gitignore') } }
                    }
                })
        }
        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Config -eq 'profiles' } {
            [pscustomobject]@{ profiles = [ordered]@{ demo = @('Catzc.Base.Alpha'); full = @() } }
        }
        Mock Get-ModuleProfile -ModuleName Catzc.Base.ModuleSystem { @('Catzc.Base.Alpha') }
        Mock Get-ModuleProfile -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Name -eq 'full' } {
            @('.internal', '.vendor', 'Catzc.Base.Alpha', 'Catzc.Base.Repository')
        }

        $script:newDest = { Join-Path $script:fake.Root ('_dest_' + [guid]::NewGuid().ToString('N')) }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'copies every module folder and package by default' {
        $dest = & $script:newDest
        Copy-CatzcModule -Destination $dest -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest "$($script:modules)/Catzc.Base.Alpha/Get-Alpha.ps1") | Should -BeTrue
        Test-Path (Join-Path $dest "$($script:modules)/.vendor/PkgX/x.psm1") | Should -BeTrue
        Test-Path (Join-Path $dest "$($script:modules)/.internal/Catzc.Internal.Bootstrap.psm1") | Should -BeTrue
        Test-Path (Join-Path $dest "$($script:modules)/Catzc.Base.Repository/Get-Repo.ps1") | Should -BeTrue
        Test-Path (Join-Path $dest 'importer.ps1') | Should -BeTrue        # .internal/entrypoint package
        Test-Path (Join-Path $dest '.editorconfig') | Should -BeTrue       # Repository/root_configs package
        Test-Path (Join-Path $dest '.gitignore') | Should -BeTrue          # Repository/gitignore package
    }

    It 'drops a single package by name (-ExcludePackages) but keeps the module and its other packages' {
        $dest = & $script:newDest
        Copy-CatzcModule -Destination $dest -ExcludePackages gitignore -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest "$($script:modules)/Catzc.Base.Repository/Get-Repo.ps1") | Should -BeTrue
        Test-Path (Join-Path $dest '.editorconfig') | Should -BeTrue
        Test-Path (Join-Path $dest '.gitignore') | Should -BeFalse
    }

    It 'copies only the named module (with its packages)' {
        $dest = & $script:newDest
        Copy-CatzcModule -Destination $dest -ModuleNames Catzc.Base.Alpha -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest "$($script:modules)/Catzc.Base.Alpha/Get-Alpha.ps1") | Should -BeTrue
        Test-Path (Join-Path $dest "$($script:modules)/Catzc.Base.Repository") | Should -BeFalse
        Test-Path (Join-Path $dest 'importer.ps1') | Should -BeFalse
    }

    It 'with -DryRun writes nothing but returns the plan' {
        $dest = & $script:newDest
        $copied = Copy-CatzcModule -Destination $dest -DryRun
        Test-Path $dest | Should -BeFalse
        @($copied).Count | Should -BeGreaterThan 0
    }

    It 'with -EmptyDestination throws when the target is not empty' {
        $dest = & $script:newDest
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $dest 'stray.txt'), 'x', $script:utf8)
        { Copy-CatzcModule -Destination $dest -EmptyDestination } | Should -Throw '*not empty*'
    }

    It 'throws on a pre-existing conflict by default; -Force overwrites' {
        $dest = & $script:newDest
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $dest '.editorconfig'), 'OLD', $script:utf8)
        { Copy-CatzcModule -Destination $dest } | Should -Throw '*already exist*'
        Copy-CatzcModule -Destination $dest -Force | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $dest '.editorconfig')) | Should -Be 'root = true'
    }

    It 'throws on an unknown package name (ValidateScript)' {
        $dest = & $script:newDest
        { Copy-CatzcModule -Destination $dest -ExcludePackages nope } | Should -Throw
    }

    It 'accepts a -ModuleProfile and copies its resolved module set' {
        $dest = & $script:newDest
        Copy-CatzcModule -Destination $dest -ModuleProfile demo -EmptyDestination | Out-Null
        Test-Path (Join-Path $dest "$($script:modules)/Catzc.Base.Alpha/Get-Alpha.ps1") | Should -BeTrue
        Test-Path (Join-Path $dest "$($script:modules)/Catzc.Base.Repository") | Should -BeFalse
    }
}

Describe 'Copy-CatzcModule — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package, before copying anything' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Mock Copy-Directory -ModuleName Catzc.Base.ModuleSystem { }
        { Copy-CatzcModule -Destination (Join-Path $TestDrive 'widget') -DryRun } | Should -Throw '*Copy-CatzcModule operates on the catzc source tree*'
        Should -Not -Invoke Copy-Directory -ModuleName Catzc.Base.ModuleSystem
    }
}
