<#
.SYNOPSIS
    Verifies a built Catzc bundle is well-formed and reproducible; throws with every violation.
.DESCRIPTION
    The bundle integrity gate. Given a bundle root (from Build-Catzc, or an installed bundle), it asserts:
      - build.json is present and its recorded content hash matches the tree recomputed now (reproducibility —
        the same bytes yield the same hash, and nothing drifted after the build);
      - the bundle importer.ps1 is present (the load entry point);
      - no tests/ verification surface leaked in (aspect purity — a bundle ships runtime, not its own tests);
      - exactly one prebuilt combined-types DLL is present, so the bundle loads without Roslyn.
    The content hash excludes build.json itself (it carries the hash). Collects all violations and throws once.
.PARAMETER Path
    The bundle root to verify.
.EXAMPLE
    Assert-CatzcBundle -Path (Join-Path (Get-OutputRoot) 'catzc/6.6.666')
#>
function Assert-CatzcBundle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Container
    $violations = [System.Collections.Generic.List[string]]::new()

    $buildFile = Join-Path $Path 'build.json'
    if (-not (Test-Path $buildFile)) {
        $violations.Add('missing build.json')
    }
    else {
        $build = Get-Content $buildFile -Raw | ConvertFrom-Json
        $actual = Get-CatzcContentHash -Path $Path -Exclude 'build.json'
        if ($actual -ne $build.contentHash) {
            $violations.Add("content hash mismatch: build.json records $($build.contentHash) but the tree hashes to $actual")
        }
    }

    if (-not (Test-Path (Join-Path $Path 'importer.ps1'))) {
        $violations.Add('missing bundle importer.ps1')
    }

    $leaked = @([System.IO.Directory]::EnumerateFiles($Path, '*', [System.IO.SearchOption]::AllDirectories) |
            Where-Object { $_.Replace('\', '/') -like '*/tests/*' })
    if ($leaked.Count -gt 0) {
        $violations.Add("$($leaked.Count) test file(s) leaked into the bundle (aspect purity)")
    }

    $compiledDir = Join-Path $Path 'automation/.compiled'
    $dlls = if (Test-Path $compiledDir) {
        @([System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll'))
    }
    else {
        @()
    }
    if ($dlls.Count -ne 1) {
        $violations.Add("expected exactly one prebuilt types DLL under automation/.compiled, found $($dlls.Count)")
    }

    if ($violations.Count -gt 0) {
        throw "Catzc bundle at '$Path' is invalid:`n$($violations -join "`n")"
    }
}
