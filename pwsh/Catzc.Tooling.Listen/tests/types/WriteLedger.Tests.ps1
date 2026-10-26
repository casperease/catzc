Describe 'Catzc.Tooling.Listen.WriteLedger' -Tag 'L0', 'logic', 'ADR-REPO-AI-EDITORISFACT' {
    BeforeAll {
        $script:t0 = [DateTimeOffset]::Parse('2026-10-20T10:00:00+00:00', [cultureinfo]::InvariantCulture)

        function New-Entry {
            param([string] $Kind, [int] $Second, [string] $Path, [string] $Hash, [string] $Session = 'gadget',
                [string] $Id)
            [Catzc.Tooling.Listen.WriteLedgerEntry]::new($script:t0.AddSeconds($Second), $Kind, $Path, $Hash, $Session,
                $Id)
        }

        function Get-Source {
            param($Agent = @(), $Editor = @(), [string] $Hash = 'h1', [Nullable[DateTimeOffset]] $WrittenAt,
                [int] $NowSecond = 1000)
            [Catzc.Tooling.Listen.WriteLedger]::SourceOf(
                [Catzc.Tooling.Listen.WriteLedgerEntry[]] @($Agent),
                [Catzc.Tooling.Listen.WriteLedgerEntry[]] @($Editor),
                'docs/widget.md', $Hash, $WrittenAt, 360, $script:t0.AddSeconds($NowSecond))
        }
    }

    Context 'lines' {
        It 'writes a line the reader reads back, escaping quotes, backslashes and control characters' {
            $file = Join-Path $TestDrive 'ledger.jsonl'
            $lines = @(
                [Catzc.Tooling.Listen.WriteLedger]::Line('2026-10-20T10:00:00.0000000+00:00', 'write',
                    'docs/wid"get\x.md', 'h1', 'gadget', 'call-1')
                [Catzc.Tooling.Listen.WriteLedger]::Line('2026-10-20T10:00:01.0000000+00:00', 'bash-start', $null,
                    $null, "gad`tget", $null)
            )
            $lines[1] | Should -Not -BeLike '*"path"*'
            [System.IO.File]::WriteAllText($file, ($lines -join "`n") + "`n{torn`n")

            $entries = [Catzc.Tooling.Listen.WriteLedger]::Read($file)
            $entries.Count | Should -Be 2
            $entries[0].path | Should -BeExactly 'docs/wid"get\x.md'
            $entries[0].kind | Should -BeExactly 'write'
            $entries[0].id | Should -BeExactly 'call-1'
            $entries[1].session | Should -BeExactly "gad`tget"
            $entries[1].path | Should -BeNullOrEmpty
            $entries[1].at | Should -Be ($script:t0.AddSeconds(1))
        }

        It 'reads a line the editor extension writes' {
            $file = Join-Path $TestDrive 'editor.jsonl'
            [System.IO.File]::WriteAllText($file,
                '{"at":"2026-10-20T10:00:00.000Z","event":"save","path":"docs/widget.md","hash":"h1"}' + "`n")
            $entries = [Catzc.Tooling.Listen.WriteLedger]::Read($file)
            $entries[0].kind | Should -BeExactly 'save'
            $entries[0].at | Should -Be $script:t0
        }

        It 'reads no entries from a missing file' {
            [Catzc.Tooling.Listen.WriteLedger]::Read((Join-Path $TestDrive 'gizmo.jsonl')).Count | Should -Be 0
        }
    }

    Context 'who wrote the bytes' {
        It 'names the agent whose tool wrote exactly these bytes, above an editor save of the same bytes' {
            $source = Get-Source -Agent (New-Entry -Kind write -Second 5 -Path 'docs/widget.md' -Hash 'h1') -Editor (New-Entry -Kind save -Second 6 -Path 'docs/widget.md' -Hash 'h1')
            $source.source | Should -BeExactly 'agent'
            $source.agent | Should -BeExactly 'gadget'
        }

        It 'names the editor for an exact save, even inside an agent''s Bash window' {
            $agent = @((New-Entry bash-start 0 -Id 'call-1'), (New-Entry bash-end 30 -Id 'call-1'))
            $source = Get-Source -Agent $agent -Editor (New-Entry -Kind save -Second 10 -Path 'docs/widget.md' -Hash 'h1') -WrittenAt $script:t0.AddSeconds(10)
            $source.source | Should -BeExactly 'editor'
        }

        It 'names the agent for a write inside its Bash window, up to the grace after its end' {
            $agent = @((New-Entry bash-start 0 -Id 'call-1'), (New-Entry bash-end 30 -Id 'call-1'))
            (Get-Source -Agent $agent -Hash 'h2' -WrittenAt $script:t0.AddSeconds(31)).source |
                Should -BeExactly 'agent'
            (Get-Source -Agent $agent -Hash 'h2' -WrittenAt $script:t0.AddSeconds(33)).source |
                Should -BeExactly 'unknown'
        }

        It 'closes a window with no recorded end after the open-window bound' {
            $agent = @(New-Entry bash-start 0 -Id 'call-1')
            (Get-Source -Agent $agent -Hash 'h2' -WrittenAt $script:t0.AddSeconds(300)).source |
                Should -BeExactly 'agent'
            (Get-Source -Agent $agent -Hash 'h2' -WrittenAt $script:t0.AddSeconds(400)).source |
                Should -BeExactly 'unknown'
        }

        It 'names nobody for bytes no ledger knows, and for a deleted file outside every window' {
            $agent = New-Entry -Kind write -Second 5 -Path 'docs/widget.md' -Hash 'h0'
            (Get-Source -Agent $agent -Editor (New-Entry -Kind save -Second 6 -Path 'docs/gadget.md' -Hash 'h1')).source | Should -BeExactly 'unknown'
            (Get-Source -Hash $null).source | Should -BeExactly 'unknown'
        }
    }
}
