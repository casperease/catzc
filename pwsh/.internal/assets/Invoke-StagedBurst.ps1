<#
.SYNOPSIS
    Lands staged files in an import-path burst: backs up what they replace, swaps them in, tests them under one fresh import, and restores on failure.

.DESCRIPTION
    A change to a file every session's next import reads (an importer-path script, a type, a root asset) is edited on staged copies and
    swapped in by this one mechanism, never by hand. The staged folder mirrors the repository: a file at <staged>/pwsh/x.ps1 replaces
    <root>/pwsh/x.ps1, and a file with no counterpart is created. An empty marker <staged>/<path>.burst-delete deletes <root>/<path> instead; its
    target must exist, or the call stops before touching anything, and it is journalled and restored like any swapped file. The call takes the run lock as a burst (Enter-CatzcBurst.ps1), writes a
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

.PARAMETER Stage
    Stages these repository-relative files instead of swapping: each is copied into the staged folder with a <path>.burst-base beside it,
    the SHA-256 the target has now. A later swap refuses, before touching anything, a staged file whose target no longer has that hash, so a
    stale whole-file copy never overwrites a peer's edit; a staged file with no base, such as a new one, is swapped as before. Several
    paths go as an array, as one comma-joined string, or as further arguments, so `pwsh -File … -Stage a.ps1,b.ps1` stages both.
#>

# The help stays in this file, not on a comment page: the script imports nothing, since it swaps the files an import
# reads, so the page
# tooling that would move it is not loaded where it runs and a reader of the file alone still finds how to call it.
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

    [switch] $InBurst,

    [string[]] $Stage
)

Set-StrictMode -Version Latest

$baseSuffix = '.burst-base'
if ($Stage) {
    # Through pwsh -File a list arrives as one comma-joined string, or its later paths land among the commands, which
    # staging never runs.
    $Stage = @(@($Stage) + @($Command) | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } |
        Where-Object { $_ })
    $stageRoot = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $stageFolder = if ([System.IO.Path]::IsPathRooted($StagedFolder)) {
        [System.IO.Path]::GetFullPath($StagedFolder)
    }
    else {
        [System.IO.Path]::GetFullPath((Join-Path $stageRoot $StagedFolder))
    }
    foreach ($relative in $Stage) {
        $source = Join-Path $stageRoot $relative
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
            throw "Invoke-StagedBurst: '$relative' does not exist, so there is nothing to stage; write a new file into the staged folder directly."
        }
        $copy = Join-Path $stageFolder $relative
        $null = New-Item -ItemType Directory -Path (Split-Path -Parent $copy) -Force
        Copy-Item -LiteralPath $source -Destination $copy -Force
        Set-Content -LiteralPath "$copy$baseSuffix" -Value (Get-FileHash -Algorithm SHA256 -LiteralPath $source).Hash -NoNewline
        "[Invoke-StagedBurst] staged $relative with its base"
    }
    return
}

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

# Puts every target back as the journal holds it: a file it backed up is copied over, a file the swap created is
# deleted.
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
# A bounded walk, one level at a time: a staged tree deeper than the roof is a mistake, never a silent subset. It is
# written out here with
# [System.IO] and not read through the folder walker, which is a module an import loads and this script runs without.
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
# A base is no swap: it guards the staged file beside it, which is refused when its target moved on since it was staged.
$bases = @($relatives | Where-Object { $_.EndsWith($baseSuffix, [System.StringComparison]::Ordinal) })
$relatives = @($relatives | Where-Object { -not $_.EndsWith($baseSuffix, [System.StringComparison]::Ordinal) })
foreach ($base in $bases) {
    $guarded = $base.Substring(0, $base.Length - $baseSuffix.Length)
    $target = Join-Path $root $guarded
    $now = if (Test-Path -LiteralPath $target -PathType Leaf) {
        (Get-FileHash -Algorithm SHA256 -LiteralPath $target).Hash
    }
    else {
        'absent'
    }
    if ($now -ne (Get-Content -LiteralPath (Join-Path $staged $base) -Raw).Trim()) {
        throw "Invoke-StagedBurst: '$guarded' changed since it was staged, so the staged copy would overwrite a newer edit; stage it again from the current file."
    }
}
$relatives = @($relatives)
if ($relatives.Count -eq 0) {
    throw "Invoke-StagedBurst: the staged folder '$staged' holds no file."
}

# A staged '<path>.burst-delete' marker deletes its target instead of swapping a file in; the target must exist, and is
# journalled like any.
$deleteSuffix = '.burst-delete'
foreach ($relative in $relatives) {
    if ($relative.EndsWith($deleteSuffix, [System.StringComparison]::Ordinal)) {
        $doomed = $relative.Substring(0, $relative.Length - $deleteSuffix.Length)
        if (-not (Test-Path -LiteralPath (Join-Path $root $doomed) -PathType Leaf)) {
            throw "Invoke-StagedBurst: the staged folder marks '$doomed' for deletion, but it does not exist."
        }
    }
}

# The journal is complete before the first target is touched.
$entries = foreach ($relative in $relatives) {
    if ($relative.EndsWith($deleteSuffix, [System.StringComparison]::Ordinal)) {
        $relative = $relative.Substring(0, $relative.Length - $deleteSuffix.Length)
    }
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
        if ($relative.EndsWith($deleteSuffix, [System.StringComparison]::Ordinal)) {
            Remove-Item -LiteralPath (Join-Path $root $relative.Substring(0,
                $relative.Length - $deleteSuffix.Length)) -Force
            continue
        }
        $target = Join-Path $root $relative
        $null = New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force
        Copy-Item -LiteralPath (Join-Path $staged $relative) -Destination $target -Force
    }
    # A hashtable splat binds by name; an array of '-InBurst' strings would reach the script as commands to run.
    $arguments = @{ InBurst = $true; LockName = $LockName; Command = $Command }
    if ($Importer) {
        $arguments.Importer = $Importer
    }
    $global:LASTEXITCODE = 0
    & (Join-Path $PSScriptRoot 'Invoke-CatzcCommand.ps1') @arguments
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
