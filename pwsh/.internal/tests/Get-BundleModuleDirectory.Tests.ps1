Describe 'Get-BundleModuleDirectory' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
        $script:codeRoot = Join-Path $TestDrive 'code'
        foreach ($folder in 'Catzc.Base.Widget', 'widgets/Widget', '.vendor', 'Catzc.Base.Unrecorded') {
            [void][System.IO.Directory]::CreateDirectory((Join-Path $codeRoot $folder))
        }
        [System.IO.File]::WriteAllText((Join-Path $codeRoot 'build.json'),
            '{ "modules": [ "Catzc.Base.Widget", "Catzc.Base.Gadget" ], "languages": [ { "module": "Widget", "path": "widgets/Widget" } ] }')
        $script:found = @(InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $codeRoot } {
                param($Root) Get-BundleModuleDirectory -ModulesRoot $Root
            })
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'returns the recorded module folder' {
        $found | ForEach-Object Name | Should -Be @('Catzc.Base.Widget')
    }

    It 'never returns a language place, a dot folder or a folder the record does not name' {
        $found | ForEach-Object Name | Should -Not -Contain 'widgets'
        $found | ForEach-Object Name | Should -Not -Contain '.vendor'
        $found | ForEach-Object Name | Should -Not -Contain 'Catzc.Base.Unrecorded'
    }

    It 'says nothing of a recorded module that has no folder' {
        $found | ForEach-Object Name | Should -Not -Contain 'Catzc.Base.Gadget'
    }

    It 'throws naming build.json when the code root has none' {
        $bare = Join-Path $TestDrive 'bare'
        [void][System.IO.Directory]::CreateDirectory($bare)
        { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $bare } { param($Root) Get-BundleModuleDirectory -ModulesRoot $Root } } |
            Should -Throw '*build.json*does not exist*'
    }
}
