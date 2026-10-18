Describe 'Catzc.Base.VSCode.VscodeTasksConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:valid = {
            [ordered]@{
                version = '2.0.0'
                tasks   = @(
                    [ordered]@{ label = 'Fixture'; type = 'process'; command = 'widget' }
                )
            }
        }

        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.VscodeTasksConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the VscodeTasksConfig constructor to throw'
        }
    }

    It 'accepts a well-formed registry and keeps task keys in authored order' {
        $raw = & $script:valid
        $raw['tasks'][0]['args'] = @('-x')
        $raw['inputs'] = @([ordered]@{ id = 'gadget'; type = 'promptString' })
        $config = [Catzc.Base.VSCode.VscodeTasksConfig]::new($raw)
        $config.version | Should -Be '2.0.0'
        @($config.tasks[0].Keys) | Should -Be @('label', 'type', 'command', 'args')
        $config.inputs[0]['id'] | Should -Be 'gadget'
    }

    It 'treats absent inputs as an empty list' {
        $config = [Catzc.Base.VSCode.VscodeTasksConfig]::new((& $script:valid))
        $config.inputs.Count | Should -Be 0
    }

    It 'rejects an unknown top-level key' {
        $raw = & $script:valid
        $raw['widget'] = 1
        Get-ViolationMessage $raw | Should -Match "unknown top-level key 'widget'"
    }

    It 'rejects a missing version' {
        $raw = & $script:valid
        $raw.Remove('version')
        Get-ViolationMessage $raw | Should -Match "'version' must be a non-empty string"
    }

    It 'rejects an empty task list' {
        $raw = & $script:valid
        $raw['tasks'] = @()
        Get-ViolationMessage $raw | Should -Match "'tasks' must be a non-empty list"
    }

    It 'rejects a task without a label and a duplicate label' {
        $raw = & $script:valid
        $raw['tasks'] = @([ordered]@{ type = 'process' }, [ordered]@{ label = 'A' }, [ordered]@{ label = 'a' })
        $message = Get-ViolationMessage $raw
        $message | Should -Match "missing a non-empty 'label'"
        $message | Should -Match "duplicate task label 'a'"
    }

    It 'rejects an input without an id and a duplicate id' {
        $raw = & $script:valid
        $raw['inputs'] = @([ordered]@{ type = 'promptString' }, [ordered]@{ id = 'A' }, [ordered]@{ id = 'a' })
        $message = Get-ViolationMessage $raw
        $message | Should -Match "missing a non-empty 'id'"
        $message | Should -Match "duplicate input id 'a'"
    }
}
