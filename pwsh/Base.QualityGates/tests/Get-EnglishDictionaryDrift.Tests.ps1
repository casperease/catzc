Describe 'Get-EnglishDictionaryDrift' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:assets = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:assets) | Out-Null
        $words = [System.Text.Encoding]::UTF8.GetBytes((@('gadget', 'widget', '') -join "`n"))
        [System.IO.File]::WriteAllBytes((Join-Path $script:assets 'english.txt.gz'),
            [Catzc.Base.QualityGates.GzipText]::Compress($words))
        $script:writeStamp = {
            param([string] $Cspell, [int] $WordCount)
            [System.IO.File]::WriteAllText((Join-Path $script:assets 'english.stamp'),
                (@{ cspell = $Cspell; word_count = $WordCount } | ConvertTo-Json))
        }
    }

    It 'reports nothing when the stamp matches the pin and the gz' {
        & $script:writeStamp '10.0.1' 2
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Assets = $script:assets } {
            @(Get-EnglishDictionaryDrift -AssetsFolder $Assets -PinnedCspell '10') | Should -BeNullOrEmpty
        }
    }

    It 'reports a moved cspell pin and a word count that no longer matches the gz' {
        & $script:writeStamp '9.1.0' 5
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Assets = $script:assets } {
            $reasons = @(Get-EnglishDictionaryDrift -AssetsFolder $Assets -PinnedCspell '10')
            $reasons | Should -HaveCount 2
            $reasons[0] | Should -Be "flattened from cspell '9.1.0' but tools.yml pins '10'"
            $reasons[1] | Should -Be 'holds 2 word(s) but its stamp records 5'
        }
    }

    It 'reports a missing stamp' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Assets = $script:assets } {
            Get-EnglishDictionaryDrift -AssetsFolder $Assets -PinnedCspell '10' | Should -Be 'english.stamp is missing'
        }
    }
}
