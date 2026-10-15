<#
.SYNOPSIS
    Builds the ordered, validated Markdown column descriptors for Convert-FirewallCsvToMarkdown.
.DESCRIPTION
    Produces the column list in render order — the rule-name column, then the composite columns, then the additional...
    [comment:1](/docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownColumns.ps1.md#comment1)
.PARAMETER RuleNameColumn
    CSV column used as the rule name / first table column.
.PARAMETER CompositeColumns
    Ordered map of output column -> candidate CSV fields.
.PARAMETER ProtocolPortColumnName
    The composite column rendered as protocol:port pairs (and left unsorted).
.PARAMETER AdditionalColumns
    Extra single-field columns appended after the composites.
.PARAMETER Present
    The CSV's present header names. Empty means headers are unknown (no rows) — trimming/validation is skipped.
.OUTPUTS
    [System.Collections.Generic.List[object]] of descriptors (Name, Candidates, Sort, Render).
#>
function Get-FirewallMarkdownColumns {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[object]])]
    param(
        [Parameter(Mandatory)]
        [string]$RuleNameColumn,

        [Parameter(Mandatory)]
        [System.Collections.Specialized.OrderedDictionary]$CompositeColumns,

        [Parameter(Mandatory)]
        [string]$ProtocolPortColumnName,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]]$AdditionalColumns,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]]$Present
    )

    # Build ordered column descriptors: rule name, the composite columns, then extras.
    $columns = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    if ($seen.Add($RuleNameColumn)) {
        $columns.Add([pscustomobject]@{ Name = $RuleNameColumn; Candidates = @($RuleNameColumn); Sort = $false; Render = 'list' })
    }
    foreach ($key in $CompositeColumns.Keys) {
        if ($seen.Add($key)) {
            $isProtocolPort = ($key -eq $ProtocolPortColumnName)
            $columns.Add([pscustomobject]@{
                    Name       = $key
                    Candidates = @($CompositeColumns[$key])
                    Sort       = -not $isProtocolPort
                    Render     = if ($isProtocolPort) {
                        'protoport'
                    }
                    else {
                        'list'
                    }
                })
        }
    }
    foreach ($column in $AdditionalColumns) {
        if ($seen.Add($column)) {
            $columns.Add([pscustomobject]@{ Name = $column; Candidates = @($column); Sort = $false; Render = 'list' })
        }
    }

    # Trim candidates to fields the CSV actually has.
    # [comment:2](/docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownColumns.ps1.md#comment2)
    if ($Present.Count -gt 0) {
        foreach ($column in $columns) {
            $column.Candidates = @($column.Candidates | Where-Object { $_ -in $Present })
        }
        $empty = @($columns | Where-Object { $_.Candidates.Count -eq 0 } | ForEach-Object { $_.Name })
        if ($empty.Count) {
            throw "No matching CSV fields for columns: $($empty -join ', '). Present headers: $($Present -join ', ')."
        }
    }

    , $columns
}
