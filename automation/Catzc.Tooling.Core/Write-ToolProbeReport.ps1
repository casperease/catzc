<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Write-ToolProbeReport.ps1
    kind: automation-function
    module: Catzc.Tooling.Core
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
    adrs:
      - ADR-PWSH-ANNOUNCE#7
  config:
    synopsis: 'Writes a compact table of tool existence checks: where each tool was found, its version, and the timings.'
    description: |-
      Renders the probe records from Test-Tool -PassThru as one plain-text table through Write-Message -NoHeader
      ([ADR-PWSH-ANNOUNCE#7](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce7)): one
      row per tool with Found, Method (probe | path | none), Version against Required, VersionOk, ProbeMs and
      VersionMs, then the path. The header line names the session actor the checks ran as. Writes
      nothing for no records. With no -Probe it checks every tool in tools.yml.
    parameters:
      Probe: |-
        The probe records to render (Catzc.Base.Execution.ExecutableProbe, from Test-Tool -PassThru or
        Resolve-ToolExecutable). Accepts pipeline input. Defaults to every tool in tools.yml.
    examples:
      - Write-ToolProbeReport
      - '''bash'', ''go'' | ForEach-Object { Test-Tool $_ -PassThru } | Write-ToolProbeReport'
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
