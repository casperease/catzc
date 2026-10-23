<#
.SYNOPSIS
    Lands staged files in an import-path burst: backs up what they replace, swaps them in, tests them under one fresh import, and restores on failure.

.DESCRIPTION
    A change to a file every session's next import reads (an importer-path script, a type, a root asset) is edited on staged copies and
    swapped in by this one mechanism, never by hand. The staged folder mirrors the repository: a file at <staged>/pwsh/x.ps1 replaces
    <root>/pwsh/x.ps1, and a file with no counterpart is created. The call takes the run lock as a burst (Enter-CatzcBurst.ps1), writes a
    backup journal beside the staged folder (<staged>.backup), copies the staged files over their targets, and runs -Command in one
    Invoke-CatzcCommand -InBurst call, which is the one fresh import. When any command fails, or anything throws, every target is
    restored from the journal (a target the swap created is deleted) and the call exits 1; when all pass, the journal is removed and the
    staged copies stay for the caller to delete.

    The swap is never left half done. The journal is complete before the first target is touched, the restore runs in a finally block, and
    a journal found at the start, left by a call killed mid-swap, is restored before anything else happens.

    timeout 360 pwsh -NoProfile -File pwsh/.internal/assets/Invoke-StagedBurst.ps1 -StagedFolder out/topic/staged -Seconds 240 'Test-Parsing -Path pwsh/x.ps1' 'Invoke-TestFile -Path pwsh/tests/x.Tests.ps1'

.PARAMETER StagedFolder
    The folder of staged files, mirroring the repository root, relative to it or absolute.

.PARAMETER Command
    The cats commands that test the swap, each one line, run in one import. They are the arguments left after the named ones.

.PARAMETER RepositoryRoot
    The root the staged files are swapped into. Default: the repository the script sits in.

.PARAMETER Importer
    The importer the tests dot-source. Default: the repository's importer.ps1.

.PARAMETER Seconds
    The most seconds the burst holds the lock. Default: 300, inside the 360 s background roof of the time safeguard.

.PARAMETER LockName
    The named mutex every run takes. Default: Local\catzc-run, the lock of Invoke-CatzcCommand.

.PARAMETER LockSeconds
    The most seconds the burst waits past a live holder's deadline. Default: run_lock.wait_seconds of timeouts.yml.

.PARAMETER InBurst
    The swap and its tests, run under the lock the burst holds; the call starts it itself and nothing else passes it.
#>
param(
    [Parameter(Mandatory)]
    [string] $StagedFolder,

    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]] $Command,

    [string] $RepositoryRoot = (Join-Path $PSScriptRoot '../../..'),

    [string] $Importer,

    [ValidateRange(1, 360)]
    [int] $Seconds = 300,

    [string] $LockName = 'Local\catzc-run',

    [ValidateRange(1, 360)]
    [int] $LockSeconds,

    [switch] $InBurst
)

Set-StrictMode -Version Latest

