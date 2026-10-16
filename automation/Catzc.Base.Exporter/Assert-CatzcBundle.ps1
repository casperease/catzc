<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
    name: assert-catzc-bundle
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-exporter/Assert-CatzcBundle.ps1.md
    test: automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
    cites:
      - ADR-AUTO-BUNDLE#5
      - ADR-PWSH-ENUM#3
  config:
    synopsis: |-
      Verifies a Catzc build (or an install of one) is complete and unchanged since it was built; throws with every
      violation.
    description: |-
      The build's integrity guard ([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)).
      Given a build root — out/automation/built/<bundle>/Catzc/<version>/,
      or an installed copy — it asserts:
        - layout: build.json, Catzc.psd1, Catzc.psm1, Import-Catzc.ps1 and the .internal loader are present, and the
          folder is named for build.json's version (a valid Catzc/<version>/ module folder);
        - no tests/ surface anywhere outside .vendor/ (vendored modules are copied verbatim, by rule);
        - types: exactly one .compiled/Catzc.Types.<hash>.dll, named for build.json typesHash. Every build ships the
          full type set: the selected modules' sources under <Module>/types/, every other module's under
          .compiled/types/<Module>/. build.json typeSources lists them all (build-relative paths); each must exist,
          no shipped source may be missing from the list, and the sources in the list must hash (Get-CombinedTypeHash,
          the one implementation) to typesHash — "the DLL was built from these sources" is proven by hash;
        - modules: the module folders are exactly build.json's modules; each has its <Module>.psd1 and merged
          <Module>.functions.ps1, the manifest's NestedModules is exactly that one file (a nested <Module>.ps1 would
          load a second module named <Module>, which Get-Module, Mock -ModuleName and InModuleScope reject), and
          every FunctionsToExport name resolves to a top-level function in the merged file (AST);
        - content: Get-CatzcContentHash over the tree (build.json excluded — it carries the hash) equals build.json
          contentHash, so nothing drifted after the build.
      Collects every violation and throws once. Build-Modules runs it on its own output; Install-Catzc runs it on
      the build before touching a destination.
    parameters:
      Path: The build root to verify (the Catzc/<version>/ folder).
    examples:
      - Assert-CatzcBundle -Path (Join-Path (Get-OutputRoot) 'automation/built/full/Catzc/6.6.666')
---
#>

