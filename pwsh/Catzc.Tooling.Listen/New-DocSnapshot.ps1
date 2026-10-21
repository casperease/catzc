<#
---
catzc:
  immutable:
    with_body_sha: "479329b98cba"
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/New-DocSnapshot.Tests.ps1
---
#>

function New-DocSnapshot {
    <#
    .SYNOPSIS
        Starts a listen session: the frozen baseline, the rolling seen copy, their indexes, and the committed reference.

    .DESCRIPTION
        Creates <output>/<stamp>/ (listen.yml's output folder, the stamp yyyyMMdd-HHmmss) holding:

        - baseline/ and seen/: two copies of the watched folder as it is on disk now. baseline/ never changes; seen/ moves forward as
          changes are noted (Update-DocSnapshot).
        - baseline.json and seen.json: path to length, last-write ticks and content hash of the watched files, so a poll hashes only
          what changed.
        - reference/: the repository at HEAD, committed files only (New-RepositorySnapshot -Committed), the one truth the scouts and the
          fact-checks read; never the live tree.
        - manifest.json: the watched folder, the pinned commit and the start time.
        - notes/: empty, for New-DocNote.

        Git state plays no part in what counts as a change; it is read once, here, to pin the reference.

    .PARAMETER Watch
        The repository-relative folder to watch. Default: listen.yml's watch.

    .OUTPUTS
        [pscustomobject] with Path (the session folder), Watch and Commit.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Watch = (Get-Config -Config listen).watch
    )

    $root = Get-RepositoryRoot
    $watched = Join-Path $root $Watch
    Assert-PathExist $watched -PathType Container -ErrorText "New-DocSnapshot: the watched folder '$Watch' does not exist."

    $stamp = [DateTime]::Now.ToString('yyyyMMdd-HHmmss', [cultureinfo]::InvariantCulture)
    $session = Join-Path (Join-Path $root (Get-Config -Config listen).output) $stamp
    Assert-True (-not [System.IO.Directory]::Exists($session)) -ErrorText "New-DocSnapshot: the session '$session' already exists; start again in a second."
    [void] [System.IO.Directory]::CreateDirectory((Join-Path $session 'notes'))

    Write-Message "Copying '$Watch' into the listen session '$session'..."
    Copy-Directory $watched (Join-Path $session 'baseline')
    Copy-Directory $watched (Join-Path $session 'seen')
    $index = Get-ListenFileIndex $watched -Prefix $Watch

    Write-Message 'Building the committed reference at HEAD...'
    $reference = New-RepositorySnapshot -Committed -Destination (Join-Path $session 'reference')

    $manifest = [ordered]@{
        watch      = $Watch
        commit     = $reference.Commit
        started_at = [DateTimeOffset]::Now.ToString('o')
    }
    [System.IO.File]::WriteAllText((Join-Path $session 'manifest.json'), (ConvertTo-Json -InputObject $manifest), [System.Text.UTF8Encoding]::new($false))
    # seen.json is what makes a folder a session, so it is written last: a start that fails half way leaves no session behind.
    Write-ListenIndex (Join-Path $session 'baseline.json') -Index $index
    Write-ListenIndex (Join-Path $session 'seen.json') -Index $index

    [pscustomobject]@{
        Path   = $session
        Watch  = $Watch
        Commit = $reference.Commit
    }
}
