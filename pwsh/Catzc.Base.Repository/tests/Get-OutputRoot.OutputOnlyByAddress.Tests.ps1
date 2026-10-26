Describe 'Get-OutputRoot — no default reaches the output track' -Tag 'L1', 'integrity', 'ADR-AUTO-DEFAULT-OUTPUTONLYBYADDRESS' {
    BeforeAll {
        $script:defaultsIntoOutput = {
            param([System.Management.Automation.CommandInfo] $Command)
            $params = $Command.ScriptBlock.Ast.Body.ParamBlock
            if (-not $params) {
                return
            }
            foreach ($parameter in $params.Parameters) {
                $default = $parameter.DefaultValue
                if (-not $default) {
                    continue
                }
                $intoOutput = $default.Find({
                        param($node)
                        ($node -is [System.Management.Automation.Language.CommandAst] -and
                            $node.GetCommandName() -eq 'Get-OutputRoot') -or
                        ($node -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
                        $node.Value -match '^out([\\/]|$)')
                    }, $true)
                if ($intoOutput) {
                    "$($Command.Name) -$($parameter.Name.VariablePath.UserPath) = $($default.Extent.Text)"
                }
            }
        }
        function script:Test-WidgetOutput {
            param([string] $Path = (Join-Path (Get-RepositoryRoot) 'out/widgets'))
        }
    }

    It 'flags a fixture command whose parameter default points into out/' {
        @(& $script:defaultsIntoOutput (Get-Command Test-WidgetOutput)) | Should -HaveCount 1
    }

    It 'finds no exported Test-*, Assert-* or Format-* command whose parameter default points into out/' {
        $commands = @(Get-Module Catzc.* | ForEach-Object { $_.ExportedFunctions.Values } |
                Where-Object { $_.Verb -in 'Test', 'Assert', 'Format' })
        $commands | Should -Not -BeNullOrEmpty
        @(foreach ($command in $commands) {
                & $script:defaultsIntoOutput $command
            }) | Should -BeNullOrEmpty
    }
}
