<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownColumns.ps1
    kind: private-function
    module: Catzc.Azure.Firewall
    visibility: private
  config:
    synopsis: Builds the ordered, validated Markdown column descriptors for Convert-FirewallCsvToMarkdown.
    description: |-
      Produces the column list in render order — the rule-name column, then the composite columns, then the
      additional single-field columns — de-duplicated case-insensitively. Each descriptor carries its candidate
      CSV fields, whether its values are sorted, and its render mode ('list' or 'protoport').

      When the CSV's present headers are known (non-empty), each column's candidates are trimmed to fields the
      CSV actually has; a requested column left with no backing field is a schema mismatch and throws — rather
      than silently dropping the column from the output.
    parameters:
      RuleNameColumn: CSV column used as the rule name / first table column.
      CompositeColumns: Ordered map of output column -> candidate CSV fields.
      ProtocolPortColumnName: The composite column rendered as protocol:port pairs (and left unsorted).
      AdditionalColumns: Extra single-field columns appended after the composites.
      Present: The CSV's present header names. Empty means headers are unknown (no rows) — trimming/validation is skipped.
    outputs: '[System.Collections.Generic.List[object]] of descriptors (Name, Candidates, Sort, Render).'
---
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
    # [comment:3](/docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownColumns.ps1.md#comment3)
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
