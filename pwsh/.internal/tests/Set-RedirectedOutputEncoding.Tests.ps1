BeforeAll {
    $script:sandbox = Join-Path ([System.IO.Path]::GetTempPath()) "redirected-encoding-$([guid]::NewGuid().ToString('N'))"
    $sandboxAuto = Join-Path $script:sandbox (Get-CatzcModulesFolder)
    [System.IO.Directory]::CreateDirectory($sandboxAuto) | Out-Null
    Copy-Item -Path (Join-Path $env:RepositoryRoot 'importer.ps1') -Destination $script:sandbox
    Copy-Directory (Join-Path (Get-CatzcModulesRoot) '.internal') (Join-Path $sandboxAuto '.internal')
    Copy-Directory (Join-Path (Get-CatzcModulesRoot) '.vendor') (Join-Path $sandboxAuto '.vendor')

    $childScript = ". '$script:sandbox/importer.ps1' -Verbose 4>&1 6>`$null; " +
    "'codepage=' + [Console]::OutputEncoding.CodePage; 'redirected=' + [Console]::IsOutputRedirected"
    $startInfo = [System.Diagnostics.ProcessStartInfo]::new('pwsh')
    foreach ($argument in '-NoProfile', '-Command', $childScript) {
        $startInfo.ArgumentList.Add($argument)
    }
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $process = [System.Diagnostics.Process]::Start($startInfo)
    $errorTask = $process.StandardError.ReadToEndAsync()
    $standardOutput = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    $script:output = @($standardOutput -split '\r?\n' | Where-Object { $_ })
    $script:errorOutput = $errorTask.Result
    $script:exitCode = $process.ExitCode
}

AfterAll {
    if ($script:sandbox -and [System.IO.Directory]::Exists($script:sandbox)) {
        [System.IO.Directory]::Delete($script:sandbox, $true)
    }
}

Describe 'Set-RedirectedOutputEncoding' -Tag 'L1', 'logic', 'ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT' {
    It 'imports cleanly in a redirected child session' {
        $script:exitCode | Should -Be 0 -Because $script:errorOutput
        $script:output | Should -Contain 'redirected=True'
    }

    It 'leaves a redirected session writing UTF-8' {
        $script:output | Should -Contain 'codepage=65001'
    }

    It 'announces the change on the importer''s verbose load record' -Tag 'ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE' {
        @($script:output | Where-Object { $_ -like '*console output encoding UTF-8 (output is redirected)*' }).Count | Should -Be 1
    }
}
