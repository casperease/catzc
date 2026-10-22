<#
---
catzc:
  immutable:
    with_body_sha: a5a2ff715ad5
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/New-DocNote.Tests.ps1
    docs: "[New-DocNote.ps1.md](../../docs/references/pwsh/catzc-tooling-listen/New-DocNote.ps1.md)"
---
#>

function New-DocNote {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [pscustomobject] $Change
    )

    process {
        $Session = Resolve-ListenSession $Session
        $notes = Join-Path $Session 'notes'
        [void] [System.IO.Directory]::CreateDirectory($notes)
        $commit = ([System.IO.File]::ReadAllText((Join-Path $Session 'manifest.json')) | ConvertFrom-Json).commit
        $id = '{0:D4}' -f (@([System.IO.Directory]::GetFiles($notes, '*.md')).Count + 1)
        $notePath = Join-Path $notes "$id.md"
        Assert-True (-not [System.IO.File]::Exists($notePath)) -ErrorText "New-DocNote: the note '$notePath' already exists; a note is written once."

        $arc = @(Get-DocChange -Session $Session -Against Baseline -Path @($Change.Path))
        $arcDiff = if ($arc.Count -gt 0) {
            $arc[0].Diff
        }
        else {
            ''
        }
        $rules = if (@($Change.Rules).Count -gt 0) {
            '[' + (@($Change.Rules) -join ', ') + ']'
        }
        else {
            '[]'
        }
        $from = if ($Change.From) {
            $Change.From
        }
        else {
            ''
        }

        $text = @(
            '---'
            "note: `"$id`""
            "path: `"$($Change.Path)`""
            "change: $($Change.Change)"
            "from: `"$from`""
            "kind: `"$($Change.Kind)`""
            "tier: $($Change.Tier)"
            "source: $($Change.Source)"
            "agent: `"$($Change.Agent)`""
            "rules: $rules"
            "commit: $commit"
            "written_at: $([DateTimeOffset]::Now.ToString('o'))"
            '---'
            ''
            "# Note $id — $($Change.Path) ($($Change.Change))"
            ''
            '## This change (against seen)'
            ''
            '````diff'
            $Change.Diff
            '````'
            ''
            '## The arc over the session (against baseline)'
            ''
            '````diff'
            $arcDiff
            '````'
            ''
        ) -join "`n"
        [System.IO.File]::WriteAllText($notePath, $text, [System.Text.UTF8Encoding]::new($false))

        [pscustomobject]@{
            Id   = $id
            Path = $notePath
        }
    }
}
