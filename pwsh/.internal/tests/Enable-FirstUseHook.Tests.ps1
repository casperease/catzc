Describe 'Enable-FirstUseHook' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:loaderModule = Get-Module Catzc.Internal.Loader
        $script:savedHook = $ExecutionContext.InvokeCommand.PreCommandLookupAction
        $script:savedCompletion = (Get-Command TabExpansion2 -CommandType Function).ScriptBlock
        $script:savedRecord = Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore
        # The session may hold a real index of its own: park it, and put it back at the end.
        $script:savedIndex = & $script:loaderModule {
            $copy = @{}
            foreach ($key in $script:firstUseIndex.Keys) {
                $copy[$key] = $script:firstUseIndex[$key]
            }
            $script:firstUseIndex.Clear()
            $copy
        }

        $script:loaderScript = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine((Split-Path $PSScriptRoot -Parent), 'assets', 'Import-ModuleFiles.ps1'))

        function script:New-FixtureModule {
            param([string] $Name, [string] $Command, [string] $Private)
            $folder = Join-Path $TestDrive $Name
            [System.IO.Directory]::CreateDirectory((Join-Path $folder 'private')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $folder "private/$Private.ps1"), "function $Private { 'secret of $Name' }")
            [System.IO.File]::WriteAllText((Join-Path $folder "$Command.ps1"), "function $Command { $Private }")
            $manifest = Join-Path $folder "$Name.psd1"
            $text = "@{`n    ModuleVersion     = '1.0.0'`n    NestedModules     = @('$script:loaderScript')`n    FunctionsToExport = @('$Command')`n" +
            "    PrivateData       = @{ CatzcFiles = @('private/$Private.ps1', '$Command.ps1') }`n}`n"
            [System.IO.File]::WriteAllText($manifest, $text)
            [pscustomobject]@{ Name = $Name; Command = $Command; Manifest = $manifest; File = Join-Path $folder "$Command.ps1" }
        }
        # The overload with a PowerShell is the one PSReadLine calls; it runs the global TabExpansion2, which the three-argument overload does not.
        function script:Complete-FixtureInput {
            param([string] $Text)
            $shell = [powershell]::Create([System.Management.Automation.RunspaceMode]::CurrentRunspace)
            try {
                [System.Management.Automation.CommandCompletion]::CompleteInput($Text, $Text.Length, $null, $shell)
            }
            finally {
                $shell.Dispose()
            }
        }
        function script:Reset-Fixture {
            foreach ($module in $script:widget, $script:gadget) {
                Remove-Module $module.Name -Force -ErrorAction SilentlyContinue
                Remove-DeferredModule -Name $module.Name
            }
            $ExecutionContext.InvokeCommand.PreCommandLookupAction = $null
            Remove-Variable -Name '__CatzcDeferredTypes' -Scope Global -ErrorAction Ignore
        }

        $script:widget = New-FixtureModule -Name 'FixtureWidgetModule' -Command 'Get-FixtureWidgetValue' -Private 'Get-FixtureWidgetSecret'
        $script:gadget = New-FixtureModule -Name 'FixtureGadgetModule' -Command 'Get-FixtureGadgetValue' -Private 'Get-FixtureGadgetSecret'
    }
    AfterAll {
        Reset-Fixture
        Enable-FirstUseCompletion -Remove
        Set-Item -Path Function:\global:TabExpansion2 -Value $script:savedCompletion
        & $script:loaderModule {
            param($saved)
            foreach ($key in $saved.Keys) {
                $script:firstUseIndex[$key] = $saved[$key]
            }
        } $script:savedIndex
        if ($null -ne $script:savedRecord) {
            Set-Variable -Name '__CatzcDeferredTypes' -Scope Global -Value $script:savedRecord
        }
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = $script:savedHook
    }
    BeforeEach {
        Reset-Fixture
        foreach ($module in $script:widget, $script:gadget) {
            Register-DeferredModule -Name $module.Name -ManifestPath $module.Manifest -CommandName $module.Command
        }
        Enable-FirstUseHook
    }

    It 'keeps a registered module out of the session until one of its commands runs' {
        Get-Module $widget.Name | Should -BeNullOrEmpty
        Get-FixtureWidgetValue | Should -Be 'secret of FixtureWidgetModule'
        Get-Module $widget.Name | Should -Not -BeNullOrEmpty
    }

    It 'reaches the module''s private function through its public one' {
        Get-FixtureWidgetValue | Should -Be 'secret of FixtureWidgetModule'
        Get-Command Get-FixtureWidgetSecret -ErrorAction Ignore | Should -BeNullOrEmpty
    }

    It 'names the command''s source file on its script block' {
        Get-FixtureWidgetValue | Out-Null
        $file = (Get-Command Get-FixtureWidgetValue).ScriptBlock.File
        [System.IO.Path]::GetFullPath($file) | Should -Be ([System.IO.Path]::GetFullPath($widget.File))
    }

    It 'loads only the module that owns the command' {
        Get-FixtureWidgetValue | Out-Null
        Get-Module $gadget.Name | Should -BeNullOrEmpty
    }

    It 'loads a name outside the index nothing' {
        Get-Date | Out-Null
        Get-Module $widget.Name | Should -BeNullOrEmpty
        Get-Module $gadget.Name | Should -BeNullOrEmpty
    }

    It 'matches a command name case-insensitively' {
        & 'get-fixturewidgetvalue' | Should -Be 'secret of FixtureWidgetModule'
    }

    It 'returns the command of an exact Get-Command and loads its module' {
        $command = Get-Command Get-FixtureWidgetValue
        $command.Name | Should -Be 'Get-FixtureWidgetValue'
        Get-Module $widget.Name | Should -Not -BeNullOrEmpty
    }

    It 'loads pending types before the module' {
        $probe = @{ Calls = 0; ModuleLoadedAtTypes = $null }
        Set-Variable -Name '__CatzcDeferredTypes' -Scope Global -Value @{ 'fixture-root' = @{ Path = 'not-used.dll'; ShadowCopy = $false; Loaded = $false } }
        Mock Initialize-Types {
            $probe.Calls++
            $probe.ModuleLoadedAtTypes = [bool] (Get-Module 'FixtureWidgetModule')
            (Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly)['fixture-root'].Loaded = $true
        }.GetNewClosure() -ModuleName Catzc.Internal.Loader

        Get-FixtureWidgetValue | Should -Be 'secret of FixtureWidgetModule'

        $probe.Calls | Should -Be 1
        $probe.ModuleLoadedAtTypes | Should -BeFalse
        Get-Module $widget.Name | Should -Not -BeNullOrEmpty
    }

    It 'loads pending types, and no module, for a command that only waits on them' {
        Reset-Fixture
        $probe = @{ Calls = 0 }
        Set-Variable -Name '__CatzcDeferredTypes' -Scope Global -Value @{ 'fixture-root' = @{ Path = 'not-used.dll'; ShadowCopy = $false; Loaded = $false } }
        Mock Initialize-Types {
            $probe.Calls++
            (Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly)['fixture-root'].Loaded = $true
        }.GetNewClosure() -ModuleName Catzc.Internal.Loader
        function global:Get-FixtureTypesOnly {
            'typed'
        }
        try {
            Enable-FirstUseHook -TypesCommandName 'Get-FixtureTypesOnly'
            Get-FixtureTypesOnly | Should -Be 'typed'
            $probe.Calls | Should -Be 1
            $ExecutionContext.InvokeCommand.PreCommandLookupAction | Should -BeNullOrEmpty
        }
        finally {
            Remove-Item -Path function:global:Get-FixtureTypesOnly -ErrorAction Ignore
        }
    }

    It 'installs the plain script hook, no compiled filter, when only the types are pending' {
        Reset-Fixture
        Set-Variable -Name '__CatzcDeferredTypes' -Scope Global -Value @{ 'fixture-root' = @{ Path = 'not-used.dll'; ShadowCopy = $false; Loaded = $false } }
        Enable-FirstUseHook -TypesCommandName 'Get-FixtureTypesOnly'
        $hook = $ExecutionContext.InvokeCommand.PreCommandLookupAction
        $hook | Should -Not -BeNullOrEmpty
        # Either hook reaches the engine as a delegate; what it closes over tells them apart.
        @($hook.Target.Constants | Where-Object { $_ -is [scriptblock] }).Count | Should -BeGreaterThan 0
        @($hook.Target.Constants | Where-Object { $_ -is [System.Action[string]] }).Count | Should -Be 0
    }

    It 'installs the compiled filter when a module is deferred' {
        $hook = $ExecutionContext.InvokeCommand.PreCommandLookupAction
        $hook | Should -Not -BeNullOrEmpty
        @($hook.Target.Constants | Where-Object { $_ -is [System.Action[string]] }).Count | Should -BeGreaterThan 0
    }

    It 'makes a removed module''s name unknown without loading it' {
        Remove-DeferredModule -Name $widget.Name
        Get-Command Get-FixtureWidgetValue -ErrorAction Ignore | Should -BeNullOrEmpty
        Get-Module $widget.Name | Should -BeNullOrEmpty
    }

    It 'does nothing for a module that was never registered' {
        { Import-DeferredModule -Name 'FixtureNeverRegistered' } | Should -Not -Throw
        { Remove-DeferredModule -Name 'FixtureNeverRegistered' } | Should -Not -Throw
    }

    It 'loads every registered module for -All' {
        Import-DeferredModule -All
        Get-Module $widget.Name | Should -Not -BeNullOrEmpty
        Get-Module $gadget.Name | Should -Not -BeNullOrEmpty
    }

    It 'clears itself once the index is empty' {
        $ExecutionContext.InvokeCommand.PreCommandLookupAction | Should -Not -BeNullOrEmpty
        Get-FixtureWidgetValue | Out-Null
        $ExecutionContext.InvokeCommand.PreCommandLookupAction | Should -Not -BeNullOrEmpty
        Get-FixtureGadgetValue | Out-Null
        $ExecutionContext.InvokeCommand.PreCommandLookupAction | Should -BeNullOrEmpty
    }

    It 'completes a deferred command''s name without loading its module' {
        $result = Complete-FixtureInput 'Get-FixtureWid'
        $hit = @($result.CompletionMatches | Where-Object CompletionText -eq 'Get-FixtureWidgetValue')
        $hit.Count | Should -Be 1
        $hit[0].ResultType | Should -Be ([System.Management.Automation.CompletionResultType]::Command)
        $hit[0].ToolTip | Should -Be $widget.Name
        $result.ReplacementIndex | Should -Be 0
        $result.ReplacementLength | Should -Be 14
        Get-Module $widget.Name | Should -BeNullOrEmpty
    }

    It 'completes a deferred command''s name after a pipe and leaves other positions alone' {
        $piped = Complete-FixtureInput 'Get-Date | Get-FixtureGad'
        @($piped.CompletionMatches | Where-Object CompletionText -eq 'Get-FixtureGadgetValue').Count | Should -Be 1
        $argument = Complete-FixtureInput 'Get-Date -Get-FixtureGad'
        @($argument.CompletionMatches | Where-Object CompletionText -eq 'Get-FixtureGadgetValue').Count | Should -Be 0
        Get-Module $gadget.Name | Should -BeNullOrEmpty
    }

    It 'yields the engine''s own result once after the module has loaded' {
        Get-FixtureWidgetValue | Out-Null
        $result = Complete-FixtureInput 'Get-FixtureWid'
        @($result.CompletionMatches | Where-Object CompletionText -eq 'Get-FixtureWidgetValue').Count | Should -Be 1
    }

    It 'puts the engine''s TabExpansion2 back once the index is empty' {
        Get-FixtureWidgetValue | Out-Null
        Get-FixtureGadgetValue | Out-Null
        (Get-Command TabExpansion2 -CommandType Function).ScriptBlock.ToString() | Should -Be $script:savedCompletion.ToString()
    }

    It 'installs no hook when there is nothing to wait for' {
        Reset-Fixture
        Enable-FirstUseHook
        $ExecutionContext.InvokeCommand.PreCommandLookupAction | Should -BeNullOrEmpty
    }
}
