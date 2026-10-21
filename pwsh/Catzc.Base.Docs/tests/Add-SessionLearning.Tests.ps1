Describe 'Add-SessionLearning' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Docs.LearningsConfig]::new([ordered]@{ files = 2; lines_per_file = 2 })
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'learnings' } { $script:config }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Docs { $ExecutionContext.SessionState.PSVariable.GetValue('script:root') }
        $script:date = [DateTime]::new(2026, 10, 21)

        # The files oldest first, by their 'Started <time>.' lines.
        function Get-LearningFile {
            $folder = Join-Path $script:root '.claude/learnings'
            [string[]] $files = @([System.IO.Directory]::GetFiles($folder, 'learned*.md') | Sort-Object {
                    $line = [System.IO.File]::ReadAllLines($_) | Where-Object { $_.StartsWith('Started ') } | Select-Object -First 1
                    [DateTimeOffset]::Parse($line.Substring(8).TrimEnd('.'), [cultureinfo]::InvariantCulture)
                })
            , $files
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ('repo-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
    }

    It 'appends each sentence as one dated line to a new, short-named file headed by its start time' {
        $written = @(Add-SessionLearning 'The widget turns.', ' The gadget holds. ' -Date $script:date)
        $written.Count | Should -Be 1
        [System.IO.Path]::GetFileName($written[0]) | Should -Match '^learned[0-9a-f]{6}\.md$'
        $sha = [System.IO.Path]::GetFileNameWithoutExtension($written[0]).Substring('learned'.Length)
        $lines = [System.IO.File]::ReadAllLines($written[0])
        $lines[0] | Should -BeExactly "# Session learnings $sha"
        $lines[2] | Should -BeLike 'Started 20??-*.'
        @($lines | Select-Object -Skip 4) | Should -Be @('- 2026-10-21: The widget turns.', '- 2026-10-21: The gadget holds.')
    }

    It 'wraps a long learning at 140 columns as a list item' {
        $long = (@('widget') * 40) -join ' '
        $written = @(Add-SessionLearning $long -Date $script:date)
        $item = @([System.IO.File]::ReadAllLines($written[0]) | Select-Object -Skip 4)
        $item.Count | Should -BeGreaterThan 1
        $item[0] | Should -BeLike '- 2026-10-21: widget*'
        @($item | Select-Object -Skip 1) | ForEach-Object { $_ | Should -BeLike '  widget*' }
        @($item | Where-Object { $_.Length -gt 140 }).Count | Should -Be 0
    }

    It 'escapes a < outside code spans, so the lint never reads it as inline HTML' {
        $written = @(Add-SessionLearning 'A call needs a timeout <s> prefix, as in `timeout <s> widget`.' -Date $script:date)
        [System.IO.File]::ReadAllLines($written[0])[4] | Should -BeExactly '- 2026-10-21: A call needs a timeout \<s> prefix, as in `timeout <s> widget`.'
    }

    It 'counts a learning a formatter wrapped over two lines once' {
        $written = @(Add-SessionLearning 'The widget turns.' -Date $script:date)
        [System.IO.File]::AppendAllText($written[0], "- 2026-10-21: The gadget holds a long line that a formatter wrapped,`n  onto a second line.`n")
        @(Add-SessionLearning 'The gizmo waits.' -Date $script:date) | Should -Not -Be $written
        [System.IO.File]::ReadAllText($written[0]) | Should -BeLike '*onto a second line.*'
    }

    It 'starts the next file when the newest is full, and keeps repeats' {
        $null = Add-SessionLearning 'The widget turns.', 'The widget turns.' -Date $script:date
        $written = @(Add-SessionLearning 'The gizmo waits.' -Date $script:date)
        $files = Get-LearningFile
        $files.Count | Should -Be 2
        $written | Should -Be @($files[1])
        @([System.IO.File]::ReadAllLines($files[0]) | Where-Object { $_.StartsWith('- ') }).Count | Should -Be 2
    }

    It 'drops the oldest file when a new one would exceed the file count' {
        $null = Add-SessionLearning 'one', 'two' -Date $script:date
        $oldest = (Get-LearningFile)[0]
        $null = Add-SessionLearning 'three', 'four', 'five' -Date $script:date
        $files = Get-LearningFile
        $files.Count | Should -Be 2
        $files | Should -Not -Contain $oldest
        [System.IO.File]::ReadAllText($files[-1]) | Should -BeLike '*- 2026-10-21: five*'
    }

    It 'refuses a file in the folder without a start-time line' {
        $folder = Join-Path $script:root '.claude/learnings'
        [void] [System.IO.Directory]::CreateDirectory($folder)
        [System.IO.File]::WriteAllText((Join-Path $folder 'learnedgizmo.md'), "# Gizmo`n")
        { Add-SessionLearning 'The widget turns.' -Date $script:date } | Should -Throw "*has no 'Started <time>.' line*"
    }

    It 'refuses <Case> and writes nothing' -ForEach @(
        @{ Case = 'an empty learning'; Learning = @('   '); Expected = '*a learning is empty*' }
        @{ Case = 'a learning with a line break'; Learning = @("one`ntwo"); Expected = '*holds a line break*' }
    ) {
        { Add-SessionLearning $Learning -Date $script:date } | Should -Throw $Expected
        [System.IO.Directory]::Exists((Join-Path $script:root '.claude/learnings')) | Should -BeFalse
    }
}
