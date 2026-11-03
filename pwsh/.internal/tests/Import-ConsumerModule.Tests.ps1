BeforeAll {
    # The transient importer modules are removed after every import, so this test file loads its own copies.
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Importer.psm1') -Force

    # A one-function module folder under the consumer root's widget track.
    function Add-WidgetModule {
        param([string] $Root, [string] $Folder, [string] $Function, [string] $Marker)
        $directory = Join-Path $Root "widget/$Folder"
        [System.IO.Directory]::CreateDirectory($directory) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $directory "$Function.ps1"), "function $Function { '$Marker' }")
    }

    function New-WidgetRoot {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N').Substring(0, 8))
        [System.IO.Directory]::CreateDirectory((Join-Path $root '.catzc/configs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $root '.catzc/configs/variants.yml'), 'tracks: {}')
        $root
    }

    $script:modulesRoot = Get-CatzcModulesRoot
}

AfterAll {
    foreach ($module in @(Get-Module -Name 'Widget.*')) {
        Remove-Module -ModuleInfo $module -Force -ErrorAction SilentlyContinue
    }
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
}

Describe 'Import-ConsumerModule' -Tag 'L0', 'logic' {
    BeforeEach {
        foreach ($module in @(Get-Module -Name 'Widget.*')) {
            Remove-Module -ModuleInfo $module -Force
        }
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer
        # The one declared track of the consumer, as its variants config would give it.
        Mock Get-Track {
            [Catzc.Base.Variants.VariantTrack]::new('widget', [Catzc.Base.Variants.VariantMember[]] @([Catzc.Base.Variants.VariantMember]::new('widget')),
                'modules', $null, [string[]] @(), $null, $null, $null, 'Widget')
        } -ModuleName Catzc.Internal.Importer
        Mock Get-Config { @() } -ModuleName Catzc.Internal.Importer -ParameterFilter { $ListOwners }
    }

    It 'loads nothing when the working root declares no tracks of its own' {
        $root = Join-Path $TestDrive 'bare'
        [System.IO.Directory]::CreateDirectory($root) | Out-Null
        $loaded = InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules }
        @($loaded).Count | Should -Be 0
        Should -Invoke Get-Track -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }

    It 'loads each module of a consumer track named by its namespace and folder, with its public function exported' -Tag 'ADR-AUTO-CONSUMER-SOURCEMODULES' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        Add-WidgetModule -Root $root -Folder 'Beta' -Function 'Get-WidgetBeta' -Marker 'beta'
        $loaded = InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules }
        $loaded | Should -Be @('Widget.Alpha', 'Widget.Beta')
        (Get-Module Widget.Alpha).ExportedFunctions.Keys | Should -Contain 'Get-WidgetAlpha'
        Get-WidgetAlpha | Should -Be 'alpha'
        Get-WidgetBeta | Should -Be 'beta'
    }

    It 'writes the manifests under the working root''s out/ and nothing into the consumer''s track' -Tag 'ADR-AUTO-CONSUMER-SOURCEMODULES' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) [void] (Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules) }
        Join-Path $root 'out/modules/Widget.Alpha/Widget.Alpha.psd1' | Should -Exist
        @([System.IO.Directory]::GetFiles((Join-Path $root 'widget/Alpha'))).Count | Should -Be 1
    }

    It 'keeps the function file''s own path, so an error names the consumer''s source' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) [void] (Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules) }
        (Get-Command Get-WidgetAlpha).ScriptBlock.File.Replace('\', '/') | Should -BeLike '*/widget/Alpha/Get-WidgetAlpha.ps1'
    }

    It 'runs a module''s functions strict, and keeps a private function out of the exports' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        Add-WidgetModule -Root $root -Folder 'Alpha/private' -Function 'Get-WidgetHidden' -Marker 'hidden'
        [System.IO.File]::WriteAllText((Join-Path $root 'widget/Alpha/Test-WidgetStrict.ps1'), 'function Test-WidgetStrict { try { $null = $widgetNeverSet; "not strict" } catch { "strict" } }')
        InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) [void] (Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules) }
        Test-WidgetStrict | Should -Be 'strict'
        (Get-Module Widget.Alpha).ExportedFunctions.Keys | Should -Not -Contain 'Get-WidgetHidden'
    }

    It 'orders the modules by the consumer''s own dependencies config' -Tag 'ADR-AUTO-CONSUMER-SOURCEMODULES', 'ADR-AUTO-MODULE-TOPOLOGICALORDER' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        Add-WidgetModule -Root $root -Folder 'Beta' -Function 'Get-WidgetBeta' -Marker 'beta'
        Mock Get-Config { @([pscustomobject]@{ Module = 'Widget.Alpha' }) } -ModuleName Catzc.Internal.Importer -ParameterFilter { $ListOwners }
        Mock Get-Config { [ordered]@{ modules = [ordered]@{ 'Widget.Alpha' = @('Widget.Beta', 'Catzc.Base.Asserts') } } } -ModuleName Catzc.Internal.Importer -ParameterFilter { -not $ListOwners }
        $loaded = InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules }
        $loaded | Should -Be @('Widget.Beta', 'Widget.Alpha')
        Should -Invoke Get-Config -ModuleName Catzc.Internal.Importer -ParameterFilter { $Namespace -ceq 'Widget' -and $Config -ceq 'dependencies' }
    }

    It 'stops on a dependency cycle, naming the modules' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        Add-WidgetModule -Root $root -Folder 'Beta' -Function 'Get-WidgetBeta' -Marker 'beta'
        Mock Get-Config { @([pscustomobject]@{ Module = 'Widget.Alpha' }) } -ModuleName Catzc.Internal.Importer -ParameterFilter { $ListOwners }
        Mock Get-Config { [ordered]@{ modules = [ordered]@{ 'Widget.Alpha' = @('Widget.Beta'); 'Widget.Beta' = @('Widget.Alpha') } } } -ModuleName Catzc.Internal.Importer -ParameterFilter { -not $ListOwners }
        { InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules } } |
            Should -Throw '*Cycle*Widget.Alpha, Widget.Beta*'
    }

    It 'skips a folder with no function file, as a config-only module is no PowerShell module' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'widget/Gadget/configs')) | Out-Null
        $loaded = InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules }
        $loaded | Should -Be @('Widget.Alpha')
    }

    It 'announces each module it loads, and each it removes, as a state change' -Tag 'ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'alpha'
        InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) [void] (Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules) }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $StateChange -and $Message -like 'Consumer: loaded Widget.Alpha*' }
    }

    It 'shows an edited file on the next load and removes a module whose folder left the tracks' {
        $root = New-WidgetRoot
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'first'
        Add-WidgetModule -Root $root -Folder 'Beta' -Function 'Get-WidgetBeta' -Marker 'beta'
        InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) [void] (Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules) }
        Get-WidgetAlpha | Should -Be 'first'
        Add-WidgetModule -Root $root -Folder 'Alpha' -Function 'Get-WidgetAlpha' -Marker 'second'
        Remove-Item (Join-Path $root 'widget/Beta') -Recurse -Force
        InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) [void] (Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules) }
        Get-WidgetAlpha | Should -Be 'second'
        Get-Module Widget.Beta | Should -BeNullOrEmpty
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $StateChange -and $Message -like 'Consumer: removed Widget.Beta*' }
    }

    It 'leaves a track in the system''s namespace to the track reader, whose refusal reaches the caller' -Tag 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        $root = New-WidgetRoot
        Mock Get-Track { throw "The variants config of a consumer repository gives the track 'widget' the namespace 'Catzc', which is the system's (ADR-WIDGET-GADGET)" } -ModuleName Catzc.Internal.Importer
        { InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules } } |
            Should -Throw '*ADR-WIDGET-GADGET*'
    }
}

