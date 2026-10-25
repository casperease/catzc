<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-AgentFrontMatter.ps1.md"
  header: "generated"
---
#>

function Get-AgentFrontMatter {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    Assert-PathExist $Path

    $lines = [System.IO.File]::ReadAllLines($Path)
    if ($lines.Count -eq 0 -or $lines[0].TrimEnd() -ne '---') {
        throw [System.ArgumentException]::new('has no front matter: the first line must be ---')
    }
    $end = -1
    for ($index = 1; $index -lt $lines.Count; $index++) {
        if ($lines[$index].TrimEnd() -eq '---') {
            $end = $index
            break
        }
    }
    if ($end -lt 0) {
        throw [System.ArgumentException]::new('has no closing --- for its front matter')
    }

    $block = $lines[1..($end - 1)] -join "`n"
    if ($end -eq 1) {
        $block = ''
    }
    try {
        $parsed = ConvertFrom-Yaml -Yaml $block -Ordered
    }
    catch {
        throw [System.ArgumentException]::new("has front matter that is not valid YAML: $($_.Exception.Message)")
    }
    if ($parsed -isnot [System.Collections.IDictionary]) {
        throw [System.ArgumentException]::new('has front matter that is not a mapping')
    }
    $parsed
}
