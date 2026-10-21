<#
---
catzc:
  immutable:
    with_body_sha: e702cf4cfb29
  edges:
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The check module loads nested in this rule module, inside the analyzer engine; nothing in the session changes, so there is no state to announce')]
param()

Set-StrictMode -Version Latest   # this module's scope: the entry rule runs strict inside the analyzer engine

# The spelling check reads the dictionaries, so it is its own entry rule: a dictionary edit re-runs this rule alone ([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](/docs/adr/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)).
$script:measure = $null

function Measure-CatzcSpelling {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # Only the file's root block: the check walks the whole tree from it.
    if ($ScriptBlockAst.Parent) {
        return
    }

    if ($null -eq $script:measure) {
        $module = Import-Module (Join-Path $PSScriptRoot 'SpellOutIdentifiers.psm1') -PassThru
        $script:measure = $module.ExportedFunctions['Measure-SpellOutIdentifiers']
    }

    & $script:measure -ScriptBlockAst $ScriptBlockAst
}

Export-ModuleMember -Function Measure-CatzcSpelling
