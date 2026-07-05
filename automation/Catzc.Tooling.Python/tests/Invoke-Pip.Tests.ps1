Describe 'Invoke-Pip' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun (routes through uv pip)' {
        Invoke-Pip 'install --system requests' -DryRun | Should -Be 'uv pip install --system requests'
    }
}
