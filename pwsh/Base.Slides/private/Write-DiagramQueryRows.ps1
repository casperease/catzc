<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Write-DiagramQueryRows.ps1.md"
  header: "generated"
---
#>

function Write-DiagramQueryRows {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Stem,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $rows = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($folderPath in $Stem) {
        $text = Get-DiagramDeclarationText -Stem $folderPath -RepositoryRoot $RepositoryRoot
        if ($null -eq $text) {
            continue
        }
        $declaration = ConvertFrom-Yaml -Yaml $text -Ordered
        $about = if ($declaration -and $declaration.Contains('about')) {
            $declaration['about']
        }
        if (-not $about -or -not $about.Contains('point') -or -not $about['point']) {
            continue
        }
        $point = "$($about['point'])".Trim().Trim('/')
        $level = "$($about['zoom'])"
        Assert-True ($level -cin 'C3',
            'C4') -ErrorText "Write-DiagramQueryRows: $folderPath names about.point $point at zoom '$level'; a point belongs to a C3 or C4 slide."
        if (-not $seen.Add("$point|$level")) {
            continue
        }
        $rows.Add($(if ($level -ceq 'C3') {
                    Get-DiagramComponentRows -Point $point -RepositoryRoot $RepositoryRoot
                }
                else {
                    Get-DiagramCodeRows -Point $point -RepositoryRoot $RepositoryRoot
                }))
    }

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    [System.IO.File]::WriteAllText($Path,
        (ConvertTo-Json -InputObject @{ rows = $rows.ToArray() } -Depth 6 -Compress) + "`n", $utf8)
    $Path
}
