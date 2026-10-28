Describe 'Catzc.Base.GeneratedFiles.GeneratedWriterGraph' -Tag 'L0', 'logic' {
    BeforeAll {
        # One writer row as a module's generated.yml declares it.
        function New-WriterRow {
            param([string] $Name, [string[]] $Inputs = @(), [object[]] $Outputs)
            [Catzc.Base.Variants.GeneratedWriterRow]::new($Name, [ordered]@{ class = 'rollable'; inputs = $Inputs; outputs = $Outputs })
        }
        function Get-RenderOrderName {
            param([object[]] $Rows)
            [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::RenderOrder([Catzc.Base.Variants.GeneratedWriterRow[]] $Rows) | ForEach-Object name
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

    It 'reads a writer as its own inputs and those of each output, each once, and no row as none' {
        $row = New-WriterRow 'Build-Widget' -Inputs 'widget.yml' -Outputs @(
            [ordered]@{ path = 'widget/*.png'; inputs = @('widget/*.md', 'widget.yml') }
            'widget/index.md'
        )
        [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($row) | Should -Be @('widget.yml', 'widget/*.md')
        [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($null) | Should -HaveCount 0
    }

    It 'declares the input walk depth once, on the type' {
        [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::InputDepth | Should -BeGreaterThan 0
    }
}