function Assert-CatzcBundle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Container
    $root = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
    $violations = [System.Collections.Generic.List[string]]::new()

    foreach ($required in @('Catzc.psd1', 'Catzc.psm1', 'Import-Catzc.ps1', '.internal/Catzc.Internal.Loader.psm1', '.internal/assets/types-load.yml')) {
        if (-not [System.IO.File]::Exists([System.IO.Path]::Combine($root, $required))) {
            $violations.Add("missing $required")
        }
    }

    $build = $null
    $buildFile = [System.IO.Path]::Combine($root, 'build.json')
    if (-not [System.IO.File]::Exists($buildFile)) {
        $violations.Add('missing build.json')
    }
    else {
        $build = [System.IO.File]::ReadAllText($buildFile) | ConvertFrom-Json -AsHashtable
        foreach ($field in @('bundle', 'version', 'contentHash', 'typesHash', 'typeSources', 'modules')) {
            if (-not $build.ContainsKey($field) -or @($build[$field]).Count -eq 0 -or "$($build[$field])" -eq '') {
                $violations.Add("build.json records no $field")
            }
        }
    }

    $files = foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @() -PruneVendor $false) {
        [System.IO.Path]::GetRelativePath($root, $file).Replace('\', '/')
    }
    $files = @($files)

    # No verification surface ships. Vendored modules are verbatim copies (powershell-yaml carries its own Tests/).
    $leaked = @($files | Where-Object { -not $_.StartsWith('.vendor/') -and "/$_" -match '(?i)/tests/' })
    if ($leaked.Count -gt 0) {
        $violations.Add("$($leaked.Count) test file(s) shipped in the build: $(@($leaked | Select-Object -First 5) -join ', ')")
    }

    $dlls = @($files | Where-Object { $_ -match '^\.compiled/Catzc\.Types\.[^/]+\.dll$' })
    if ($dlls.Count -ne 1) {
        $violations.Add("expected exactly one .compiled/Catzc.Types.<hash>.dll, found $($dlls.Count) $($dlls -join ', ')".TrimEnd())
    }

    $manifests = @($files | Where-Object { $_ -match '^\.compiled/Catzc\.Types\.[^/]+\.json$' })
    if ($manifests.Count -ne 1) {
        $violations.Add("expected exactly one .compiled/Catzc.Types.<hash>.json, found $($manifests.Count) $($manifests -join ', ')".TrimEnd())
    }
    elseif ($dlls.Count -eq 1 -and $manifests[0] -ne [System.IO.Path]::ChangeExtension($dlls[0], 'json')) {
        $violations.Add("types manifest $($manifests[0]) is not named for the types DLL $($dlls[0])")
    }

    if ($null -ne $build) {
        if ($build['version'] -and [System.IO.Path]::GetFileName($root) -ne "$($build['version'])") {
            $violations.Add("folder '$([System.IO.Path]::GetFileName($root))' does not match build.json version $($build['version']) (a build lives in Catzc/<version>/)")
        }

        $typesHash = "$($build['typesHash'])"
        if ($typesHash -and $dlls.Count -eq 1 -and $dlls[0] -ne ".compiled/Catzc.Types.$typesHash.dll") {
            $violations.Add("types DLL $($dlls[0]) does not match build.json typesHash $typesHash")
        }

        $recordedSources = @($build['typeSources'] | Where-Object { $_ } | ForEach-Object { "$_" })
        if ($typesHash -and $recordedSources.Count -gt 0) {
            # Shipped sources: <Module>/types/<File>.cs (selected) and .compiled/types/<Module>/<File>.cs (the rest).
            $shipped = @($files | Where-Object { $_ -match '^[^./][^/]*/types/[^/]+\.cs$' -or $_ -match '^\.compiled/types/[^/]+/[^/]+\.cs$' })
            foreach ($source in $shipped) {
                if ($source -notin $recordedSources) {
                    $violations.Add("type source $source ships but is not in build.json typeSources")
                }
            }

            $staging = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "catzc-types-$([System.Guid]::NewGuid().ToString('N'))")
            try {
                $sourcesComplete = $true
                foreach ($source in $recordedSources) {
                    $module = $null
                    if ($source -match '^(?<module>[^./][^/]*)/types/(?<file>[^/]+\.cs)$' -or $source -match '^\.compiled/types/(?<module>[^/]+)/(?<file>[^/]+\.cs)$') {
                        $module = $Matches['module']
                        $fileName = $Matches['file']
                    }
                    $absolute = [System.IO.Path]::Combine($root, $source)
                    if ($null -eq $module) {
                        $violations.Add("build.json typeSources entry '$source' is neither <Module>/types/<File>.cs nor .compiled/types/<Module>/<File>.cs")
                        $sourcesComplete = $false
                    }
                    elseif (-not [System.IO.File]::Exists($absolute)) {
                        $violations.Add("type source $source is recorded in build.json but missing")
                        $sourcesComplete = $false
                    }
                    else {
                        $stagedDir = [System.IO.Path]::Combine($staging, $module, 'types')
                        [System.IO.Directory]::CreateDirectory($stagedDir) | Out-Null
                        [System.IO.File]::Copy($absolute, [System.IO.Path]::Combine($stagedDir, $fileName), $true)
                    }
                }
                if ($sourcesComplete) {
                    Import-InternalModule Types
                    $actualTypesHash = (Get-CombinedTypeHash -AutomationRoot $staging).CombinedHash
                    if ($actualTypesHash -ne $typesHash) {
                        $violations.Add("type sources hash to $actualTypesHash but build.json typesHash is $typesHash (the DLL was not built from the shipped sources)")
                    }
                }
            }
            finally {
                if ([System.IO.Directory]::Exists($staging)) {
                    [System.IO.Directory]::Delete($staging, $true)
                }
            }
        }

        if ($build['contentHash']) {
            $actual = Get-CatzcContentHash -Path $root -Exclude 'build.json'
            if ($actual -ne "$($build['contentHash'])") {
                $violations.Add("content hash mismatch: build.json records $($build['contentHash']) but the tree hashes to $actual")
            }
        }
    }

    # Modules: the folders on disk are what the importer loads; build.json is what was built. They must agree.
    $onDisk = @(foreach ($directory in [System.IO.Directory]::EnumerateDirectories($root)) {
            $name = [System.IO.Path]::GetFileName($directory)
            if (-not $name.StartsWith('.')) {
                $name
            }
        })
    if ($null -ne $build -and $build['modules']) {
        $recorded = @($build['modules'] | ForEach-Object { "$_" })
        foreach ($name in @($recorded | Where-Object { $_ -notin $onDisk })) {
            $violations.Add("module '$name' is recorded in build.json but has no folder")
        }
        foreach ($name in @($onDisk | Where-Object { $_ -notin $recorded })) {
            $violations.Add("module folder '$name' is not recorded in build.json")
        }
    }

    $isFunction = { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }
    foreach ($name in $onDisk) {
        $manifestPath = [System.IO.Path]::Combine($root, $name, "$name.psd1")
        $mergedFile = "$name.functions.ps1"
        $mergedPath = [System.IO.Path]::Combine($root, $name, $mergedFile)
        $hasManifest = [System.IO.File]::Exists($manifestPath)
        $hasMerged = [System.IO.File]::Exists($mergedPath)
        if (-not $hasManifest) {
            $violations.Add("module '$name' is missing its manifest $name/$name.psd1")
        }
        if (-not $hasMerged) {
            $violations.Add("module '$name' is missing its merged $name/$mergedFile")
        }
        if (-not ($hasManifest -and $hasMerged)) {
            continue
        }

        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($mergedPath, [ref]$tokens, [ref]$parseErrors)
        if ($parseErrors.Count -gt 0) {
            $violations.Add("module '$name': $mergedFile does not parse ($($parseErrors[0].Message))")
            continue
        }
        # Top-level functions only — a function nested in another is not what the manifest exports.
        $defined = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($function in $ast.FindAll($isFunction, $false)) {
            [void]$defined.Add($function.Name)
        }

        $manifest = Import-PowerShellDataFile -Path $manifestPath
        $nested = @()
        if ($manifest.ContainsKey('NestedModules')) {
            $nested = @($manifest['NestedModules'] | Where-Object { $_ } | ForEach-Object { "$_" })
        }
        if ($nested.Count -ne 1 -or $nested[0] -ne $mergedFile) {
            $violations.Add("module '$name': its manifest's NestedModules must be exactly '$mergedFile', found '$($nested -join "', '")'")
        }
        $exports = @()
        if ($manifest.ContainsKey('FunctionsToExport')) {
            $exports = @($manifest['FunctionsToExport'] | Where-Object { $_ })
        }
        $unresolved = @($exports | Where-Object { -not $defined.Contains("$_") })
        if ($unresolved.Count -gt 0) {
            $violations.Add("module '$name' exports function(s) its merged $mergedFile does not define: $($unresolved -join ', ')")
        }
    }

    if ($violations.Count -gt 0) {
        throw "Catzc build at '$Path' is invalid:`n$($violations -join "`n")"
    }
}
