Describe 'Invoke-Pip' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Pip 'install requests' -DryRun | Should -Be 'python -m pip install requests'
    }
}
