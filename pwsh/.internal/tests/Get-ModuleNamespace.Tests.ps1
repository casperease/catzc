Describe 'Get-ModuleNamespace' -Tag 'L0', 'logic', 'DDR-TRACK-MODULENAMESPACE' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N')) 'widgets'
        New-Item -Path (Join-Path $root 'Kit.Variants/configs') -ItemType Directory -Force | Out-Null
        New-Item -Path (Join-Path $root 'Kit.Other') -ItemType Directory -Force | Out-Null
    }

    It 'reads the namespace of the track named for the modules root, in the flow form' {
        Set-Content (Join-Path $root 'Kit.Variants/configs/variants.yml') "tracks:`n  gadgets: { namespace: Sprockets }`n  widgets: { type: modules, namespace: Gadgets.Kit }`n"
        InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Get-ModuleNamespace -ModulesRoot $Root } |
            Should -BeExactly 'Gadgets.Kit'
    }

    It 'reads the namespace in the block form, and stops at the next track' {
        Set-Content (Join-Path $root 'Kit.Variants/configs/variants.yml') "tracks:`n  widgets:`n    type: modules`n    namespace: Gadgets`n  gadgets:`n    namespace: Sprockets`n"
        InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Get-ModuleNamespace -ModulesRoot $Root } |
            Should -BeExactly 'Gadgets'
    }

    It 'returns no namespace when the track declares none' {
        Set-Content (Join-Path $root 'Kit.Variants/configs/variants.yml') "tracks:`n  widgets: { type: modules }`n  gadgets: { namespace: Sprockets }`n"
        InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Get-ModuleNamespace -ModulesRoot $Root } |
            Should -BeExactly ''
    }

    It 'returns no namespace when no module holds a variants config' {
        InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Get-ModuleNamespace -ModulesRoot $Root } |
            Should -BeExactly ''
    }
}
