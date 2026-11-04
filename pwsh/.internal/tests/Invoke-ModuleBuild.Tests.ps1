# cspell:ignore nfunction  -- the escape-sequence artifact in the "`nfunction" fixture strings
# cspell:ignore dependenc  -- the stem a message match shares between "dependency" and "dependencies"
BeforeAll {
    Import-InternalModule TestKit
    Import-InternalModule Builder

    $script:helpText = "<#`r`n.SYNOPSIS`r`n    Returns the widget.`r`n#>`r`nfunction Get-Widget {`r`n    Get-WidgetCore`r`n}`r`n`r`n"
    $script:fake = New-FakeRepositoryRoot -Modules @{
        'Catzc.Base.Widget'       = @{
            Public  = 'Set-Widget'
            Private = 'Get-WidgetCore'
            Files   = @{
                'Get-Widget.ps1'             = $helpText
                'configs/widget.yml'         = "size: 1`n"
                'assets/widget.txt'          = 'widget asset'
                'tests/Get-Widget.Tests.ps1' = "Describe 'x' { }"
                'README.md'                  = '# widget'
                'Catzc.Base.Widget.psd1'     = '@{ }'
            }
        }
        'Catzc.Base.Gadget'       = @{
            Public = 'Get-Gadget'
            Files  = @{
                'types/Lever.cs'       = "namespace Catzc.Base.Gadget;`npublic class Lever { }`n"
                'Get-GadgetWidget.ps1' = "function Get-GadgetWidget {`n    Get-Widget`n    Get-Config -Config widget`n    Get-Config -Config widget -ListOwners`n}`n"
            }
        }
        'Catzc.Base.Gizmo'        = @{
            Public = 'Get-Gizmo'
            Files  = @{
                'types/Sprocket.cs'        = "namespace Catzc.Base.Gizmo;`npublic class Sprocket { }`n"
                'Get-GizmoPair.ps1'        = "function Get-GizmoPair { }`nfunction Get-GizmoOther { }"
                'Get-GizmoName.ps1'        = 'function Get-SomethingElse { }'
                'Get-GizmoAnchor.ps1'      = "function Get-GizmoAnchor {`n    Join-Path `$PSScriptRoot 'assets'`n}"
                'private/Get-GizmoReq.ps1' = "#requires -Version 7.4`nfunction Get-GizmoReq { }"
                'private/Get-GizmoTop.ps1' = "`$script:cacheEntry = 1`nfunction Get-GizmoTop { }"
            }
        }
        'Catzc.Base.QualityGates' = @{
            Public = 'Test-Gate'
        }
    } -Files @{
        "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.Bootstrap.psm1"                = '# bootstrap'
        "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.Importer.psm1"                 = '# importer'
        "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.Loader.psm1"                   = '# loader'
        "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.Types.psm1"                    = '# types'
        "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.Vendor.psm1"                   = '# vendor'
        "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.Builder.psm1"                  = '# builder (never ships)'
        "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.TestKit.psm1"                  = '# testkit (ships with the gates module only)'
        "$(Get-CatzcModulesFolder)/.internal/tests/Get-Loader.Tests.ps1"                   = '# test (never ships)'
        "$(Get-CatzcModulesFolder)/.internal/assets/Invoke-WidgetBurst.ps1"                = '# dev tool no glob names (never ships)'
        "$(Get-CatzcModulesFolder)/.internal/assets/ErrorView.format.ps1xml"               = '<Configuration />'
        "$(Get-CatzcModulesFolder)/.internal/assets/Wait-CatzcRunLock.ps1"                 = '# run-lock function'
        "$(Get-CatzcModulesFolder)/.internal/assets/bootstrap/Get-ModuleNamespace.ps1"     = '# bootstrap function'
        "$(Get-CatzcModulesFolder)/.internal/assets/bootstrap/Import-AllModules.ps1"       = '# bootstrap function'
        "$(Get-CatzcModulesFolder)/.internal/assets/bootstrap/Import-CSharpTypes.ps1"      = '# bootstrap function'
        "$(Get-CatzcModulesFolder)/.internal/assets/bootstrap/Resolve-ModuleName.ps1"      = '# bootstrap function'
        "$(Get-CatzcModulesFolder)/.internal/assets/importer/Get-DueWriterRow.ps1"         = '# importer function'
        "$(Get-CatzcModulesFolder)/.internal/assets/importer/Invoke-ImporterJanitors.ps1"  = '# importer function'
        "$(Get-CatzcModulesFolder)/.internal/assets/importer/Test-WriterDue.ps1"           = '# importer function'
        "$(Get-CatzcModulesFolder)/.internal/assets/importer/Wait-ImportBurst.ps1"         = '# importer function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types-load.yml"                        = 'cells: {}'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Build-CombinedTypeAssembly.ps1"  = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Get-CombinedTypeHash.ps1"        = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Get-LoadedTypeDrift.ps1"         = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Get-TypeSourceBody.ps1"          = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Get-TypesAssemblyManifest.ps1"   = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Get-TypesContractDrift.ps1"      = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Get-TypesContractPath.ps1"       = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Write-TypesAssemblyManifest.ps1" = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/types/Write-TypesContract.ps1"         = '# types function'
        "$(Get-CatzcModulesFolder)/.internal/assets/PSScriptAnalyzerSettings.psd1"         = '@{ }'
        "$(Get-CatzcModulesFolder)/.internal/assets/Import-Catzc.ps1"                      = "# initializer`r`n"
        "$(Get-CatzcModulesFolder)/.vendor/powershell-yaml/0.4.12/powershell-yaml.psd1"    = '@{ }'
        # A file git stores with CRLF (kept as-is by -text, the way a signed vendored script must be).
        "$(Get-CatzcModulesFolder)/.vendor/powershell-yaml/0.4.12/Signed.ps1"              = "# signed`r`n"
        '.gitattributes'                                                                   = "$(Get-CatzcModulesFolder)/.vendor/powershell-yaml/0.4.12/Signed.ps1 -text`n"
        '.gitignore'                                                                       = "*.log`n"
        "$(Get-CatzcModulesFolder)/.vendor/Pester/5.7.1/Pester.psd1"                       = '@{ }'
        "$(Get-CatzcModulesFolder)/.scriptanalyzer/WidgetRule.psm1"                        = '# rule'
        "$(Get-CatzcModulesFolder)/.scriptanalyzer/tests/WidgetRule.Tests.ps1"             = '# rule test (never ships)'
        'bash/.vendor/bats-core/bin/bats'                                                  = '# widget runner'
    }
    $script:source = $fake.ModulesRoot

    # The build compiles the full-set DLL, named by the hash of EVERY module's types.
    $script:fullHash = (Get-CombinedTypeHash -ModulesRoot $source).CombinedHash

    if (Get-Command git -ErrorAction Ignore) {
        foreach ($gitCommand in @(
                'git init -q'
                'git config core.autocrlf true'
                'git add -A'
                'git -c user.name=widget -c user.email=widget@example.invalid commit -q -m fixture'
            )) {
            Invoke-Executable $gitCommand -WorkingDirectory $fake.Root -Silent
        }
    }

    $script:metadata = @{
        Guid        = '01d6e700-b011-d000-0000-000000000000'
        Author      = 'Widget Author'
        CompanyName = 'Gadget Co'
        Description = "Widget's package"
        Tags        = @('widget', 'gadget')
        ProjectUri  = 'https://example.invalid/widget'
        LicenseUri  = ''
    }
    $script:buildArguments = @{
        Version         = '1.2.3'
        Bundle          = 'widgets'
        PackageMetadata = $metadata
    }

    Mock Assert-CatzcSourceTree { } -ModuleName Catzc.Internal.Builder
    Mock Get-GitCurrentCommit { 'f00df00df00df00df00df00df00df00df00df00d' } -ModuleName Catzc.Internal.Builder
    Mock Get-ModuleProfile -ModuleName Catzc.Internal.Builder -RemoveParameterValidation Name {
        if ($PesterBoundParameters.ContainsKey('Name')) {
            @{ widgets = @('Catzc.Base.Widget'); gizmos = @('Catzc.Base.Gizmo') }[$Name]
        }
        else {
            # Closure: gadget depends on widget.
            [string[]] @(@($Modules) + @(if ('Catzc.Base.Gadget' -in $Modules) {
                        'Catzc.Base.Widget'
                    }) | Sort-Object -Unique)
        }
    }
    # One snapshot of the live configs the build reads, so a peer's burst that swaps one between two builds never changes a hash.
    $script:configSnapshot = @{}
    foreach ($configName in 'languages', 'exporter') {
        $script:configSnapshot[$configName] = Get-Config -Config $configName
    }
    Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -in 'languages', 'exporter' -and -not $ListOwners } {
        $script:configSnapshot[$Config]
    }
    # Every build fills the store, so the store of these builds lives in the test drive, never in the real output root.
    Mock Get-OutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Internal.Builder
    # The fake repository carries no types contract; the surface check has its own tests, and one case below makes it fail.
    Mock Get-TypesContractDrift { } -ModuleName Catzc.Internal.Builder
    Mock Get-InternalAssetDependency -ModuleName Catzc.Internal.Builder {
        [pscustomobject]@{ Module = 'Catzc.Base.Widget'; Function = 'Get-Widget'; ChildPath = 'assets/widget.txt'; File = (Get-CatzcModulesFolder) + '/Catzc.Base.Widget/Get-Widget.ps1'; Line = 5 }
    }

    function script:Get-FileSnapshot {
        param([string] $Root)
        $snapshot = @{}
        foreach ($file in Get-ChildPath $Root -File -Depth 64 -Exclude @() -PruneVendor $false) {
            $snapshot[[System.IO.Path]::GetRelativePath($Root, $file).Replace('\',
                '/')] = [System.IO.File]::GetLastWriteTimeUtc($file).Ticks
        }
        $snapshot
    }
}

