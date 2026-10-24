Describe 'Set-VsCodeHiddenAction' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.VSCode -ParameterFilter { $Config -eq 'vscode-settings' } {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings       = [ordered]@{ 'editor.tabSize' = 4 }
                    hidden_actions = [ordered]@{ Widget = @('widget.add', 'widget.remove') }
                })
        }
        $script:absent = 'no-such-widget-process'
        $script:newStore = {
            param([string] $Name)
            $path = Join-Path $TestDrive "$Name.vscdb"
            [Catzc.Base.VSCode.VscodeStateStore]::Write($path, 'gadget.other', 'kept')
            $path
        }
    }

    It 'writes the declared actions into the editor''s hidden-menu state and backs the store up first' {
        $store = & $script:newStore 'fresh'
        $backups = Join-Path $TestDrive 'fresh-backups'
        $result = Set-VsCodeHiddenAction -StorePath $store -BackupDirectory $backups -ProcessName $script:absent
        @($result['Widget']) | Should -Be @('widget.add', 'widget.remove')
        $stored = [Catzc.Base.VSCode.VscodeStateStore]::Read($store, 'menu.hiddenCommands') | ConvertFrom-Json -AsHashtable
        @($stored['Widget']) | Should -Be @('widget.add', 'widget.remove')
        [Catzc.Base.VSCode.VscodeStateStore]::Read($store, 'gadget.other') | Should -Be 'kept'
        @(Get-ChildItem -LiteralPath $backups -Filter 'state.vscdb.*.bak') | Should -HaveCount 1
    }

    It 'keeps what was hidden by hand and adds each declared action once' {
        $store = & $script:newStore 'merged'
        [Catzc.Base.VSCode.VscodeStateStore]::Write($store, 'menu.hiddenCommands', '{"Widget":["widget.manual","widget.add"],"Gadget":["gadget.manual"]}')
        $result = Set-VsCodeHiddenAction -StorePath $store -BackupDirectory (Join-Path $TestDrive 'merged-backups') -ProcessName $script:absent
        @($result['Widget']) | Should -Be @('widget.manual', 'widget.add', 'widget.remove')
        @($result['Gadget']) | Should -Be @('gadget.manual')
    }

    It 'refuses while the editor runs, writing nothing' {
        $store = & $script:newStore 'running'
        { Set-VsCodeHiddenAction -StorePath $store -BackupDirectory (Join-Path $TestDrive 'running-backups') -ProcessName (Get-Process -Id $PID).ProcessName } |
            Should -Throw -ExpectedMessage '*close every VS Code window*'
        [Catzc.Base.VSCode.VscodeStateStore]::Read($store, 'menu.hiddenCommands') | Should -BeNullOrEmpty
    }

    It 'writes and backs up nothing under -WhatIf' {
        $store = & $script:newStore 'whatif'
        $backups = Join-Path $TestDrive 'whatif-backups'
        $null = Set-VsCodeHiddenAction -StorePath $store -BackupDirectory $backups -ProcessName $script:absent -WhatIf
        [Catzc.Base.VSCode.VscodeStateStore]::Read($store, 'menu.hiddenCommands') | Should -BeNullOrEmpty
        Test-Path -LiteralPath $backups | Should -BeFalse
    }
}
