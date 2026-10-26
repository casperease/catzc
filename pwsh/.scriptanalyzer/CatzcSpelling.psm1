[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
    Justification = 'The check module loads nested in this rule module, inside the analyzer engine; nothing in the session changes, so there is no state to announce')]
param()

Set-StrictMode -Version Latest   # this module's scope: the entry rule runs strict inside the analyzer engine

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
