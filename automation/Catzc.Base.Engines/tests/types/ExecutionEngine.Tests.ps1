# The execution engine model against its per-engine fixture tables (Get-EngineCaseTable): every case is checked under
# every engine, side by side, so a behaviour that differs between pwsh, bash and zsh differs on purpose
# ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)).
BeforeDiscovery {
    $script:startCases = @(Get-EngineCaseTable (Join-Path $PSScriptRoot '../assets/engine-cases/engine-start.yml') -Applicable)
    $script:locatorCases = @(Get-EngineCaseTable (Join-Path $PSScriptRoot '../assets/engine-cases/engine-locator.yml') -Applicable)
}

Describe 'ExecutionEngine' -Tag 'L0', 'logic' {
    It '<Engine>: <Case> starts with the expected arguments' -ForEach $script:startCases {
        $engine = [Catzc.Base.Engines.ExecutionEngines]::Get($Engine)
        $arguments = $engine.StartArguments($Fields.entry, $Fields.command)
        $arguments | Should -Be ([string[]]@($Fields.arguments))
    }

    It '<Engine>: <Case> names and locates the executable' -ForEach $script:locatorCases {
        $engine = [Catzc.Base.Engines.ExecutionEngines]::Get($Engine)
        $engine.ExecutableFileName([bool]$Fields.windows) | Should -Be $Fields.file
        $engine.Locate | Should -Be $Fields.located
        "$($engine.ToolKey)" | Should -Be $Fields.tool
    }

    It 'covers every engine in <_>, so no engine goes unchecked' -ForEach @('engine-start.yml', 'engine-locator.yml') {
        $cases = @(Get-EngineCaseTable (Join-Path $PSScriptRoot "../assets/engine-cases/$_") -Applicable)
        @($cases.Engine | Select-Object -Unique) | Should -Be @([Catzc.Base.Engines.ExecutionEngines]::Names)
    }

    It 'rejects an empty entry or command, naming it' {
        { [Catzc.Base.Engines.ExecutionEngines]::Pwsh.StartArguments('', 'Get-Widget') } | Should -Throw '*entry script*'
        { [Catzc.Base.Engines.ExecutionEngines]::Bash.StartArguments('/home/widget/importer.sh', ' ') } | Should -Throw '*needs a command*'
    }
}

Describe 'ExecutionEngines' -Tag 'L0', 'logic' {
    It 'declares exactly pwsh, bash and zsh, pwsh first' {
        @([Catzc.Base.Engines.ExecutionEngines]::Names) | Should -Be @('pwsh', 'bash', 'zsh')
        @([Catzc.Base.Engines.ExecutionEngines]::All.Name) | Should -Be @('pwsh', 'bash', 'zsh')
    }

    It 'gets an engine by name, and throws naming the engines for any other' {
        [Catzc.Base.Engines.ExecutionEngines]::Get('bash') | Should -Be ([Catzc.Base.Engines.ExecutionEngines]::Bash)
        [Catzc.Base.Engines.ExecutionEngines]::Get('zsh') | Should -Be ([Catzc.Base.Engines.ExecutionEngines]::Zsh)
        { [Catzc.Base.Engines.ExecutionEngines]::Get('widget') } | Should -Throw "*'widget' is not an execution engine (one of: pwsh, bash, zsh)*"
    }

    It 'declares what differs between the engines: <Name>' -ForEach @(
        @{ Name = 'pwsh'; Extension = '.ps1'; Shebang = $null; StrictMode = 'Set-StrictMode -Version Latest'; Safeguard = 'Invoke-WithTimeout'; Lf = $false; Bit = $false; Importer = 'importer.ps1'; Prefix = '' }
        @{ Name = 'bash'; Extension = '.sh'; Shebang = '#!/usr/bin/env bash'; StrictMode = 'set -euo pipefail'; Safeguard = 'timeout'; Lf = $true; Bit = $true; Importer = 'importer.sh'; Prefix = 'cats ' }
        @{ Name = 'zsh'; Extension = '.zsh'; Shebang = '#!/usr/bin/env zsh'; StrictMode = 'setopt ERR_EXIT NO_UNSET PIPE_FAIL'; Safeguard = 'timeout'; Lf = $true; Bit = $true; Importer = 'importer.sh'; Prefix = 'cats ' }
    ) {
        [Catzc.Base.Engines.ExecutionEngines]::Get($Name).CommandPrefix | Should -BeExactly $Prefix
        $engine = [Catzc.Base.Engines.ExecutionEngines]::Get($Name)
        $engine.ScriptExtensions[0] | Should -Be $Extension
        $engine.Shebang | Should -Be $Shebang
        $engine.StrictMode | Should -Be $StrictMode
        $engine.TimeSafeguard | Should -Be $Safeguard
        $engine.RequiresLf | Should -Be $Lf
        $engine.RequiresExecutableBit | Should -Be $Bit
        $engine.ImporterEntry | Should -Be $Importer
    }
}
