<#
---
catzc:
  immutable:
    with_body_sha: ddc93995d79b
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/New-Plan.Tests.ps1
    docs: "[New-Plan.ps1.md](docs/references/pwsh/catzc-base-quality-gates/New-Plan.ps1.md)"
    cites:
      - ADR-REPO-PLANS-ONETOPICONEFILE
      - ADR-REPO-PLANS-THREEPARTS
      - ADR-REPO-PLANS-ONESHAPE
---
#>

function New-Plan {
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

        [Parameter(Mandatory)]
        [string] $Summary,

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
    $folder = Join-Path $root $Config.folder
    $file = Join-Path $folder $name
    Assert-True (-not [System.IO.File]::Exists($file)) -ErrorText "New-Plan: '$($Config.folder)/$name' exists; a topic has one plan."
    $readOverlay = {
        param([string] $Overlay)
        $path = Join-Path $folder $Overlay
        Assert-True ([System.IO.File]::Exists($path)) -ErrorText "New-Plan: '$($Config.folder)/$Overlay' does not exist; a plan is its file, its value row and its master line."
        # The comma keeps the list whole on its way out of the script block.
        , [System.Collections.Generic.List[string]]::new([string[]] @([System.IO.File]::ReadAllText($path) -split "`r?`n"))
    }
    $valueLines = & $readOverlay $Config.value_file
    $masterLines = & $readOverlay $Config.master_file

    # The value row: the last row of the table under the "<Class> plans" heading, one cell per column of its header.
    $section = [Array]::FindIndex($valueLines.ToArray(), [Predicate[string]] { param($line) $line -match "^##\s+$([regex]::Escape($Class)) plans\b" })
    Assert-True ($section -ge 0) -ErrorText "New-Plan: $($Config.value_file) has no '## $Class plans' section for a plan of class '$Class'."
    $header = -1
    $last = -1
    for ($i = $section + 1; $i -lt $valueLines.Count -and $valueLines[$i] -notmatch '^##\s'; $i++) {
        if ($valueLines[$i] -match '^\|') {
            if ($header -lt 0) {
                $header = $i
            }
            $last = $i
        }
    }
    Assert-True ($header -ge 0) -ErrorText "New-Plan: the '## $Class plans' section of $($Config.value_file) has no table."
    $cells = foreach ($column in @($valueLines[$header].Trim('|').Split('|') | ForEach-Object { $_.Trim() })) {
        switch ($column) {
            'Value' {
                $Value
            }
            'Plan' {
                "plan-$Topic"
            }
            'Why' {
                $Summary
            }
            'State' {
                'new'
            }
            default {
                ''
            }
        }
    }
    $valueLines.Insert($last + 1, "| $($cells -join ' | ') |")

    # The master line: in the Chunks list, ahead of the first pointer to a task file, else after the list's last item.
    $chunks = [Array]::FindIndex($masterLines.ToArray(), [Predicate[string]] { param($line) $line -match '^##\s+Chunks' })
    Assert-True ($chunks -ge 0) -ErrorText "New-Plan: $($Config.master_file) has no '## Chunks' section."
    $at = -1
    for ($i = $chunks + 1; $i -lt $masterLines.Count -and $masterLines[$i] -notmatch '^##\s'; $i++) {
        if ($masterLines[$i] -match '^- .*->\s*task-') {
            $at = $i
            break
        }
        if ($masterLines[$i] -match '^- ' -or ($at -ge 0 -and $masterLines[$i] -match '^\s+\S')) {
            $at = $i + 1
        }
    }
    if ($at -lt 0) {
        $at = $chunks + 1
    }
    $masterLines.Insert($at, "- $Topic -> ${name}: $Summary")

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
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($file, ($lines -join "`n") + "`n", $utf8)
    [System.IO.File]::WriteAllText((Join-Path $folder $Config.value_file), ($valueLines -join "`n"), $utf8)
    [System.IO.File]::WriteAllText((Join-Path $folder $Config.master_file), ($masterLines -join "`n"), $utf8)
    Write-Message "New-Plan: wrote $($Config.folder)/$name, its row in $($Config.value_file) and its line in $($Config.master_file); run Format-Code -Language markdown on the three."
    $file
}
