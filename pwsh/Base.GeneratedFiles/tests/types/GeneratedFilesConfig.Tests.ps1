Describe 'Catzc.Base.GeneratedFiles.GeneratedFilesConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the GeneratedFilesConfig constructor to throw'
        }
        # One writer row as a module's generated.yml declares it.
        function New-WriterRow {
            param([string] $Name, [string[]] $Inputs = @(), [object[]] $Outputs)
            [Catzc.Base.Variants.GeneratedWriterRow]::new($Name, [ordered]@{ class = 'rollable'; inputs = $Inputs; outputs = $Outputs })
        }
        function Get-RenderOrderName {
            param([object[]] $Rows)
            [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::RenderOrder([Catzc.Base.Variants.GeneratedWriterRow[]] $Rows) | ForEach-Object name
        }
    }

    It 'renders a writer after every writer whose output it reads, whatever the declaration order' {
        $rows = @(
            New-WriterRow 'Build-Sprocket' -Inputs 'gadget/**' -Outputs 'sprocket/index.md'
            New-WriterRow 'Build-Gadget' -Outputs @([ordered]@{ path = 'gadget/*.png'; inputs = @('widget/*.md') })
            New-WriterRow 'Build-Widget' -Inputs 'widget.yml' -Outputs 'widget/*.md'
        )
        Get-RenderOrderName $rows | Should -Be @('Build-Widget', 'Build-Gadget', 'Build-Sprocket')
    }

    It 'breaks a tie by writer name, so the order never depends on the declaration order' {
        $rows = @(
            New-WriterRow 'Build-Widget' -Inputs 'cog/*.md' -Outputs 'widget/index.md'
            New-WriterRow 'Build-Gadget' -Outputs 'gadget/index.md'
            New-WriterRow 'Build-Cog' -Outputs 'cog/index.md'
            New-WriterRow 'Build-Gizmo' -Outputs 'gizmo/index.md'
        )
        Get-RenderOrderName $rows | Should -Be @('Build-Cog', 'Build-Gadget', 'Build-Gizmo', 'Build-Widget')
        Get-RenderOrderName @($rows[3], $rows[1], $rows[0], $rows[2]) | Should -Be @('Build-Cog', 'Build-Gadget', 'Build-Gizmo', 'Build-Widget')
    }

    It 'ignores a writer whose own output matches its own input, as a picture glob matching its slide or a target listed as an input' {
        $rows = @(
            New-WriterRow 'Build-Widget' -Outputs @([ordered]@{ path = 'widget/*.slide.png'; inputs = @('widget/*.png', 'widget/*.md') })
            New-WriterRow 'Build-Gadget' -Inputs '.gadget.yml', 'widget/*.slide.png' -Outputs '.gadget.yml'
        )
        Get-RenderOrderName $rows | Should -Be @('Build-Widget', 'Build-Gadget')
    }

    It 'rejects a cycle between two writers, naming both, and a writer declared twice' {
        $rows = @(
            New-WriterRow 'Build-Widget' -Inputs 'gadget/*.md' -Outputs 'widget/*.md'
            New-WriterRow 'Build-Gadget' -Inputs 'widget/**' -Outputs 'gadget/index.md'
            New-WriterRow 'Build-Cog' -Inputs 'gadget/index.md' -Outputs 'cog/index.md'
        )
        { Get-RenderOrderName $rows } | Should -Throw -ExpectedMessage '*has a cycle: Build-Gadget -> Build-Widget -> Build-Gadget;*'
        { Get-RenderOrderName @($rows[0], $rows[0]) } | Should -Throw -ExpectedMessage "*declares the writer 'Build-Widget' twice*"
    }

    It 'rejects a glob the pattern dialect cannot read, naming its writer' {
        { Get-RenderOrderName @(New-WriterRow 'Build-Widget' -Inputs 'widget//index.md' -Outputs 'widget/index.md') } |
            Should -Throw -ExpectedMessage "*writer 'Build-Widget':*empty segment*"
    }

    It 'declares every default once: a writer with no keys is a file check reading Path' {
        $config = [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{ 'Build-Widget' = $null } })
        $config.writers['Build-Widget'].check | Should -Be 'file'
        $config.writers['Build-Widget'].result_path | Should -Be 'Path'
    }

    It 'declares at_import once: a writer re-renders at import only when it says so' {
        $config = [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{
                    'Build-Widget' = $null
                    'Build-Gadget' = [ordered]@{ at_import = $true }
                }
            })
        $config.writers['Build-Widget'].at_import | Should -BeFalse
        $config.writers['Build-Gadget'].at_import | Should -BeTrue
    }

    It 'declares the input and output globs once: a writer with neither lists none, a named list is kept' {
        $config = [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{
                    'Build-Widget' = $null
                    'Build-Gadget' = [ordered]@{ inputs = @('widget/**', 'gadget/*.yml'); outputs = 'widget/index.md' }
                }
            })
        $config.writers['Build-Widget'].inputs | Should -HaveCount 0
        $config.writers['Build-Widget'].outputs | Should -HaveCount 0
        $config.writers['Build-Gadget'].inputs | Should -Be @('widget/**', 'gadget/*.yml')
        $config.writers['Build-Gadget'].outputs | Should -Be @('widget/index.md')
    }

    It 'keeps the writers in declaration order and honours a named result path and check' {
        $config = [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{
                    'Build-Widget' = [ordered]@{ result_path = 'Gadget' }
                    'Build-Gadget' = [ordered]@{ check = 'root-config' }
                }
            })
        @($config.writers.Keys) | Should -Be @('Build-Widget', 'Build-Gadget')
        $config.writers['Build-Widget'].result_path | Should -Be 'Gadget'
        $config.writers['Build-Gadget'].check | Should -Be 'root-config'
        $config.writers['Build-Gadget'].result_path | Should -BeNullOrEmpty
    }

    It 'declares the input walk depth once: an omitted input_depth is the type default, a named one is kept, a non-positive one is rejected' {
        $config = [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{ 'Build-Widget' = $null } })
        $config.input_depth | Should -Be ([Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::DefaultInputDepth)
        [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{ 'Build-Widget' = $null }; input_depth = 4 }).input_depth | Should -Be 4
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = $null }; input_depth = 0 }) |
            Should -BeLike "*'input_depth' must be a positive whole number*"
    }

    It 'rejects an unknown top-level key, an empty registry and a missing writers key' {
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = $null }; gadgets = 1 }) |
            Should -BeLike "*unknown top-level key 'gadgets' (allowed: writers, input_depth)*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{} }) |
            Should -BeLike "*'writers' must be a non-empty map*"
        Get-ViolationMessage ([ordered]@{}) | Should -BeLike "*'writers' must be a non-empty map*"
    }

    It 'rejects a name that is not a command name, an unknown key, an unknown check and a result path on a check that reads none' {
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ widget = $null } }) |
            Should -BeLike "*writer name 'widget' is invalid*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ gadget = 1 } } }) |
            Should -BeLike "*writer 'Build-Widget' carries unknown key 'gadget'*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ check = 'gadget' } } }) |
            Should -BeLike "*writer 'Build-Widget' has unknown check 'gadget'*"
        Get-ViolationMessage ([ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ check = 'root-config'; result_path = 'Path' } } }) | Should -BeLike "*writer 'Build-Widget' sets result_path*"
    }

    It 'loads the shipped generated-files.yml' {
        $config = Get-Config -Config generated-files
        $config.writers.Contains('Build-RootConfig') | Should -BeTrue
        $config.writers['Build-Readme'].result_path | Should -Be 'Readme'
        $config.writers['Build-DrsIndex'].outputs | Should -Be @('docs/drs/index.md')
    }
}
