function Write-TestResultMarker {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Outcome,

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [ValidateSet('Invoke-TestFile', 'Test-Automation', 'Test-CatzcBuild')]
        [string] $Runner,

        [Parameter(Mandatory)]
        [string] $StartedAt,

        [ValidateRange(0, 4)]
        [int] $MinLevel = 0,

        [ValidateRange(0, 4)]
        [int] $MaxLevel = 2,

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both',

        [AllowEmptyCollection()]
        [string[]] $Rule = @(),

        # A run filtered to some tests (-FullNameFilter or -Rule) says nothing of the others, so it records failures only.
        [switch] $Filtered,

        [switch] $Isolated,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputRoot = (Get-OutputRoot)
    )

    $resultRoot = Join-Path $OutputRoot 'test-results'
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $scope = [ordered]@{
        minLevel = $MinLevel
        maxLevel = $MaxLevel
        category = $Category
        rule     = @($Rule)
        filtered = [bool] $Filtered
    }
    foreach ($item in $Outcome) {
        $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $item.Path).Replace('\', '/')
        if ($relative.StartsWith('../') -or [System.IO.Path]::IsPathRooted($relative)) {
            continue
        }
        $target = Join-Path $resultRoot "$relative.result.json"
        if (-not $item.Failed) {
            # A filtered pass records nothing, and a pass narrower than the stored failure leaves the failure standing.
            if ($Filtered) {
                continue
            }
            $stored = if ([System.IO.File]::Exists($target)) {
                try {
                    [System.IO.File]::ReadAllText($target) | ConvertFrom-Json
                }
                catch {
                    $null
                }
            }
            if ($stored -and $stored.result -eq 'failed') {
                $before = $stored.scope
                $covers = $MinLevel -le $before.minLevel -and $MaxLevel -ge $before.maxLevel -and
                ($Category -eq 'Both' -or $Category -eq $before.category)
                if (-not $covers) {
                    continue
                }
            }
        }
        $result = [ordered]@{
            result       = if ($item.Failed) { 'failed' } else { 'passed' }
            failedCount  = [int] $item.FailedCount
            startedAt    = $StartedAt
            runner       = $Runner
            pid          = $PID
            isolated     = [bool] $Isolated
            scope        = $scope
            runDirectory = $RunDirectory
        }
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target))
        # Written under a temporary name and moved, so a peer's reader never sees half a file.
        $temporary = "$target.$PID.$([guid]::NewGuid().ToString('N').Substring(0, 6)).tmp"
        [System.IO.File]::WriteAllText($temporary, ($result | ConvertTo-Json -Depth 4) + "`n", $utf8NoBom)
        [System.IO.File]::Move($temporary, $target, $true)
        $target
    }
}
