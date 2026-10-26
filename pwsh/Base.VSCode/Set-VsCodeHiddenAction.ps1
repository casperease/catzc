<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/Set-VsCodeHiddenAction.ps1.md"
  header: "generated"
---
#>

function Set-VsCodeHiddenAction {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([hashtable])]
    param(
        # VS Code's state store of the default profile, where its hidden-menu state lives.
        [string] $StorePath = (Join-Path ([Environment]::GetFolderPath('ApplicationData')) 'Code/User/globalStorage/state.vscdb'),

        [string] $BackupDirectory = (Join-Path (Get-OutputRoot) 'vscode-state'),

        # The editor's process; a write while it runs is lost, because it writes its in-memory state back on exit.
        [string] $ProcessName = 'Code'
    )

    $declared = (Get-Config -Config vscode-settings).hidden_actions
    Assert-PathExist $StorePath -ErrorText "Set-VsCodeHiddenAction: no VS Code state store at '$StorePath'."
    if (@(Get-Process -Name $ProcessName -ErrorAction Ignore).Count -gt 0) {
        throw "Set-VsCodeHiddenAction: VS Code is running ($ProcessName); close every VS Code window, then run it again, or the editor overwrites the change on exit."
    }

    $key = 'menu.hiddenCommands'
    $current = [Catzc.Base.VSCode.VscodeStateStore]::Read($StorePath, $key)
    $hidden = if ($current) {
        ConvertFrom-Json -InputObject $current -AsHashtable
    }
    else {
        @{}
    }
    foreach ($menu in $declared.Keys) {
        $commands = [System.Collections.Generic.List[string]]::new([string[]]@($hidden[$menu] ?? @()))
        foreach ($command in $declared[$menu].Where({ $_ -cnotin $commands })) {
            $commands.Add($command)
        }
        $hidden[$menu] = $commands.ToArray()
    }

    if ($PSCmdlet.ShouldProcess($StorePath, "hide $(@($declared.Values.ForEach({ $_ })).Count) editor actions")) {
        $null = New-Item -ItemType Directory -Path $BackupDirectory -Force
        Copy-Item -LiteralPath $StorePath -Destination (Join-Path $BackupDirectory "state.vscdb.$([datetime]::Now.ToString('yyyyMMdd-HHmmss')).bak")
        [Catzc.Base.VSCode.VscodeStateStore]::Write($StorePath, $key,
            (ConvertTo-Json -InputObject $hidden -Depth 4 -Compress))
    }
    $hidden
}
