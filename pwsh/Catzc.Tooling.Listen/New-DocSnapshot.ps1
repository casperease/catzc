<#
---
catzc:
  immutable:
    with_body_sha: f51d26095e93
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/New-DocSnapshot.Tests.ps1
    docs: "[New-DocSnapshot.ps1.md](../../docs/references/pwsh/catzc-tooling-listen/New-DocSnapshot.ps1.md)"
---
#>

function New-DocSnapshot {
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
