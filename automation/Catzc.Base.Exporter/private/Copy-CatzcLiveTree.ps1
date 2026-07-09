<#
.SYNOPSIS
    Copies the runtime payload of the selected modules into a bundle-staging tree — everything the modules
    need to run, and nothing else.
.DESCRIPTION
    Builds the `automation/` tree a bundle carries, mirroring the repository layout so the same
    path-resolution seams work unchanged (CatzcModulesRoot = the bundle's automation/). Selects from the
    git-tracked universe (Get-GlobSetFile -Name automation) so generated/gitignored files — the per-module
    `.psd1`, the linked README — never ship (Build-Catzc regenerates the manifests into the staging tree).

    The payload is deliberately BROADER than the protection `live` aspect (which excludes assets/ for
    marker-isolation reasons): a running module needs its `assets/` (install scripts, the PrePost starter,
    the gzipped dictionaries), so the rule here is the module's tracked files MINUS its `tests/` verification
    surface. It always carries:
      - each selected module's tracked files, excluding `**/tests/**`;
      - the `.internal` loader/bootstrap/vendor/types shared modules and their assets, excluding tests;
      - the vendored dependencies per -VendorPolicy (runtime = powershell-yaml only; full = all);
      - the single committed combined-types assembly (automation/.compiled/Catzc.Types.<hash>.dll), so the
        bundle loads its types without Roslyn.

    Runs at build time in the mono repo (git available). Returns the repo-relative paths written, ordinally
    sorted — the input to the bundle's content hash.
.PARAMETER Destination
    The bundle root to populate; the tree is written under <Destination>/automation/.
.PARAMETER Module
    The module folder names whose payload to carry (the resolved profile set — Build-Catzc supplies it).
.PARAMETER VendorPolicy
    runtime (default) carries only powershell-yaml; full also carries Pester/PSScriptAnalyzer.
.PARAMETER DryRun
    Compute and return the payload paths without copying anything.
.EXAMPLE
    Copy-CatzcLiveTree -Destination $staging -Module (Get-ModuleProfile -Profile full)
#>
function Copy-CatzcLiveTree {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Destination,

        [Parameter(Mandatory)]
        [string[]] $Module,

        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy = 'runtime',

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Destination
    $repoRoot = Get-RepositoryRoot

    $modulePrefixes = foreach ($moduleName in $Module) {
        "automation/$moduleName/"
    }
    $vendorPrefix = if ($VendorPolicy -eq 'full') {
        'automation/.vendor/'
    }
    else {
        'automation/.vendor/powershell-yaml/'
    }

    $selected = [System.Collections.Generic.List[string]]::new()
    foreach ($member in (Get-GlobSetFile -Name automation)) {
        # The verification surface never ships.
        if ($member -like '*/tests/*') {
            continue
        }
        $underModule = $false
        foreach ($prefix in $modulePrefixes) {
            if ($member.StartsWith($prefix)) {
                $underModule = $true
                break
            }
        }
        $isInfra = $member.StartsWith('automation/.internal/') -or $member.StartsWith($vendorPrefix)
        if ($underModule -or $isInfra) {
            $selected.Add($member)
        }
    }

    # The committed combined-types assembly is not part of the automation globset; carry the single current
    # build so the bundle loads types without Roslyn. Exactly one must exist (ADR-AUTO-TYPES: .compiled holds one).
    $compiledDir = [System.IO.Path]::Combine($repoRoot, 'automation', '.compiled')
    $dlls = @([System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll'))
    if ($dlls.Count -ne 1) {
        throw "Expected exactly one automation/.compiled/Catzc.Types.*.dll to carry, found $($dlls.Count). Restart PowerShell and re-run Clear-ModuleTypeCache so a single current build remains."
    }
    $selected.Add('automation/.compiled/' + [System.IO.Path]::GetFileName($dlls[0]))

    $selected.Sort([System.StringComparer]::Ordinal)

    if (-not $DryRun) {
        foreach ($member in $selected) {
            $source = [System.IO.Path]::Combine($repoRoot, $member.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
            $target = [System.IO.Path]::Combine($Destination, $member.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target)) | Out-Null
            [System.IO.File]::Copy($source, $target, $true)
        }
    }

    $selected.ToArray()
}
