<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
    kind: function
    module: Catzc.Azure.DevOps
    visibility: private
    adrs:
      - ADR-PIPE-NAME#4
---
#>

<#
.SYNOPSIS
    Extracts the template references (`template:` values) from a pipeline YAML file — the paths a
    naming/placement quality gate checks for absoluteness.
.DESCRIPTION
    A line scan, not a YAML parse, so it survives the template expressions that ADO YAML carries.
.PARAMETER Path
    The pipeline YAML file to scan.
.OUTPUTS
    [string[]] The referenced template paths, verbatim (quotes stripped). Empty when the file has none.
#>
function Get-PipelineTemplateReference {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $refs = [System.Collections.Generic.List[string]]::new()
    foreach ($line in (Get-Content -Path $Path)) {
        # A `template:` key at a mapping position, optionally the first entry of a list item (`- template:`).
        if ($line -notmatch '^\s*(?:-\s*)?template:\s*(.+?)\s*$') {
            continue
        }
        $value = $matches[1].Trim().Trim('"', "'")

        # Skip template expressions / runtime variables — their target is not a static path.
        if ($value -match '\$\{\{' -or $value -match '\$\(') {
            continue
        }
        # Only actual template file paths (.yaml); anything else is not a reference we validate.
        if ($value -notmatch '\.yaml$') {
            continue
        }
        $refs.Add($value)
    }
    $refs.ToArray()
}
