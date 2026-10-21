<#
---
catzc:
  immutable:
    with_body_sha: "802d37379ee0"
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/Get-DocNote.Tests.ps1
---
#>

function Get-DocNote {
    <#
    .SYNOPSIS
        Lists a session's notes, from their heads, and whether the processor has processed each.

    .DESCRIPTION
        A note is processed when processed.md, the processor's ledger (Complete-DocNote), holds a line for its id. The note files are read,
        never written.

    .PARAMETER Session
        The session folder. Default: the newest session.

    .PARAMETER Unprocessed
        Only the notes the ledger has no line for.

    .PARAMETER Source
        Only the notes whose change came from these writers: editor (the editor's own saves, the processor's input), agent (a Claude
        Code session) or unknown (neither ledger knows it).

    .OUTPUTS
        [pscustomobject] per note, in id order: Id, File (the changed path), Change, From, Kind, Tier, Source, Agent (the agent's session
        id), Rules, Commit, Note (the note file),
        Session (the session folder, which every later call about the note names, since a new session numbers its notes from 0001
        again), Processed.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [switch] $Unprocessed,

        [ValidateSet('editor', 'agent', 'unknown')]
        [string[]] $Source
    )

    $Session = Resolve-ListenSession $Session
    $notes = Join-Path $Session 'notes'
    if (-not [System.IO.Directory]::Exists($notes)) {
        return
    }

    $processed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $ledger = Join-Path $Session 'processed.md'
    if ([System.IO.File]::Exists($ledger)) {
        foreach ($line in [System.IO.File]::ReadAllLines($ledger)) {
            if ($line -match '^- (\d{4}) \|') {
                [void] $processed.Add($Matches[1])
            }
        }
    }

    $files = [string[]] @([System.IO.Directory]::GetFiles($notes, '*.md'))
    [Array]::Sort($files, [System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $head = @{}
        $lines = [System.IO.File]::ReadAllLines($file)
        for ($i = 1; $i -lt $lines.Count -and $lines[$i] -ne '---'; $i++) {
            if ($lines[$i] -match '^([a-z_]+): ?(.*)$') {
                $head[$Matches[1]] = $Matches[2].Trim('"')
            }
        }
        $id = $head['note']
        if (($Unprocessed -and $processed.Contains($id)) -or ($Source -and $head['source'] -cnotin $Source)) {
            continue
        }
        $rules = $head['rules'].Trim('[', ']')
        [pscustomobject]@{
            Id        = $id
            File      = $head['path']
            Change    = $head['change']
            From      = $head['from']
            Kind      = $head['kind']
            Tier      = $head['tier']
            Source    = $head['source']
            Agent     = $head['agent']
            Rules     = [string[]] @(if ($rules) {
                    $rules -split ', '
                })
            Commit    = $head['commit']
            Note      = $file
            Session   = $Session
            Processed = $processed.Contains($id)
        }
    }
}
