Describe 'Assert-SourceTree' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:consumer = Join-Path $TestDrive 'widget-consumer'
        $script:variantsFolder = Join-Path $script:consumer '.catzc/configs'
        [System.IO.Directory]::CreateDirectory($script:variantsFolder) | Out-Null
        $script:variantsFile = Join-Path $script:variantsFolder 'variants.yml'
    }
    BeforeEach {
        Remove-Item -LiteralPath $script:variantsFile -ErrorAction SilentlyContinue
        Mock Get-RepositoryRoot { $script:consumer } -ModuleName Catzc.Base.Repository
    }

    It 'is silent in source mode' {
        Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.Repository
        { Assert-SourceTree -Command 'Format-Widget' } | Should -Not -Throw
    }

    It 'is silent in build mode when the working root declares a track of its own' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Set-Content -LiteralPath $script:variantsFile -Value "tracks:`n  gadgets:`n    members: [gadgets]`n    type: modules"
        { Assert-SourceTree -Command 'Format-Widget' } | Should -Not -Throw
    }

    It 'throws in build mode when the working root has no variants file' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Assert-SourceTree -Command 'Format-Widget' } |
            Should -Throw '*Format-Widget works on the tracks of the working root*widget-consumer*.catzc/configs/variants.yml*ADR-AUTO-CONSUMER-OWNTRACKS*'
    }

    It 'throws in build mode when the variants file declares no track' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Set-Content -LiteralPath $script:variantsFile -Value 'naming: standard'
        { Assert-SourceTree -Command 'Format-Widget' } | Should -Throw '*declares none beyond the engine*'
    }

    It 'throws in build mode when the tracks map is empty' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Set-Content -LiteralPath $script:variantsFile -Value 'tracks: {}'
        { Assert-SourceTree -Command 'Format-Widget' } | Should -Throw '*declares none beyond the engine*'
    }

    It 'names the calling command when no command is given' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        function Invoke-Gadget {
            Assert-SourceTree
        }
        { Invoke-Gadget } | Should -Throw '*Invoke-Gadget works on the tracks*'
    }
}
