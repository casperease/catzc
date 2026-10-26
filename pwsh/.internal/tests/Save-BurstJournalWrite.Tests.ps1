Describe 'Save-BurstJournalWrite' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot '../assets/types/Save-BurstJournalWrite.ps1')
        $script:declared = Import-PowerShellDataFile -LiteralPath (Join-Path $PSScriptRoot '../assets/types/burst-journal.psd1')
    }

    BeforeEach {
        $script:journal = Join-Path $TestDrive "journal-$([guid]::NewGuid().ToString('N'))"
        $null = New-Item -ItemType Directory -Path $script:journal
        $script:file = Join-Path $TestDrive "widget-$([guid]::NewGuid().ToString('N')).txt"
        $script:previous = [System.Environment]::GetEnvironmentVariable($script:declared.Variable)
    }

    AfterEach {
        [System.Environment]::SetEnvironmentVariable($script:declared.Variable, $script:previous)
    }

    It 'does nothing outside a burst' {
        [System.Environment]::SetEnvironmentVariable($script:declared.Variable, $null)
        Save-BurstJournalWrite -Path $script:file
        @(Get-ChildItem -LiteralPath $script:journal) | Should -BeNullOrEmpty
    }

    It 'records an absent file once, and the content of an existing one, first write only' {
        [System.Environment]::SetEnvironmentVariable($script:declared.Variable, $script:journal)
        $existing = Join-Path $TestDrive "gadget-$([guid]::NewGuid().ToString('N')).txt"
        [System.IO.File]::WriteAllText($existing, 'before')
        Save-BurstJournalWrite -Path $script:file
        Save-BurstJournalWrite -Path $existing
        [System.IO.File]::WriteAllText($existing, 'after')
        Save-BurstJournalWrite -Path $existing
        Save-BurstJournalWrite -Path $script:file

        $entries = @(Get-Content -LiteralPath (Join-Path $script:journal $script:declared.WrittenLog) -Raw | ConvertFrom-Json)
        $entries | Should -HaveCount 2
        $entries[0].path | Should -Be ([System.IO.Path]::GetFullPath($script:file))
        $entries[0].existed | Should -BeFalse
        $entries[1].existed | Should -BeTrue
        [System.IO.File]::ReadAllText($entries[1].backup) | Should -BeExactly 'before'
    }
}