$Command = @($Command | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
if ($Command.Count -eq 0) {
    throw 'Invoke-StagedBurst: name at least one command that tests the swap.'
}
$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$staged = if ([System.IO.Path]::IsPathRooted($StagedFolder)) {
    [System.IO.Path]::GetFullPath($StagedFolder)
}
else {
    [System.IO.Path]::GetFullPath((Join-Path $root $StagedFolder))
}
$journal = "$($staged.TrimEnd('\', '/')).backup"
$manifestPath = Join-Path $journal 'manifest.json'
$filesFolder = Join-Path $journal 'files'

# Puts every target back as the journal holds it: a file it backed up is copied over, a file the swap created is deleted.
function Restore-Journal {
    foreach ($entry in @(Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json)) {
        $target = Join-Path $root $entry.path
        if ($entry.existed) {
            Copy-Item -LiteralPath (Join-Path $filesFolder $entry.path) -Destination $target -Force
        }
        elseif (Test-Path -LiteralPath $target) {
            Remove-Item -LiteralPath $target -Force
        }
    }
    Remove-Item -LiteralPath $journal -Recurse -Force
}

if (-not $InBurst) {
    # The burst is the lock; its one step is this script again, inside it.
    $quote = { param([string] $Text) "'" + $Text.Replace("'", "''") + "'" }
    $step = "& $(& $quote $PSCommandPath) -InBurst -StagedFolder $(& $quote $staged) -RepositoryRoot $(& $quote $root) -LockName $(& $quote $LockName)" +
    " $(if ($Importer) { "-Importer $(& $quote $Importer)" }) $(($Command | ForEach-Object { & $quote $_ }) -join ' ')"
    $enter = @{ Seconds = $Seconds; LockName = $LockName }
    if ($PSBoundParameters.ContainsKey('LockSeconds')) {
        $enter.LockSeconds = $LockSeconds
    }
    & (Join-Path $PSScriptRoot 'Enter-CatzcBurst.ps1') @enter $step
    exit $LASTEXITCODE
}

# A journal left by a call killed mid-swap is put back before anything else is swapped.
if (Test-Path -LiteralPath $manifestPath) {
    Restore-Journal
    '[Invoke-StagedBurst] restored an interrupted swap from its journal'
}
elseif (Test-Path -LiteralPath $journal) {
    Remove-Item -LiteralPath $journal -Recurse -Force
}

if (-not (Test-Path -LiteralPath $staged -PathType Container)) {
    throw "Invoke-StagedBurst: the staged folder '$staged' does not exist."
}
# A bounded walk, one level at a time: a staged tree deeper than the roof is a mistake, never a silent subset.
$depthRoof = 10
$pending = [System.Collections.Generic.Queue[object]]::new()
$pending.Enqueue(@($staged, 0))
$relatives = [System.Collections.Generic.List[string]]::new()
while ($pending.Count -gt 0) {
    $folder, $depth = $pending.Dequeue()
    foreach ($file in [System.IO.Directory]::EnumerateFiles($folder)) {
        $relatives.Add([System.IO.Path]::GetRelativePath($staged, $file))
    }
    foreach ($child in [System.IO.Directory]::EnumerateDirectories($folder)) {
        if ($depth -ge $depthRoof) {
            throw "Invoke-StagedBurst: the staged folder '$staged' is deeper than $depthRoof levels."
        }
        $pending.Enqueue(@($child, ($depth + 1)))
    }
}
$relatives = @($relatives)
if ($relatives.Count -eq 0) {
    throw "Invoke-StagedBurst: the staged folder '$staged' holds no file."
}

# The journal is complete before the first target is touched.
$entries = foreach ($relative in $relatives) {
    $target = Join-Path $root $relative
    $existed = Test-Path -LiteralPath $target -PathType Leaf
    if ($existed) {
        $backup = Join-Path $filesFolder $relative
        $null = New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force
        Copy-Item -LiteralPath $target -Destination $backup -Force
    }
    [pscustomobject]@{ path = $relative; existed = $existed }
}
$null = New-Item -ItemType Directory -Path $journal -Force
ConvertTo-Json -InputObject @($entries) | Set-Content -LiteralPath $manifestPath

$passed = $false
$outcome = ''
try {
    foreach ($relative in $relatives) {
        $target = Join-Path $root $relative
        $null = New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force
        Copy-Item -LiteralPath (Join-Path $staged $relative) -Destination $target -Force
    }
    $arguments = @('-InBurst', '-LockName', $LockName)
    if ($Importer) {
        $arguments += @('-Importer', $Importer)
    }
    $global:LASTEXITCODE = 0
    & (Join-Path $PSScriptRoot 'Invoke-CatzcCommand.ps1') @arguments $Command
    if ($global:LASTEXITCODE -eq 0) {
        $passed = $true
        $outcome = "swapped $($relatives.Count) staged file(s) in and $($Command.Count) command(s) passed"
    }
    else {
        $outcome = "the tests failed (exit code $global:LASTEXITCODE)"
    }
}
catch {
    $outcome = "the swap threw: $($_.Exception.Message)"
}
finally {
    # Any way out but a pass puts the targets back, an interruption included.
    if (-not $passed) {
        Restore-Journal
    }
}
if ($passed) {
    Remove-Item -LiteralPath $journal -Recurse -Force
    "[Invoke-StagedBurst] $outcome"
}
else {
    "[Invoke-StagedBurst] restored every target from the journal: $outcome"
    exit 1
}
