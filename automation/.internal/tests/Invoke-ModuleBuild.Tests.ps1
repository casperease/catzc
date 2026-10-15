<#
---
catzc:
  derived:
    path: automation/.internal/tests/Invoke-ModuleBuild.Tests.ps1
    kind: pester-test
---
#>

# cspell:ignore nfunction  -- the escape-sequence artifact in the "`nfunction" fixture strings
BeforeAll {
    Import-InternalModule TestKit
    Import-InternalModule Builder

    # A neutral fixture source tree: two selectable modules (widget, gadget), one that is never selected (gizmo,
    # which also carries every merge-precondition violation), and stand-ins for the infrastructure the build ships.
    $script:helpText = "<#`r`n.SYNOPSIS`r`n    Returns the widget.`r`n#>`r`nfunction Get-Widget {`r`n    Get-WidgetCore`r`n}`r`n`r`n"
    $script:fake = New-FakeRepositoryRoot -Modules @{
        'Catzc.Base.Widget' = @{
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
        'Catzc.Base.Gadget' = @{
            Public = 'Get-Gadget'
            Files  = @{
                'types/Lever.cs'       = "namespace Catzc.Base.Gadget;`npublic class Lever { }`n"
                # Reaches into widget twice: a call and a config read — what the closure check follows. The
                # owner-scoped read (-ListOwners) reads only the owners present, so it is not a third gap.
                'Get-GadgetWidget.ps1' = "function Get-GadgetWidget {`n    Get-Widget`n    Get-Config -Config widget`n    Get-Config -Config widget -ListOwners`n}`n"
            }
        }
        'Catzc.Base.Gizmo'  = @{
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
    } -Files @{
        'automation/.internal/Catzc.Internal.Bootstrap.psm1'             = '# bootstrap'
        'automation/.internal/Catzc.Internal.Importer.psm1'              = '# importer'
        'automation/.internal/Catzc.Internal.Loader.psm1'                = '# loader'
        'automation/.internal/Catzc.Internal.Types.psm1'                 = '# types'
        'automation/.internal/Catzc.Internal.Vendor.psm1'                = '# vendor'
        'automation/.internal/Catzc.Internal.Builder.psm1'               = '# builder (never ships)'
        'automation/.internal/Catzc.Internal.TestKit.psm1'               = '# testkit (ships under full only)'
        'automation/.internal/tests/Get-Loader.Tests.ps1'                = '# test (never ships)'
        'automation/.internal/assets/ErrorView.format.ps1xml'            = '<Configuration />'
        'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'      = '@{ }'
        'automation/.internal/assets/Import-Catzc.ps1'                   = "# initializer`r`n"
        'automation/.vendor/powershell-yaml/0.4.12/powershell-yaml.psd1' = '@{ }'
        # A file git stores with CRLF (kept as-is by -text, the way a signed vendored script must be).
        'automation/.vendor/powershell-yaml/0.4.12/Signed.ps1'           = "# signed`r`n"
        '.gitattributes'                                                 = "automation/.vendor/powershell-yaml/0.4.12/Signed.ps1 -text`n"
        '.gitignore'                                                     = "*.log`n"
        'automation/.vendor/Pester/5.7.1/Pester.psd1'                    = '@{ }'
        'automation/.scriptanalyzer/WidgetRule.psm1'                     = '# rule'
        'automation/.scriptanalyzer/tests/WidgetRule.Tests.ps1'          = '# rule test (never ships)'
    }
    $script:source = $fake.Automation

    # The committed full-set DLL stand-in: the build reuses it by copy, named by the hash of EVERY module's types.
    $script:fullHash = (Get-CombinedTypeHash -AutomationRoot $source).CombinedHash
    $compiled = Join-Path $source '.compiled'
    [System.IO.Directory]::CreateDirectory($compiled) | Out-Null
    [System.IO.File]::WriteAllBytes((Join-Path $compiled "Catzc.Types.$fullHash.dll"), [byte[]] @(77, 90, 1, 2, 3))
    [System.IO.File]::WriteAllText((Join-Path $compiled "Catzc.Types.$fullHash.json"), "{`"hash`":`"$fullHash`"}`n")

    # The build ships what git tracks, so the fixture is a committed repository. core.autocrlf=true is a Windows
    # checkout: the CRLF fixture files (the help text, the initializer) are stored LF, as git stores them in the
    # real repository, and the checkout keeps them CRLF on disk.
    foreach ($gitCommand in @(
            'git init -q'
            'git config core.autocrlf true'
            'git add -A'
            'git -c user.name=widget -c user.email=widget@example.invalid commit -q -m fixture'
        )) {
        Invoke-Executable $gitCommand -WorkingDirectory $fake.Root -Silent
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
        VendorPolicy    = 'runtime'
        Bundle          = 'widgets'
        PackageMetadata = $metadata
    }

    # Boundaries: the source-tree guard (the fixture root is not the session's code root), the profile/closure
    # resolver and the asset inventory (both read the real configs/tree), and git.
    Mock Assert-SourceTree { } -ModuleName Catzc.Internal.Builder
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
    Mock Get-InternalAssetDependency -ModuleName Catzc.Internal.Builder {
        [pscustomobject]@{ Module = 'Catzc.Base.Widget'; Function = 'Get-Widget'; ChildPath = 'assets/widget.txt'; File = 'automation/Catzc.Base.Widget/Get-Widget.ps1'; Line = 5 }
    }

    function script:Get-FileSnapshot {
        param([string] $Root)
        $snapshot = @{}
        foreach ($file in [System.IO.Directory]::EnumerateFiles($Root, '*', [System.IO.SearchOption]::AllDirectories)) {
            $snapshot[[System.IO.Path]::GetRelativePath($Root, $file).Replace('\', '/')] = [System.IO.File]::GetLastWriteTimeUtc($file).Ticks
        }
        $snapshot
    }
}

AfterAll {
    Remove-FakeRepositoryRoot $fake
}

Describe 'Invoke-ModuleBuild' -Tag 'L1', 'logic', 'source-only' {
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
    }

    Context 'a build of a profile plus an explicit module' {
        BeforeAll {
            $script:destination = Join-Path $TestDrive 'build'
            $script:result = Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Module 'Catzc.Base.Gadget' -Destination $destination
            $script:root = $result.BuildRoot
            $script:files = @(foreach ($file in [System.IO.Directory]::EnumerateFiles($root, '*', [System.IO.SearchOption]::AllDirectories)) {
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
                'automation/Catzc.Base.Widget/private/Get-WidgetCore.ps1'
                'automation/Catzc.Base.Widget/Get-Widget.ps1'
                'automation/Catzc.Base.Widget/Set-Widget.ps1'
            )
        }

        It 'takes each file verbatim — its comment-based help stays right before its function' {
            $text = [System.IO.File]::ReadAllText((Join-Path $root 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'))
            $verbatim = $helpText.Replace("`r", '').TrimEnd("`n")
            $text | Should -BeLike "*# source: automation/Catzc.Base.Widget/Get-Widget.ps1`n$verbatim`n`n*"
        }

        It 'writes canonical bytes: UTF-8 without BOM, LF only, one trailing newline' {
            foreach ($relativePath in 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1', 'Catzc.psd1', 'Catzc.psm1', 'build.json', 'Catzc.Base.Widget/Catzc.Base.Widget.psd1') {
                $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root $relativePath))
                $bytes[0] | Should -Not -Be 0xEF -Because "$relativePath carries no BOM"
                $bytes | Should -Not -Contain 13 -Because "$relativePath has LF endings only"
                $bytes[-1] | Should -Be 10 -Because "$relativePath ends with a newline"
                $bytes[-2] | Should -Not -Be 10 -Because "$relativePath ends with exactly one newline"
            }
        }

        It 'copies side folders and the initializer as git stores them: LF-stored text LF, the rest byte for byte' {
            [System.IO.File]::ReadAllText((Join-Path $root 'Catzc.Base.Widget/assets/widget.txt')) | Should -BeExactly 'widget asset'
            # CRLF on disk, LF in git: the bundle carries git's LF, whatever the checkout wrote.
            [System.IO.File]::ReadAllText((Join-Path $fake.Automation '.internal/assets/Import-Catzc.ps1')) | Should -BeExactly "# initializer`r`n"
            [System.IO.File]::ReadAllText((Join-Path $root 'Import-Catzc.ps1')) | Should -BeExactly "# initializer`n"
            # CRLF in git (-text): kept byte for byte.
            [System.IO.File]::ReadAllText((Join-Path $root '.vendor/powershell-yaml/0.4.12/Signed.ps1')) | Should -BeExactly "# signed`r`n"
        }

        It 'records a clean source tree as not dirty' {
            $result.Dirty | Should -BeFalse
            (Get-Content -Raw (Join-Path $root 'build.json') | ConvertFrom-Json).dirty | Should -BeFalse
        }

        It 'yields the same content hash whatever line endings the checkout wrote' {
            $initializer = Join-Path $fake.Automation '.internal/assets/Import-Catzc.ps1'
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
            [System.IO.File]::ReadAllText((Join-Path $root 'Catzc.psm1')) | Should -BeLike "*. (Join-Path `$PSScriptRoot 'Import-Catzc.ps1')*"
        }

        It 'ships the full type set: the committed DLL by copy, unselected sources under .compiled/types' {
            $result.TypesHash | Should -Be $fullHash
            [System.IO.File]::ReadAllBytes((Join-Path $root ".compiled/Catzc.Types.$fullHash.dll")) | Should -Be @(77, 90, 1, 2, 3)
            [System.IO.File]::ReadAllText((Join-Path $root ".compiled/Catzc.Types.$fullHash.json")) | Should -BeExactly "{`"hash`":`"$fullHash`"}`n"
            [System.IO.File]::ReadAllText((Join-Path $root '.compiled/types/Catzc.Base.Gizmo/Sprocket.cs')) |
                Should -BeExactly "namespace Catzc.Base.Gizmo;`npublic class Sprocket { }`n"
        }

        It 'records provenance in build.json, with a content hash over everything but build.json' {
            $record = Get-Content -Raw (Join-Path $root 'build.json') | ConvertFrom-Json
            $record.bundle | Should -Be 'widgets'
            $record.version | Should -Be '1.2.3'
            $record.typesHash | Should -Be $fullHash
            @($record.typeSources) | Should -Be @('Catzc.Base.Gadget/types/Lever.cs', '.compiled/types/Catzc.Base.Gizmo/Sprocket.cs')
            $record.sourceCommit | Should -Be 'f00df00df00df00df00df00df00df00df00df00d'
            $record.vendorPolicy | Should -Be 'runtime'
            @($record.modules) | Should -Be @('Catzc.Base.Gadget', 'Catzc.Base.Widget')
            $record.contentHash | Should -Be $result.ContentHash
            $result.ContentHash | Should -Be (Get-CatzcContentHash -Path $root -Exclude 'build.json')
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
            $script:untracked = Join-Path $fake.Automation 'Catzc.Base.Widget/assets/untracked.txt'
            $script:ignored = Join-Path $fake.Automation 'Catzc.Base.Widget/assets/scratch.log'
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
            { Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $destination } | Should -Throw '*differs from its commit*'
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }
    }

    Context 'the full vendor policy' {
        It 'also ships the test tooling, the TestKit, the analyzer settings, and the analyzer rules without their tests' {
            $built = Invoke-ModuleBuild @buildArguments -VendorPolicy full -Module 'Catzc.Base.Widget' -Destination (Join-Path $TestDrive 'full')
            Test-Path (Join-Path $built.BuildRoot '.vendor/Pester/5.7.1/Pester.psd1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.internal/Catzc.Internal.TestKit.psm1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.internal/assets/PSScriptAnalyzerSettings.psd1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.scriptanalyzer/WidgetRule.psm1') | Should -BeTrue
            Test-Path (Join-Path $built.BuildRoot '.scriptanalyzer/tests') | Should -BeFalse
        }
    }

    Context 'a build that cannot be made' {
        It 'collects every merge-precondition violation before writing anything' {
            $destination = Join-Path $TestDrive 'gizmo'
            $failure = { Invoke-ModuleBuild @buildArguments -ModuleProfile gizmos -Destination $destination } | Should -Throw -PassThru
            $message = $failure.Exception.Message
            $message | Should -BeLike '*automation/Catzc.Base.Gizmo/Get-GizmoPair.ps1: must hold exactly one top-level statement*'
            $message | Should -BeLike "*automation/Catzc.Base.Gizmo/Get-GizmoName.ps1: defines function 'Get-SomethingElse'*"
            $message | Should -BeLike '*automation/Catzc.Base.Gizmo/Get-GizmoAnchor.ps1:2: reads $PSScriptRoot*'
            $message | Should -BeLike '*automation/Catzc.Base.Gizmo/private/Get-GizmoReq.ps1: carries a #requires statement*'
            $message | Should -BeLike '*automation/Catzc.Base.Gizmo/private/Get-GizmoTop.ps1: must hold exactly one top-level statement*'
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }

        It 'fails the presence check listing every internal asset dependency the output would miss' {
            Mock Get-InternalAssetDependency -ModuleName Catzc.Internal.Builder {
                [pscustomobject]@{ Module = 'Catzc.Base.Widget'; Function = 'Get-Widget'; ChildPath = 'assets/missing.txt'; File = 'automation/Catzc.Base.Widget/Get-Widget.ps1'; Line = 5 }
                [pscustomobject]@{ Module = 'Catzc.Base.Gizmo'; Function = 'Get-Widget'; ChildPath = 'configs/gizmo.yml'; File = 'automation/Catzc.Base.Widget/Get-Widget.ps1'; Line = 6 }
                [pscustomobject]@{ Module = 'Catzc.Base.Widget'; Function = 'Set-Widget'; ChildPath = 'configs'; File = 'automation/Catzc.Base.Widget/Set-Widget.ps1'; Line = 2 }
            }
            $destination = Join-Path $TestDrive 'gate'
            $failure = { Invoke-ModuleBuild @buildArguments -ModuleProfile widgets -Destination $destination } | Should -Throw -PassThru
            $message = $failure.Exception.Message
            $message | Should -BeLike '*2 internal asset dependenc*'
            $message | Should -BeLike '*Catzc.Base.Widget/assets/missing.txt (read by Get-Widget, automation/Catzc.Base.Widget/Get-Widget.ps1:5)*'
            $message | Should -BeLike '*Catzc.Base.Gizmo/configs/gizmo.yml*'
            $message | Should -Not -BeLike '*Set-Widget*'
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }

        It 'fails the closure check listing every call and config read that lands outside the selection' {
            # A closure that forgets gadget's dependency on widget, the way an unlisted module in dependencies.yml does.
            Mock Get-ModuleProfile -ModuleName Catzc.Internal.Builder -RemoveParameterValidation Name { [string[]] @($Modules) }
            $destination = Join-Path $TestDrive 'closure'
            $failure = { Invoke-ModuleBuild @buildArguments -Module 'Catzc.Base.Gadget' -Destination $destination } | Should -Throw -PassThru
            $message = $failure.Exception.Message
            $message | Should -BeLike '*2 call(s) or config read(s)*'
            $message | Should -BeLike '*automation/Catzc.Base.Gadget/Get-GadgetWidget.ps1:2: Get-GadgetWidget calls Get-Widget, which Catzc.Base.Widget owns*'
            $message | Should -BeLike "*automation/Catzc.Base.Gadget/Get-GadgetWidget.ps1:3: reads config 'widget', which Catzc.Base.Widget owns*"
            [System.IO.Directory]::Exists($destination) | Should -BeFalse
        }

        It 'rejects a version that is not MAJOR.MINOR.PATCH' {
            { Invoke-ModuleBuild -ModuleProfile widgets -Version auto -VendorPolicy runtime -Bundle widgets -PackageMetadata $metadata -Destination $TestDrive -DryRun } |
                Should -Throw '*not MAJOR.MINOR.PATCH*'
        }

        It 'requires -Module or -ModuleProfile' {
            { Invoke-ModuleBuild @buildArguments -Destination $TestDrive -DryRun } | Should -Throw '*-Module, -ModuleProfile, or both*'
        }

        It 'rejects package metadata without a GUID' {
            $noGuid = $metadata.Clone()
            $noGuid.Guid = 'widget'
            { Invoke-ModuleBuild -ModuleProfile widgets -Version 1.2.3 -VendorPolicy runtime -Bundle widgets -PackageMetadata $noGuid -Destination $TestDrive -DryRun } |
                Should -Throw '*is not a GUID*'
        }
    }
}
