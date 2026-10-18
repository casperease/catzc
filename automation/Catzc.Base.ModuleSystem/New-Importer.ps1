<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/New-Importer.ps1
    name: new-importer
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-modulesystem/New-Importer.ps1.md
    test: automation/Catzc.Base.ModuleSystem/tests/New-Importer.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE#11
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-ANNOUNCE#6
---
#>

function New-Importer {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $Force,

        [switch] $DryRun
    )

    Assert-SourceTree

    # The modules folder, relative to the root, as the importer's one constant set it (read back through the resolver), so this
    # generator names no folder of its own and the shim it writes spells the folder from the same place.
    $modulesFolder = [System.IO.Path]::GetRelativePath((Get-RepositoryRoot), (Get-CatzcModulesRoot)) -replace '\\', '/'
    $overlayPath = Join-Path $RepositoryRoot "$modulesFolder/.internal/Catzc.Internal.Importer.psm1"
    if (-not (Test-Path -LiteralPath $overlayPath -PathType Leaf)) {
        throw "New-Importer: overlay not found at '$overlayPath' — the repository must carry the .internal toolset first."
    }

    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($overlayPath, [ref] $null, [ref] $parseErrors)
    if ($parseErrors) {
        throw "New-Importer: cannot parse overlay '$overlayPath':`n$(($parseErrors | ForEach-Object { $_.Message }) -join "`n")"
    }
    $overlay = $ast.Find({
            param($node)
            $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Invoke-Importer'
        }, $true)
    if (-not $overlay -or -not $overlay.Body.ParamBlock) {
        throw "New-Importer: overlay '$overlayPath' does not define Invoke-Importer with a param block."
    }

    $paramLines = foreach ($parameter in $overlay.Body.ParamBlock.Parameters) {
        $typeConstraint = $parameter.Attributes |
            Where-Object { $_ -is [System.Management.Automation.Language.TypeConstraintAst] } |
            Select-Object -First 1
        $typeText = if ($typeConstraint) {
            $typeConstraint.TypeName.Name
        }
        else {
            'object'
        }
        "    [$typeText] `$$($parameter.Name.VariablePath.UserPath)"
    }
    $suppression = "[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', " +
    "Justification = 'Invoke-Importer announces RepositoryRoot on its Roots line, the first point a writer is loaded')]"
    $paramBlock = "$suppression`n" + "[CmdletBinding()]`n" + "param(`n" + ($paramLines -join ",`n") + "`n)"

    $explanation = @'
# This shim carries only the importer's outer parameter form and delegates the whole load sequence to
# Invoke-Importer in {{modules-folder}}/.internal/Catzc.Internal.Importer.psm1 (the single living copy). It is
# dot-sourced (. ./importer.ps1), so its $global:/$env: effects land in the caller's session.
'@

    $body = @'
Set-StrictMode -Version Latest

# Repository root reference — the one path the shim anchors; the toolset reads it from $env:RepositoryRoot.
$env:RepositoryRoot = $PSScriptRoot

# Load the .internal shared-code loader (the one module imported by path), then the importer overlay, and
# delegate. Catzc.Internal.Importer is import-time orchestration — remove it once the load returns. -Verbose is
# for Invoke-Importer's state-change record, not these imports' per-function detail.
Import-Module (Join-Path $PSScriptRoot '{{modules-folder}}/.internal/Catzc.Internal.Loader.psm1') -Scope Global -Force -Verbose:$false
Import-InternalModule Importer -Force -Verbose:$false
try {
    Invoke-Importer @PSBoundParameters
}
finally {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue -Verbose:$false
}
'@

    $content = ($explanation + "`n" + $paramBlock + "`n`n" + $body + "`n").Replace('{{modules-folder}}', $modulesFolder)

    if ($DryRun) {
        return $content
    }

    $target = Join-Path $RepositoryRoot 'importer.ps1'
    if ((Test-Path -LiteralPath $target -PathType Leaf) -and -not $Force) {
        throw "New-Importer: '$target' already exists — pass -Force to overwrite."
    }
    [System.IO.File]::WriteAllText($target, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Message "Generated $target"
    $target
}
