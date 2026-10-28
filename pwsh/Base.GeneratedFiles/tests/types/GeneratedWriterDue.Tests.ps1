Describe 'Catzc.Base.GeneratedFiles.GeneratedWriterDue' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    It 'holds the writer name and whether it is due' {
        $row = [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new('Build-Widget', $true)
        $row.Name | Should -BeExactly 'Build-Widget'
        $row.Due | Should -BeTrue
    }

    It 'renders console-ready, naming its type and its two facts' {
        [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new('Build-Widget', $false).ToString() |
            Should -BeLike 'GeneratedWriterDue { *Build-Widget*Due = * }'
    }
}
