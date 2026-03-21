Describe 'Clear-CompiledType' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    BeforeEach {
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Bootstrap

        # $root stands in for the automation/ dir; the combined assembly cache is its .compiled/ child.
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:compiled = Join-Path $root '.compiled'
        New-Item -Path $compiled -ItemType Directory -Force | Out-Null
        Set-Content (Join-Path $compiled 'Catzc.Types.11111111.dll') 'x'
        Set-Content (Join-Path $compiled 'Catzc.Types.22222222.dll') 'x'
    }

    It 'deletes every compiled DLL under .compiled' {
        InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Clear-CompiledType -ModulesRoot $Root }
        @(Get-ChildItem $compiled -Filter '*.dll').Count | Should -Be 0
    }

    It 'does not throw when .compiled is absent' {
        Remove-Item $compiled -Recurse -Force
        { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Clear-CompiledType -ModulesRoot $Root } } |
            Should -Not -Throw
    }

    It 'skips a locked DLL and removes the rest without stalling' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_file_lock'; return
        }

        $locked = Join-Path $compiled 'Catzc.Types.11111111.dll'
        $stream = [System.IO.File]::Open($locked, 'Open', 'Read', 'None')
        try {
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Clear-CompiledType -ModulesRoot $Root } } |
                Should -Not -Throw
            $locked | Should -Exist                                    # locked one survives
            Join-Path $compiled 'Catzc.Types.22222222.dll' | Should -Not -Exist   # the rest removed
        }
        finally {
            $stream.Dispose()
        }
    }
}