AfterAll {
    Remove-FakeRepositoryRoot $fake
}

Describe 'Invoke-ModuleBuild' -Tag 'L2', 'logic', 'source-only' -Skip:(-not (Get-Command git -ErrorAction Ignore)) {
    Context 'a dry run' {
        It 'returns the plan and writes nothing' {
            $destination = Join-Path $TestDrive 'dry'
            $plan = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Module 'Catzc.Base.Gadget' -Destination $destination -DryRun
            $plan.DryRun | Should -BeTrue
            $plan.Modules | Should -Be @('Catzc.Base.Gadget', 'Catzc.Base.Widget')
            $plan.TypesHash | Should -Be $fullHash
            $plan.ContentHash | Should -BeNullOrEmpty
            $plan.FileCount | Should -BeGreaterThan 10
            $plan.BuildRoot | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $destination 'Catzc/1.2.3')))
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }

        It 'reports the source stamp and the store build root the build would fill' {
            $plan = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'dry-stamp') -DryRun
            $plan.SourceStamp | Should -Not -BeNullOrEmpty
            $plan.StoreRoot.Replace('\', '/') | Should -BeLike "*/built/widgets/$($plan.SourceStamp.Substring(0, 12))/Catzc/1.2.3"
            [System.IO.Directory]::Exists($plan.StoreRoot) | Should -BeFalse
        }
    }

    Context 'a build of a profile plus an explicit module' {
        BeforeAll {
            $script:destination = Join-Path $TestDrive 'build'
            $script:result = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Module 'Catzc.Base.Gadget' -Destination $destination
            $script:root = $result.BuildRoot
            $script:files = @(foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @() -PruneVendor $false) {
                    [System.IO.Path]::GetRelativePath($root, $file).Replace('\', '/')
                })
        }

        It 'unions the profile and the explicit modules, closure-expanded, in ordinal order' {
            $result.Modules | Should -Be @('Catzc.Base.Gadget', 'Catzc.Base.Widget')
            Should -Invoke Get-ModuleProfile -ModuleName Catzc.Internal.Builder -Scope Context -Times 1 -Exactly -ParameterFilter { $Name -eq 'widgets' }
            Should -Invoke Get-ModuleProfile -ModuleName Catzc.Internal.Builder -Scope Context -Times 1 -Exactly -ParameterFilter { $Modules -contains 'Catzc.Base.Gadget' }
            $files | Where-Object { $_ -like 'Catzc.Base.Gizmo/*' } | Should -BeNullOrEmpty
        }

        It 'writes exactly the planned layout — and never tests, the builder, the test kit, or a source manifest' {
            $expected = @(
                '.compiled/Catzc.Types.{0}.dll' -f $fullHash
                '.compiled/Catzc.Types.{0}.json' -f $fullHash
                '.compiled/types/Catzc.Base.Gizmo/Sprocket.cs'
                '.internal/Catzc.Internal.Bootstrap.psm1'
                '.internal/Catzc.Internal.Importer.psm1'
                '.internal/Catzc.Internal.Loader.psm1'
                '.internal/Catzc.Internal.Types.psm1'
                '.internal/Catzc.Internal.Vendor.psm1'
                '.internal/assets/ErrorView.format.ps1xml'
                '.internal/assets/Wait-CatzcRunLock.ps1'
                '.internal/assets/bootstrap/Get-ModuleNamespace.ps1'
                '.internal/assets/bootstrap/Import-AllModules.ps1'
                '.internal/assets/bootstrap/Import-CSharpTypes.ps1'
                '.internal/assets/bootstrap/Resolve-ModuleName.ps1'
                '.internal/assets/importer/Get-DueWriterRow.ps1'
                '.internal/assets/importer/Invoke-ImporterJanitors.ps1'
                '.internal/assets/importer/Test-WriterDue.ps1'
                '.internal/assets/importer/Wait-ImportBurst.ps1'
                '.internal/assets/types-load.yml'
                '.internal/assets/types/Build-CombinedTypeAssembly.ps1'
                '.internal/assets/types/Get-CombinedTypeHash.ps1'
                '.internal/assets/types/Get-LoadedTypeDrift.ps1'
                '.internal/assets/types/Get-TypeSourceBody.ps1'
                '.internal/assets/types/Get-TypesAssemblyManifest.ps1'
                '.internal/assets/types/Get-TypesContractDrift.ps1'
                '.internal/assets/types/Get-TypesContractPath.ps1'
                '.internal/assets/types/Write-TypesAssemblyManifest.ps1'
                '.internal/assets/types/Write-TypesContract.ps1'
                '.vendor/powershell-yaml/0.4.12/powershell-yaml.psd1'
                '.vendor/powershell-yaml/0.4.12/Signed.ps1'
                'Catzc.Base.Gadget/Catzc.Base.Gadget.functions.ps1'
                'Catzc.Base.Gadget/Catzc.Base.Gadget.psd1'
                'Catzc.Base.Gadget/types/Lever.cs'
                'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'
                'Catzc.Base.Widget/Catzc.Base.Widget.psd1'
                'Catzc.Base.Widget/assets/widget.txt'
                'Catzc.Base.Widget/configs/widget.yml'
                'Catzc.psd1'
                'Catzc.psm1'
                'Import-Catzc.ps1'
                'build.json'
            )
            $sorted = [string[]] $files
            [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
            [System.Array]::Sort($expected, [System.StringComparer]::Ordinal)
            $sorted | Should -Be $expected
            $result.FileCount | Should -Be $expected.Count
        }

        It 'merges private/*.ps1 then the root *.ps1, each ordinal, behind one source marker per file' {
            $text = [System.IO.File]::ReadAllText((Join-Path $root 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'))
            $markers = @([regex]::Matches($text, '(?m)^# source: (.+)$') | ForEach-Object { $_.Groups[1].Value })
            $markers | Should -Be @(
                "$(Get-CatzcModulesFolder)/Catzc.Base.Widget/private/Get-WidgetCore.ps1"
                "$(Get-CatzcModulesFolder)/Catzc.Base.Widget/Get-Widget.ps1"
                "$(Get-CatzcModulesFolder)/Catzc.Base.Widget/Set-Widget.ps1"
            )
        }

        It 'takes each file verbatim — its comment-based help stays right before its function' {
            $text = [System.IO.File]::ReadAllText((Join-Path $root 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'))
            $verbatim = $helpText.Replace("`r", '').TrimEnd("`n")
            $text | Should -BeLike "*# source: pwsh/Catzc.Base.Widget/Get-Widget.ps1`n$verbatim`n`n*"
        }

        It 'writes canonical bytes: UTF-8 without BOM, LF only, one trailing newline' {
            foreach ($relativePath in 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1', 'Catzc.psd1', 'Catzc.psm1',
                'build.json', 'Catzc.Base.Widget/Catzc.Base.Widget.psd1') {
                $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root $relativePath))
                $bytes[0] | Should -Not -Be 0xEF -Because "$relativePath carries no BOM"
                $bytes | Should -Not -Contain 13 -Because "$relativePath has LF endings only"
                $bytes[-1] | Should -Be 10 -Because "$relativePath ends with a newline"
                $bytes[-2] | Should -Not -Be 10 -Because "$relativePath ends with exactly one newline"
            }
        }

        It 'copies side folders and the initializer as git stores them: LF-stored text LF, the rest byte for byte' {
            [System.IO.File]::ReadAllText((Join-Path $root 'Catzc.Base.Widget/assets/widget.txt')) |
                Should -BeExactly 'widget asset'
            # CRLF on disk, LF in git: the bundle carries git's LF, whatever the checkout wrote.
            [System.IO.File]::ReadAllText((Join-Path $fake.ModulesRoot '.internal/assets/Import-Catzc.ps1')) |
                Should -BeExactly "# initializer`r`n"
            [System.IO.File]::ReadAllText((Join-Path $root 'Import-Catzc.ps1')) | Should -BeExactly "# initializer`n"
            # CRLF in git (-text): kept byte for byte.
            [System.IO.File]::ReadAllText((Join-Path $root '.vendor/powershell-yaml/0.4.12/Signed.ps1')) |
                Should -BeExactly "# signed`r`n"
        }

        It 'records a clean source tree as not dirty' {
            $result.Dirty | Should -BeFalse
            (Get-Content -Raw (Join-Path $root 'build.json') | ConvertFrom-Json).dirty | Should -BeFalse
        }

        It 'yields the same content hash whatever line endings the checkout wrote' {
            $initializer = Join-Path $fake.ModulesRoot '.internal/assets/Import-Catzc.ps1'
            try {
                [System.IO.File]::WriteAllText($initializer, "# initializer`n")
                $lfCheckout = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Module 'Catzc.Base.Gadget' -Destination (Join-Path $TestDrive 'lf-checkout')
                $lfCheckout.Dirty | Should -BeFalse -Because 'an LF checkout of an LF-stored file is the same commit'
                $lfCheckout.ContentHash | Should -Be $result.ContentHash
            }
            finally {
                [System.IO.File]::WriteAllText($initializer, "# initializer`r`n")
            }
        }

        It 'generates each module manifest over the one merged file, exporting the public functions only' {
            $manifest = Import-PowerShellDataFile (Join-Path $root 'Catzc.Base.Widget/Catzc.Base.Widget.psd1')
            # Named apart from the manifest, so the nested script module never shares the module's name.
            @($manifest.NestedModules) | Should -Be @('Catzc.Base.Widget.functions.ps1')
            @($manifest.FunctionsToExport) | Should -Be @('Get-Widget', 'Set-Widget')
        }

        It 'generates the package manifest with the union of the public functions and the metadata' {
            $manifest = Import-PowerShellDataFile (Join-Path $root 'Catzc.psd1')
            $manifest.RootModule | Should -Be 'Catzc.psm1'
            $manifest.ModuleVersion | Should -Be '1.2.3'
            $manifest.GUID | Should -Be $metadata.Guid
            $manifest.Description | Should -Be "Widget's package"
            @($manifest.FunctionsToExport) | Should -Be @('Get-Gadget', 'Get-GadgetWidget', 'Get-Widget', 'Set-Widget')
            @($manifest.PrivateData.PSData.Tags) | Should -Be @('widget', 'gadget')
            $manifest.PrivateData.PSData.ProjectUri | Should -Be 'https://example.invalid/widget'
            $manifest.PrivateData.PSData.ContainsKey('LicenseUri') | Should -BeFalse
        }

        It 'writes a root module that dot-sources the initializer' {
            [System.IO.File]::ReadAllText((Join-Path $root 'Catzc.psm1')) |
                Should -BeLike "*. (Join-Path `$PSScriptRoot 'Import-Catzc.ps1')*"
        }

        It 'ships the full type set: the DLL compiled into the bundle, unselected sources under .compiled/types' {
            $result.TypesHash | Should -Be $fullHash
            Join-Path $root ".compiled/Catzc.Types.$fullHash.dll" | Should -Exist
            Join-Path $root ".compiled/Catzc.Types.$fullHash.json" | Should -Exist
            [System.IO.File]::ReadAllText((Join-Path $root '.compiled/types/Catzc.Base.Gizmo/Sprocket.cs')) |
                Should -BeExactly "namespace Catzc.Base.Gizmo;`npublic class Sprocket { }`n"
        }

        It 'records provenance in build.json, with a content hash over everything but build.json' {
            $record = Get-Content -Raw (Join-Path $root 'build.json') | ConvertFrom-Json
            $record.bundle | Should -Be 'widgets'
            $record.version | Should -Be '1.2.3'
            $record.typesHash | Should -Be $fullHash
            @($record.typeSources) | Should -Be @('Catzc.Base.Gadget/types/Lever.cs',
                '.compiled/types/Catzc.Base.Gizmo/Sprocket.cs')
            $record.sourceCommit | Should -Be 'f00df00df00df00df00df00df00df00df00df00d'
            $record.PSObject.Properties.Name | Should -Not -Contain 'vendorPolicy'
            @($record.modules) | Should -Be @('Catzc.Base.Gadget', 'Catzc.Base.Widget')
            $record.contentHash | Should -Be $result.ContentHash
            $result.ContentHash | Should -Be (Get-ContentHash -Path $root -Exclude 'build.json')
        }

        It 'is idempotent: a rebuild of unchanged sources writes nothing and yields the same content hash' {
            $before = Get-FileSnapshot $root
            $again = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Module 'Catzc.Base.Gadget' -Destination $destination
            $after = Get-FileSnapshot $root
            $again.ContentHash | Should -Be $result.ContentHash
            $after.Keys.Count | Should -Be $before.Keys.Count
            foreach ($key in $before.Keys) {
                $after[$key] | Should -Be $before[$key] -Because "$key must not be rewritten"
            }
        }

        It 'converges: a rebuild removes what the plan no longer names' {
            [System.IO.File]::WriteAllText((Join-Path $root 'stray.txt'), 'stray')
            [System.IO.Directory]::CreateDirectory((Join-Path $root 'Catzc.Base.Stale/configs')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $root 'Catzc.Base.Stale/configs/stale.yml'), 'x: 1')
            [System.IO.File]::WriteAllText((Join-Path $root '.compiled/Catzc.Types.00000000.dll'), 'old')
            $again = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Module 'Catzc.Base.Gadget' -Destination $destination
            Test-Path (Join-Path $root 'stray.txt') | Should -BeFalse
            Test-Path (Join-Path $root 'Catzc.Base.Stale') | Should -BeFalse
            Test-Path (Join-Path $root '.compiled/Catzc.Types.00000000.dll') | Should -BeFalse
            $again.ContentHash | Should -Be $result.ContentHash
        }
    }

    Context 'a source tree that differs from its commit' {
        BeforeAll {
            # New work on a devbox, and scratch git ignores (*.log).
            $script:untracked = Join-Path $fake.ModulesRoot 'Catzc.Base.Widget/assets/untracked.txt'
            $script:ignored = Join-Path $fake.ModulesRoot 'Catzc.Base.Widget/assets/scratch.log'
            [System.IO.File]::WriteAllText($untracked, 'not in git yet')
            [System.IO.File]::WriteAllText($ignored, 'ignored by git')
        }

        AfterAll {
            [System.IO.File]::Delete($untracked)
            [System.IO.File]::Delete($ignored)
        }

        It 'ships new untracked work but never an ignored file, and records the build as dirty' {
            $dirtyBuild = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'dirty')
            $dirtyBuild.Dirty | Should -BeTrue
            (Get-Content -Raw (Join-Path $dirtyBuild.BuildRoot 'build.json') | ConvertFrom-Json).dirty | Should -BeTrue
            Test-Path (Join-Path $dirtyBuild.BuildRoot 'Catzc.Base.Widget/assets/untracked.txt') | Should -BeTrue
            Test-Path (Join-Path $dirtyBuild.BuildRoot 'Catzc.Base.Widget/assets/scratch.log') | Should -BeFalse
            Test-Path (Join-Path $dirtyBuild.BuildRoot 'Catzc.Base.Widget/assets/widget.txt') | Should -BeTrue
        }

        It 'refuses to build in a pipeline' {
            Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Internal.Builder
            $destination = Join-Path $TestDrive 'dirty-pipeline'
            { Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $destination } |
                Should -Throw '*differs from its commit*'
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }
    }

    Context 'a build in the store' {
        BeforeAll {
            Mock Get-OutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Internal.Builder
            $script:store = Join-Path $TestDrive 'out/pwsh/built/widgets'
            $script:assetFile = Join-Path $fake.ModulesRoot 'Catzc.Base.Widget/assets/widget.txt'
            $script:stored = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $store
        }

        It 'records the source stamp and the file count, and a build into the store is a build' {
            $stored.Reused | Should -BeFalse
            $record = Get-Content -Raw (Join-Path $stored.BuildRoot 'build.json') | ConvertFrom-Json
            $record.sourceStamp | Should -Match '^[0-9a-f]{16,}$'
            $record.fileCount | Should -Be $stored.FileCount
        }

        It 'copies an unchanged tree''s build to another destination, reports it reused and keeps the content hash' {
            $copy = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'reused')
            $copy.Reused | Should -BeTrue
            $copy.ContentHash | Should -Be $stored.ContentHash
            $copy.TypesHash | Should -Be $stored.TypesHash
            $copy.FileCount | Should -Be $stored.FileCount
            $copy.BuildRoot | Should -Not -Be $stored.BuildRoot
            Get-ContentHash -Path $copy.BuildRoot -Exclude 'build.json' | Should -Be $stored.ContentHash
            Test-Path (Join-Path $copy.BuildRoot 'build.json') | Should -BeTrue
        }

        It 'returns a destination that already holds the stamp untouched' {
            $recordFile = Join-Path $stored.BuildRoot 'build.json'
            $before = [System.IO.File]::GetLastWriteTimeUtc($recordFile)
            $rootBefore = [System.IO.Directory]::GetCreationTimeUtc($stored.BuildRoot)
            $again = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $store
            $again.Reused | Should -BeTrue
            $again.BuildRoot | Should -Be $stored.BuildRoot
            [System.IO.File]::GetLastWriteTimeUtc($recordFile) | Should -Be $before
            [System.IO.Directory]::GetCreationTimeUtc($stored.BuildRoot) | Should -Be $rootBefore
            @([System.IO.Directory]::GetDirectories($store) | Where-Object { [System.IO.Path]::GetFileName($_) -like '.staging-*' -or [System.IO.Path]::GetFileName($_) -like '.old-*' }).Count | Should -Be 0
        }

        It 'keys the store by the first 12 hex of the stamp, one folder per bundle' {
            $record = Get-Content -Raw (Join-Path $stored.BuildRoot 'build.json') | ConvertFrom-Json
            $stampFolders = @([System.IO.Directory]::GetDirectories($store) | Where-Object { [System.IO.Path]::GetFileName($_) -match '^[0-9a-f]{12}$' })
            $stampFolders.Count | Should -Be 1
            [System.IO.Path]::GetFileName($stampFolders[0]) | Should -Be $record.sourceStamp.Substring(0, 12)
            Test-Path (Join-Path $stampFolders[0] "Catzc/$($stored.Version)/build.json") | Should -BeTrue
        }

        It 'does not reuse for a dry run' {
            (Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'reuse-dry') -DryRun).Reused | Should -BeFalse
        }

        It 'ignores a change under a tests folder, which never ships' {
            $testFile = Join-Path $fake.ModulesRoot 'Catzc.Base.Widget/tests/stamp.Tests.ps1'
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($testFile)) | Out-Null
            [System.IO.File]::WriteAllText($testFile, '# a test')
            try {
                (Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'reuse-tests')).Reused | Should -BeTrue
            }
            finally {
                [System.IO.File]::Delete($testFile)
            }
        }

        It 'builds again when one shipped file changed, and again when a bundle selection differs' {
            $original = [System.IO.File]::ReadAllBytes($assetFile)
            try {
                [System.IO.File]::WriteAllText($assetFile, 'changed after the stored build')
                $changed = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'reuse-changed')
            }
            finally {
                [System.IO.File]::WriteAllBytes($assetFile, $original)
            }
            $changed.Reused | Should -BeFalse
            $changed.ContentHash | Should -Not -Be $stored.ContentHash
            $other = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget', 'Catzc.Base.Gadget' -Destination (Join-Path $TestDrive 'reuse-other')
            $other.Reused | Should -BeFalse
        }

        It 'builds again when the store copy no longer hashes to its record' {
            # The tests above left other trees' and other selections' stamps in the store; an emptied store holds only this tree's stamp.
            [System.IO.Directory]::Delete($store, $true)
            $null = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'corrupt-seed')
            $stampFolder = @([System.IO.Directory]::GetDirectories($store) | Where-Object { [System.IO.Path]::GetFileName($_) -match '^[0-9a-f]{12}$' })
            $stampFolder.Count | Should -Be 1
            $corrupt = Join-Path $stampFolder[0] "Catzc/$($stored.Version)/Catzc.Base.Widget/assets/widget.txt"
            [System.IO.File]::AppendAllText($corrupt, 'tampered')
            $rebuilt = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'reuse-corrupt')
            $rebuilt.Reused | Should -BeFalse
            $rebuilt.ContentHash | Should -Be $stored.ContentHash
        }

        It 'fills an empty store from a profile build into another destination, so a third destination reuses it' {
            [System.IO.Directory]::Delete($store, $true)
            $first = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'fill-first')
            $first.Reused | Should -BeFalse
            $stampFolder = @([System.IO.Directory]::GetDirectories($store) | Where-Object { [System.IO.Path]::GetFileName($_) -match '^[0-9a-f]{12}$' })
            $stampFolder.Count | Should -Be 1
            $record = Get-Content -Raw (Join-Path $stampFolder[0] "Catzc/$($stored.Version)/build.json") | ConvertFrom-Json
            $record.contentHash | Should -Be $first.ContentHash
            $second = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'fill-second')
            $second.Reused | Should -BeTrue
            $second.ContentHash | Should -Be $first.ContentHash
        }

        It 'leaves the staging deleted and the store intact when the stamp folder appears during the fill' {
            $bundle = Join-Path $TestDrive 'race/widgets'
            $source = Join-Path $TestDrive 'race/source'
            [System.IO.Directory]::CreateDirectory($source) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $source 'build.json'), '{}')
            $racing = Join-Path $bundle "$('a' * 12)/Catzc/6.6.666"
            InModuleScope Catzc.Internal.Builder -Parameters @{ Source = $source; Racing = $racing } {
                # The other writer's stamp folder lands while this one is still copying.
                Mock Get-ChildPath {
                    [System.IO.Directory]::CreateDirectory($Racing) | Out-Null
                    [System.IO.File]::WriteAllText((Join-Path $Racing 'build.json'), 'other writer')
                    Join-Path $Source 'build.json'
                }
                Save-BuildToStore -BuildRoot $Source -StoreBuildRoot $Racing
            }
            [System.IO.File]::ReadAllText((Join-Path $racing 'build.json')) | Should -Be 'other writer'
            @([System.IO.Directory]::GetDirectories($bundle) | Where-Object { [System.IO.Path]::GetFileName($_) -like '.staging-*' }).Count | Should -Be 0
        }

        It 'fills the store for a build that names its modules, under its own stamp folder' {
            [System.IO.Directory]::Delete($store, $true)
            $first = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget' -Destination (Join-Path $TestDrive 'fill-named')
            $first.Reused | Should -BeFalse
            @([System.IO.Directory]::GetDirectories($store) | Where-Object { [System.IO.Path]::GetFileName($_) -match '^[0-9a-f]{12}$' }).Count | Should -Be 1
            $second = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget' -Destination (Join-Path $TestDrive 'fill-named-again')
            $second.Reused | Should -BeTrue
            $second.ContentHash | Should -Be $first.ContentHash
        }

        It 'keeps the stamp folder of another selection of the bundle and replaces only an older stamp of the same selection' {
            [System.IO.Directory]::Delete($store, $true)
            $stampFolders = { @([System.IO.Directory]::GetDirectories($store) | Where-Object { [System.IO.Path]::GetFileName($_) -match '^[0-9a-f]{12}$' } | ForEach-Object { [System.IO.Path]::GetFileName($_) }) }
            $null = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'keep-profile')
            $null = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget', 'Catzc.Base.Gadget' -Destination (Join-Path $TestDrive 'keep-named')
            $before = @(& $stampFolders)
            $before.Count | Should -Be 2
            $original = [System.IO.File]::ReadAllBytes($assetFile)
            try {
                [System.IO.File]::WriteAllText($assetFile, 'changed for the keep test')
                $null = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'keep-profile-again')
                $afterProfile = @(& $stampFolders)
                $null = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget', 'Catzc.Base.Gadget' -Destination (Join-Path $TestDrive 'keep-named-again')
                $afterNamed = @(& $stampFolders)
            }
            finally {
                [System.IO.File]::WriteAllBytes($assetFile, $original)
            }
            $afterProfile.Count | Should -Be 2
            @($afterProfile | Where-Object { $_ -in $before }).Count | Should -Be 1
            $afterNamed.Count | Should -Be 2
            @($afterNamed | Where-Object { $_ -in $before }).Count | Should -Be 0
        }
    }

    Context 'the build lock of a selection' {
        BeforeAll {
            Mock Get-OutputRoot { Join-Path $TestDrive 'lock-out' } -ModuleName Catzc.Internal.Builder
            # The lock is named by the store build root of the selection and stamp, which a first build into a seed destination fills.
            $script:lockStoreOf = {
                $stampFolders = @([System.IO.Directory]::GetDirectories((Join-Path $TestDrive 'lock-out/pwsh/built/widgets')))
                [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($stampFolders[0], 'Catzc', '1.2.3'))
            }
            $script:lockNameOf = {
                param([string] $Root)
                $hash = [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($Root.ToLowerInvariant()))
                'Local\catzc-build-' + [System.Convert]::ToHexString($hash).Substring(0, 16).ToLowerInvariant()
            }
        }

        It 'builds anyway when another runspace holds the lock past the bounded wait' {
            Mock Get-TimeoutSeconds { 2 } -ModuleName Catzc.Internal.Builder
            $destination = Join-Path $TestDrive 'locked'
            $null = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'lock-seed')
            $storeBuildRoot = & $lockStoreOf
            [System.IO.Directory]::Delete((Split-Path (Split-Path $storeBuildRoot)), $true)
            $name = & $lockNameOf $storeBuildRoot
            $sync = [hashtable]::Synchronized(@{ Held = $false; Release = $false })
            $holder = [powershell]::Create()
            [void] $holder.AddScript({
                    param($Name, $Sync)
                    $mutex = [System.Threading.Mutex]::new($false, $Name)
                    [void] $mutex.WaitOne()
                    $Sync.Held = $true
                    while (-not $Sync.Release) {
                        Start-Sleep -Milliseconds 50
                    }
                    $mutex.ReleaseMutex()
                    $mutex.Dispose()
                }).AddArgument($name).AddArgument($sync)
            $pending = $holder.BeginInvoke()
            try {
                $deadline = [datetime]::UtcNow.AddSeconds(10)
                while (-not $sync.Held -and [datetime]::UtcNow -lt $deadline) {
                    Start-Sleep -Milliseconds 50
                }
                $sync.Held | Should -BeTrue
                $built = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $destination
                $built.Reused | Should -BeFalse
                Test-Path (Join-Path $built.BuildRoot 'build.json') | Should -BeTrue
            }
            finally {
                $sync.Release = $true
                $holder.EndInvoke($pending)
                $holder.Dispose()
            }
        }

        It 'makes a build into a second destination wait for the holder of the selection''s lock, then reuse the stored build' {
            $null = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'wait-first')
            $name = & $lockNameOf (& $lockStoreOf)
            $sync = [hashtable]::Synchronized(@{ Held = $false })
            # The holder stands for a builder into another destination: it holds the lock for 1.5 s, then lets go.
            $holder = [powershell]::Create()
            [void] $holder.AddScript({
                    param($Name, $Sync)
                    $mutex = [System.Threading.Mutex]::new($false, $Name)
                    [void] $mutex.WaitOne()
                    $Sync.Held = $true
                    Start-Sleep -Milliseconds 1500
                    $mutex.ReleaseMutex()
                    $mutex.Dispose()
                }).AddArgument($name).AddArgument($sync)
            $pending = $holder.BeginInvoke()
            try {
                $deadline = [datetime]::UtcNow.AddSeconds(10)
                while (-not $sync.Held -and [datetime]::UtcNow -lt $deadline) {
                    Start-Sleep -Milliseconds 20
                }
                $sync.Held | Should -BeTrue
                $watch = [System.Diagnostics.Stopwatch]::StartNew()
                $second = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'wait-second')
                $watch.Stop()
                $second.Reused | Should -BeTrue
                $watch.Elapsed.TotalSeconds | Should -BeGreaterThan 1 -Because 'the second builder waits for the lock of the selection, not of its destination'
            }
            finally {
                $holder.EndInvoke($pending)
                $holder.Dispose()
            }
        }

        It 'leaves one build when two builds run one after the other into one destination' {
            $destination = Join-Path $TestDrive 'sequential'
            $first = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $destination
            $second = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $destination
            $second.Reused | Should -BeTrue
            $second.ContentHash | Should -Be $first.ContentHash
            @([System.IO.Directory]::GetDirectories((Join-Path $destination 'Catzc'))).Count | Should -Be 1
        }
    }

    Context 'the gates module' {
        It 'ships none of the gate tooling without it' {
            $built = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget' -Destination (Join-Path $TestDrive 'full-without-gates')
            Test-Path (Join-Path $built.BuildRoot '.vendor/Pester/5.7.1/Pester.psd1') | Should -BeFalse
            Test-Path (Join-Path $built.BuildRoot '.internal/Catzc.Internal.TestKit.psm1') | Should -BeFalse
            Test-Path (Join-Path $built.BuildRoot '.internal/assets/PSScriptAnalyzerSettings.psd1') | Should -BeFalse
            Test-Path (Join-Path $built.BuildRoot '.scriptanalyzer') | Should -BeFalse
        }

        It 'ships the test tooling, the TestKit, the analyzer settings, and the analyzer rules without their tests' {
            $built = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget', 'Catzc.Base.QualityGates' -Destination (Join-Path $TestDrive 'runtime-gates')
            Test-Path (Join-Path $built.BuildRoot '.vendor/Pester/5.7.1/Pester.psd1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.internal/Catzc.Internal.TestKit.psm1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.internal/assets/PSScriptAnalyzerSettings.psd1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.scriptanalyzer/WidgetRule.psm1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.scriptanalyzer/tests') | Should -BeFalse
        }

        It 'ships the bats runner with the gates module and none without it' {
            $withGates = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget', 'Catzc.Base.QualityGates' -Destination (Join-Path $TestDrive 'bats-gates')
            $without = Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Widget' -Destination (Join-Path $TestDrive 'bats-without')
            Test-Path (Join-Path $withGates.BuildRoot '.internal/bats-core/bin/bats') | Should -BeTrue
            Test-Path (Join-Path $without.BuildRoot '.internal/bats-core') | Should -BeFalse
        }
    }

    Context 'the modules of a language track' {
        BeforeAll {
            Mock Get-Track -ModuleName Catzc.Internal.Builder {
                [pscustomobject]@{ name = 'widgets'; type = 'modules'; languages = @('bash'); places = @('widgets') }
            }
            Mock Get-CatzcModule -ModuleName Catzc.Internal.Builder {
                [pscustomobject]@{ name = 'catzc-widget'; shape = 'folder'; root = 'widgets/Widget' }
                [pscustomobject]@{ name = 'catzc-gadget'; shape = 'folder'; root = 'widgets/Gadget' }
            }
            Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -eq 'profiles' -and -not $ListOwners } {
                @{ profiles = @{ widgets = @() } }
            }
            Mock Export-BashModule -ModuleName Catzc.Internal.Builder {
                [pscustomobject]@{ Module = $Module; Destination = $Destination; Files = 3; Executables = 1 }
            }
        }

        It 'lists a row for each language module with its handler, form and destination, and calls no handler on a dry run' {
            $plan = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'lang-dry') -DryRun
            @($plan.Languages | ForEach-Object Name) | Should -Be @('catzc-widget', 'catzc-gadget')
            $plan.Languages[0].Command | Should -Be 'Export-BashModule'
            $plan.Languages[0].Form | Should -Be 'source'
            $plan.Languages[0].Source | Should -Be 'widgets/Widget'
            $plan.Languages[0].Destination | Should -Be 'widgets/Widget'
            Should -Invoke Export-BashModule -ModuleName Catzc.Internal.Builder -Times 0 -Exactly
        }

        It 'hands each module to its handler once, quietly, and records the results in the manifest' {
            $built = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'lang-build')
            Should -Invoke Export-BashModule -ModuleName Catzc.Internal.Builder -Times 1 -Exactly -ParameterFilter {
                $Module -eq 'widgets/Widget' -and $Silent -and $Destination -eq [System.IO.Path]::Combine($built.BuildRoot, 'widgets/Widget')
            }
            Should -Invoke Export-BashModule -ModuleName Catzc.Internal.Builder -Times 2 -Exactly
            $record = Get-Content -LiteralPath (Join-Path $built.BuildRoot 'build.json') -Raw | ConvertFrom-Json
            @($record.languages).Count | Should -Be 2
            $record.languages[0].module | Should -Be 'catzc-widget'
            $record.languages[0].path | Should -Be 'widgets/Widget'
            $record.languages[0].record.Files | Should -Be 3
        }

        It 'adds no row to a profile that names modules' {
            Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -eq 'profiles' -and -not $ListOwners } {
                @{ profiles = @{ widgets = @('Catzc.Base.Widget') } }
            }
            $plan = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'lang-none') -DryRun
            @($plan.Languages).Count | Should -Be 0
        }

        It 'adds the language module a selected module declares to a profile that names modules' {
            Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -eq 'profiles' -and -not $ListOwners } {
                @{ profiles = @{ widgets = @('Catzc.Base.Widget') } }
            }
            Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -eq 'dependencies' -and -not $ListOwners } {
                @{ modules = [ordered]@{ 'Catzc.Base.Widget' = @('widgets/Gadget') } }
            }
            $plan = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'lang-declared') -DryRun
            @($plan.Languages | ForEach-Object Name) | Should -Be @('catzc-gadget')
        }

        It 'refuses a declared language module no track holds' {
            Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -eq 'profiles' -and -not $ListOwners } {
                @{ profiles = @{ widgets = @('Catzc.Base.Widget') } }
            }
            Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -eq 'dependencies' -and -not $ListOwners } {
                @{ modules = [ordered]@{ 'Catzc.Base.Widget' = @('widgets/Sprocket') } }
            }
            { Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination (Join-Path $TestDrive 'lang-unknown') -DryRun } |
                Should -Throw "*declares the language module 'widgets/Sprocket'*"
        }
    }

    Context 'a build that cannot be made' {
        It 'collects every merge-precondition violation before writing anything' {
            $destination = Join-Path $TestDrive 'gizmo'
            $failure = { Invoke-ModuleBuild @buildArguments -ModuleProfile gizmos -Destination $destination } |
                Should -Throw -PassThru
            $message = $failure.Exception.Message
            $message |
                Should -BeLike '*pwsh/Catzc.Base.Gizmo/Get-GizmoPair.ps1: must hold exactly one top-level statement*'
            $message | Should -BeLike "*pwsh/Catzc.Base.Gizmo/Get-GizmoName.ps1: defines function 'Get-SomethingElse'*"
            $message | Should -BeLike '*pwsh/Catzc.Base.Gizmo/Get-GizmoAnchor.ps1:2: reads $PSScriptRoot*'
            $message | Should -BeLike '*pwsh/Catzc.Base.Gizmo/private/Get-GizmoReq.ps1: carries a #requires statement*'
            $message |
                Should -BeLike '*pwsh/Catzc.Base.Gizmo/private/Get-GizmoTop.ps1: must hold exactly one top-level statement*'
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }

        It 'fails the presence check listing every internal asset dependency the output would miss' {
            Mock Get-InternalAssetDependency -ModuleName Catzc.Internal.Builder {
                [pscustomobject]@{ Module = 'Catzc.Base.Widget'; Function = 'Get-Widget'; ChildPath = 'assets/missing.txt'; File = (Get-CatzcModulesFolder) + '/Catzc.Base.Widget/Get-Widget.ps1'; Line = 5 }
                [pscustomobject]@{ Module = 'Catzc.Base.Gizmo'; Function = 'Get-Widget'; ChildPath = 'configs/gizmo.yml'; File = (Get-CatzcModulesFolder) + '/Catzc.Base.Widget/Get-Widget.ps1'; Line = 6 }
                [pscustomobject]@{ Module = 'Catzc.Base.Widget'; Function = 'Set-Widget'; ChildPath = 'configs'; File = (Get-CatzcModulesFolder) + '/Catzc.Base.Widget/Set-Widget.ps1'; Line = 2 }
            }
            $destination = Join-Path $TestDrive 'gate'
            $failure = { Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $destination } |
                Should -Throw -PassThru
            $message = $failure.Exception.Message
            $message | Should -BeLike '*2 internal asset dependenc*'
            $message |
                Should -BeLike '*Catzc.Base.Widget/assets/missing.txt (read by Get-Widget, pwsh/Catzc.Base.Widget/Get-Widget.ps1:5)*'
            $message | Should -BeLike '*Catzc.Base.Gizmo/configs/gizmo.yml*'
            $message | Should -Not -BeLike '*Set-Widget*'
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }

        It 'fails the closure check listing every call and config read that lands outside the selection' {
            # A closure that forgets gadget's dependency on widget, the way an unlisted module in dependencies.yml does.
            Mock Get-ModuleProfile -ModuleName Catzc.Internal.Builder -RemoveParameterValidation Name { [string[]] @($Modules) }
            $destination = Join-Path $TestDrive 'closure'
            $failure = { Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Gadget' -Destination $destination } |
                Should -Throw -PassThru
            $message = $failure.Exception.Message
            $message | Should -BeLike '*2 call(s) or config read(s)*'
            $message |
                Should -BeLike '*pwsh/Catzc.Base.Gadget/Get-GadgetWidget.ps1:2: Get-GadgetWidget calls Get-Widget, which Catzc.Base.Widget owns*'
            $message |
                Should -BeLike "*pwsh/Catzc.Base.Gadget/Get-GadgetWidget.ps1:3: reads config 'widget', which Catzc.Base.Widget owns*"
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }

        It 'refuses to finish a build whose types surface is not the committed contract' {
            Mock Get-TypesContractDrift { 'types.sample.json differs from the build''s surface: added [Catzc.Widgets.Widget]' } -ModuleName Catzc.Internal.Builder
            { Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Module 'Catzc.Base.Gadget' -Destination (Join-Path $TestDrive 'drifted') } |
                Should -Throw '*types surface is not the committed contract*added `[Catzc.Widgets.Widget`]*'
        }

        It 'rejects a version that is not MAJOR.MINOR.PATCH' {
            { Invoke-ModuleBuild -ModuleProfile widgets -Version auto -Bundle widgets -PackageMetadata $metadata -Destination $TestDrive -DryRun } |
                Should -Throw '*not MAJOR.MINOR.PATCH*'
        }

        It 'requires -Module or -ModuleProfile' {
            { Invoke-ModuleBuild @buildArguments -Destination $TestDrive -DryRun } |
                Should -Throw '*-Module, -ModuleProfile, or both*'
        }

        It 'rejects package metadata without a GUID' {
            $noGuid = $metadata.Clone()
            $noGuid.Guid = 'widget'
            { Invoke-ModuleBuild -ModuleProfile widgets -Version 1.2.3 -Bundle widgets -PackageMetadata $noGuid -Destination $TestDrive -DryRun } |
                Should -Throw '*is not a GUID*'
        }
    }
}
