<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Write-ToolProbeReport.ps1.md"
  header: "generated"
---
#>

function Write-ToolProbeReport {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [Catzc.Base.Execution.ExecutableProbe[]] $Probe
    )

    begin {
        $records = [System.Collections.Generic.List[Catzc.Base.Execution.ExecutableProbe]]::new()
    }
    process {
        foreach ($record in $Probe) {
            $records.Add($record)
        }
    }
    end {
        # The zero-argument call (no -Probe, nothing piped) checks every tool in tools.yml.
        if (-not $MyInvocation.ExpectingInput -and -not $PSBoundParameters.ContainsKey('Probe')) {
            foreach ($tool in (Get-Config -Config tools).Keys) {
                $records.Add((Test-Tool $tool -PassThru))
            }
        }

        if ($records.Count -eq 0) {
            return
        }

        $columns = @('Tool', 'Found', 'Method', 'Version', 'Required', 'VersionOk', 'ProbeMs', 'VersionMs', 'Path')
        $rows = [System.Collections.Generic.List[string[]]]::new()
        $rows.Add([string[]]$columns)
        foreach ($record in $records) {
            $rows.Add([string[]]@(
                    $record.Name, "$($record.Found)", $record.Method, ($record.Version ?? '-'), $record.Required,
                    "$($record.VersionOk)", "$($record.ProbeMs)", "$($record.VersionMs)", ($record.Path ?? '-')
                ))
        }
        $widths = [int[]]::new($columns.Count)
        foreach ($row in $rows) {
            for ($i = 0; $i -lt $columns.Count; $i++) {
                $widths[$i] = [Math]::Max($widths[$i], $row[$i].Length)
            }
        }

        $actors = ($records | ForEach-Object Actor | Sort-Object -Unique) -join ', '
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add("Tool checks (actor: $actors)")
        foreach ($row in $rows) {
            $cells = for ($i = 0; $i -lt $columns.Count; $i++) {
                $row[$i].PadRight($widths[$i])
            }
            $lines.Add(($cells -join '  ').TrimEnd())
        }
        Write-Message ($lines -join [Environment]::NewLine) -NoHeader
    }
}
