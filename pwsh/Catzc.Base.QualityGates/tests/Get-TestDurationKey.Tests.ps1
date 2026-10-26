Describe 'Get-TestDurationKey' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repo'))
        $script:key = {
            param([string] $File, [string] $ShardFile)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ File = $File; ShardFile = $ShardFile; Root = $script:root } {
                param($File, $ShardFile, $Root)
                Get-TestDurationKey -File $File -ShardFile $ShardFile -RepositoryRoot $Root
            }
        }
    }

    It 'keys a file by its repository-relative path with forward slashes' {
        & $script:key (Join-Path $script:root 'widgets\Catzc.Widget\tests\gadget.Tests.ps1') '' |
            Should -BeExactly 'widgets/Catzc.Widget/tests/gadget.Tests.ps1'
    }

    It 'keys a one-file shard by the file the shard was given, not by the bridge script that ran it' {
        $bridge = Join-Path $script:root 'widgets/Catzc.Widget/tests/Language.Bridge.ps1'
        $folder = Join-Path $script:root 'go/tests/gadget'
        & $script:key $bridge $folder | Should -BeExactly 'go/tests/gadget'
    }

    It 'gives two bridged shards two keys, so each keeps its own weight' {
        $bridge = Join-Path $script:root 'widgets/Catzc.Widget/tests/Language.Bridge.ps1'
        $first = & $script:key $bridge (Join-Path $script:root 'go/tests/gadget')
        $second = & $script:key $bridge (Join-Path $script:root 'python/tests/widget')
        $first | Should -Not -BeExactly $second
    }
}
