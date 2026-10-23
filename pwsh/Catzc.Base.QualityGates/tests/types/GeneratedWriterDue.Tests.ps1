Describe 'Catzc.Base.QualityGates.GeneratedWriterDue' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    It 'holds the writer name, whether it is due and whether it declares lists' {
        $row = [Catzc.Base.QualityGates.GeneratedWriterDue]::new('Build-Widget', $true, $false)
        $row.Name | Should -BeExactly 'Build-Widget'
        $row.Due | Should -BeTrue
        $row.HasLists | Should -BeFalse
    }

    It 'renders console-ready, naming its type and its three facts' {
        [Catzc.Base.QualityGates.GeneratedWriterDue]::new('Build-Widget', $false, $true).ToString() |
            Should -BeLike 'GeneratedWriterDue { *Build-Widget*Due = *HasLists = * }'
    }
}
