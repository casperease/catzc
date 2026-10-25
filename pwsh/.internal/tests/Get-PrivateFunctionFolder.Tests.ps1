Describe 'Get-PrivateFunctionFolder' -Tag 'L1', 'integrity' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'reads the same private-function folder as LanguagesConfig.FolderOf' -Tag 'ADR-REPO-FOLDERS-NAMESARESETTINGS' {
        $root = Get-CatzcModulesRoot
        $early = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Get-PrivateFunctionFolder -ModulesRoot $Root }
        $early | Should -BeExactly (Get-Config -Config languages).FolderOf('private-function')
    }

    It 'throws naming languages.yml when the modules root has none' {
        $empty = Join-Path $TestDrive 'modules'
        [void][System.IO.Directory]::CreateDirectory($empty)
        { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $empty } { param($Root) Get-PrivateFunctionFolder -ModulesRoot $Root } } |
            Should -Throw '*languages.yml*does not exist*'
    }

    It 'throws naming the missing row when the powershell layout has no private-function role' {
        $root = Join-Path $TestDrive 'norow'
        $configs = [System.IO.Directory]::CreateDirectory((Join-Path $root 'Catzc.Base.Languages/configs')).FullName
        [System.IO.File]::WriteAllText((Join-Path $configs 'languages.yml'), "languages:`n  powershell:`n    layout:`n      - { folder: inner, role: widget }`n")
        { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Get-PrivateFunctionFolder -ModulesRoot $Root } } |
            Should -Throw "*no powershell layout row with role 'private-function'*"
    }
}
