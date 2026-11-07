# cspell:ignore inittypes enabletypes FIXTUREWIDGET  -- fixture folder prefixes and an upper-cased fixture command name,
# data
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
    Justification = 'Tests set and read $global:__CatzcDeferredTypes, the session-global pending record the deferred load reads')]
param()

Describe 'Initialize-Types'-Tag 'L1', 'logic' {
    BeforeAll {
        $script:fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) "inittypes-$([guid]::NewGuid().ToString('N'))"
        [System.IO.Directory]::CreateDirectory($script:fixtureRoot) | Out-Null
        $script:savedRecord = Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore
        $script:savedHook = $ExecutionContext.InvokeCommand.PreCommandLookupAction

        function script:New-FixtureAssembly {
            param([bool] $WithManifest = $true)
            $run = 'r' + [guid]::NewGuid().ToString('N').Substring(0, 8)
            $space = "CatzcInitWidget$run"
            $dll = Join-Path $script:fixtureRoot "Catzc.Types.$run.dll"
            Add-Type -TypeDefinition "namespace $space { public class Widget { public int Size = 1; } public class Gadget { } }" -OutputAssembly $dll -OutputType Library
            if ($WithManifest) {
                $manifest = [ordered]@{
                    hash  = $run
                    types = @(
                        [ordered]@{ name = "$space.Gadget"; aliases = @(); display = @() }
                        [ordered]@{ name = "$space.Widget"; aliases = @("Fx.Widget$run"); display = @('Size') }
                    )
                }
                [System.IO.File]::WriteAllText([System.IO.Path]::ChangeExtension($dll, 'json'),
                    ($manifest | ConvertTo-Json -Depth 5))
            }
            [pscustomobject]@{ Dll = $dll; Space = $space; Run = $run }
        }
        function script:Test-TypeLoaded {
            param([string] $Name)
            [bool] ([System.Management.Automation.PSTypeName]$Name).Type
        }
    }
    AfterAll {
        $global:__CatzcDeferredTypes = $script:savedRecord
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = $script:savedHook
        Remove-Item -Path $script:fixtureRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    BeforeEach {
        $global:__CatzcDeferredTypes = @{}
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = $null
    }

    It 'records an assembly as pending without loading it' {
        $fx = New-FixtureAssembly
        Register-DeferredTypes -RootKey 'root-a' -Path $fx.Dll -ShadowCopy $false
        $global:__CatzcDeferredTypes['root-a'].Loaded | Should -BeFalse
        Test-TypeLoaded "$($fx.Space).Widget" | Should -BeFalse
    }

    It 'loads a pending assembly once and registers its alias and default display from the manifest' {
        $fx = New-FixtureAssembly
        Register-DeferredTypes -RootKey 'root-a' -Path $fx.Dll -ShadowCopy $false
        $result = @(Initialize-Types)

        $result.Count | Should -Be 1
        $result[0].Aliases | Should -Be 1
        $result[0].Displayed | Should -Be 1
        Test-TypeLoaded "$($fx.Space).Widget" | Should -BeTrue
        $global:__CatzcDeferredTypes['root-a'].Loaded | Should -BeTrue
        $accelerators = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
        $accelerators::Get["Fx.Widget$($fx.Run)"].FullName | Should -Be "$($fx.Space).Widget"
        (Get-TypeData -TypeName "$($fx.Space).Widget").DefaultDisplayPropertySet.ReferencedProperties |
            Should -Be @('Size')
        Get-TypeData -TypeName "$($fx.Space).Gadget" | Should -BeNullOrEmpty
    }

    It 'is idempotent: a second call loads nothing' {
        $fx = New-FixtureAssembly
        Register-DeferredTypes -RootKey 'root-a' -Path $fx.Dll -ShadowCopy $false
        Initialize-Types | Out-Null
        $before = [System.AppDomain]::CurrentDomain.GetAssemblies().Count
        @(Initialize-Types).Count | Should -Be 0
        [System.AppDomain]::CurrentDomain.GetAssemblies().Count | Should -Be $before
    }

    It 'does nothing when nothing was registered' {
        Remove-Variable -Name '__CatzcDeferredTypes' -Scope Global
        @(Initialize-Types).Count | Should -Be 0
    }

    It 'loads through the shadow copy when asked to' {
        $fx = New-FixtureAssembly
        $shadowRoot = Join-Path $script:fixtureRoot 'shadow'
        Mock Get-TypesShadowRoot { $shadowRoot }.GetNewClosure() -ModuleName Catzc.Internal.Types
        Register-DeferredTypes -RootKey 'root-a' -Path $fx.Dll -ShadowCopy $true
        $result = Initialize-Types
        $result.Loaded | Should -Be (Join-Path $shadowRoot ([System.IO.Path]::GetFileName($fx.Dll)))
        ([System.Management.Automation.PSTypeName]"$($fx.Space).Widget").Type.Assembly.Location |
            Should -Be $result.Loaded
    }

    It 'loads in place when the shadow copy is off' {
        $fx = New-FixtureAssembly
        Register-DeferredTypes -RootKey 'root-a' -Path $fx.Dll -ShadowCopy $false
        $result = Initialize-Types
        $result.Loaded | Should -Be $fx.Dll
        ([System.Management.Automation.PSTypeName]"$($fx.Space).Widget").Type.Assembly.Location | Should -Be $fx.Dll
    }

    It 'throws, naming the manifest, when the manifest is missing, and loads nothing' {
        $fx = New-FixtureAssembly -WithManifest $false
        Register-DeferredTypes -RootKey 'root-a' -Path $fx.Dll -ShadowCopy $false
        { Initialize-Types } | Should -Throw '*manifest*does not exist*'
        Test-TypeLoaded "$($fx.Space).Widget" | Should -BeFalse
        $global:__CatzcDeferredTypes['root-a'].Loaded | Should -BeFalse
    }

    It 'leaves the lookup hook installed' {
        $fx = New-FixtureAssembly
        Register-DeferredTypes -RootKey 'root-a' -Path $fx.Dll -ShadowCopy $false
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = { $null = $args }
        Initialize-Types | Out-Null
        $ExecutionContext.InvokeCommand.PreCommandLookupAction | Should -Not -BeNullOrEmpty
    }
}
