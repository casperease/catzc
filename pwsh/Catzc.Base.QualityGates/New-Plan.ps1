function New-Plan {
    <#
    .SYNOPSIS
        Starts a plan: writes plan-<topic>.md in the plans folder with its head and its open steps section.

    .DESCRIPTION
        The way a plan starts (ADR-REPO-PLANS-ONETOPICONEFILE): the file it writes carries the plan head (status active, the value, today's
        date as reviewed, the targets) and the sections ADR-REPO-PLANS-ONESHAPE requires, so Test-Plans passes it before a step is written.
        It refuses a topic whose file exists, a name the plans folder does not accept, a value outside the ranks, and a target that does
        not exist. It writes the plan file only; the value row and the master line are written by hand.

    .PARAMETER Topic
        The plan's topic in kebab case; the file is plan-<topic>.md.

    .PARAMETER Value
        The plan's rank, one of the plans config's ranks.

    .PARAMETER Class
        The plan's class, such as feature or meta.

    .PARAMETER Target
        The repository-relative paths the plan changes, each one existing.

    .PARAMETER Config
        The plans config. Default: Get-Config -Config plans.

    .PARAMETER RepositoryRoot
        The repository the plans folder and the targets are relative to. Default: the loaded repository root.

    .OUTPUTS
        [string] The full path of the plan file written.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Topic,

        [Parameter(Mandatory)]
        [string] $Value,

        [Parameter(Mandatory)]
        [string] $Class,

        [Parameter(Mandatory)]
        [string[]] $Target,

        [Catzc.Base.QualityGates.PlansConfig] $Config = (Get-Config -Config plans),

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $name = "plan-$Topic.md"
    Assert-True ($Config.Accepts($name) -and $name -cne $Config.master_file) -ErrorText "New-Plan: '$name' is not a plan name the plans folder accepts (plan-<topic>.md, kebab case)."
    Assert-True ($Config.ranks -ccontains $Value) -ErrorText "New-Plan: value '$Value' is not one of the ranks: $($Config.ranks -join ', ')."
    foreach ($path in $Target) {
        $full = Join-Path $root $path
        Assert-True ([System.IO.File]::Exists($full) -or [System.IO.Directory]::Exists($full)) -ErrorText "New-Plan: target '$path' does not exist."
    }
    $file = Join-Path (Join-Path $root $Config.folder) $name
    Assert-True (-not [System.IO.File]::Exists($file)) -ErrorText "New-Plan: '$($Config.folder)/$name' exists; a topic has one plan."

    $title = $Topic.Replace('-', ' ')
    $lines = @(
        '---'
        'plan:'
        '  status: active'
        "  value: $Value"
        "  reviewed: $([DateTime]::Today.ToString('yyyy-MM-dd'))"
        "  class: $Class"
        "  targets: [$(($Target | ForEach-Object { $_.Replace('\', '/') }) -join ', ')]"
        '---'
        ''
        "# $($title.Substring(0, 1).ToUpperInvariant())$($title.Substring(1))"
        ''
        '## Open steps'
    )
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
    [System.IO.File]::WriteAllText($file, ($lines -join "`n") + "`n", [System.Text.UTF8Encoding]::new($false))
    Write-Message "New-Plan: wrote $($Config.folder)/$name."
    $file
}