Describe 'Import-ConsumerModule with the real track reader' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Variants
    }

    It 'refuses a track named for the engine''s own, with the track reader''s message' -Tag 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        $root = New-WidgetRoot
        Mock Get-Variant {
            [Catzc.Base.Variants.VariantTrack]::new('pwsh', [Catzc.Base.Variants.VariantMember[]] @([Catzc.Base.Variants.VariantMember]::new('widget')),
                'modules', $null, [string[]] @(), $null, $null, $null, 'Widget')
        } -ModuleName Catzc.Base.Variants
        { InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules } } |
            Should -Throw "*track 'pwsh', which is the engine's own*"
    }

    It 'refuses a track whose namespace is the system''s, with the track reader''s message' -Tag 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        $root = New-WidgetRoot
        Mock Get-Variant {
            [Catzc.Base.Variants.VariantTrack]::new('widget', [Catzc.Base.Variants.VariantMember[]] @([Catzc.Base.Variants.VariantMember]::new('widget')),
                'modules', $null, [string[]] @(), $null, $null, $null, 'Catzc')
        } -ModuleName Catzc.Base.Variants
        { InModuleScope Catzc.Internal.Importer -Parameters @{ Root = $root; Modules = $modulesRoot } { param($Root, $Modules) Import-ConsumerModule -RepositoryRoot $Root -ModulesRoot $Modules } } |
            Should -Throw "*namespace 'Catzc', which is the system's*"
    }
}
