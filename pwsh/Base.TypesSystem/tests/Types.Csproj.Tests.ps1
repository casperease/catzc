# L1: runs dotnet msbuild over the template's own stamp target, so the cases follow the one living version of the check. The loader
# answers from the real tree; only its shadow root moves, through the environment Get-TypesShadowRoot reads.
Describe 'Catzc.Types.csproj — stale types warning' -Tag 'L1', 'integrity' {
    BeforeAll {
        $root = Get-RepositoryRoot
        $template = [xml][System.IO.File]::ReadAllText((Join-Path $root 'pwsh/Base.TypesSystem/assets/Catzc.Types.csproj.xml'))
        $target = $template.SelectSingleNode("//Target[@Name='StampCatzcTypesVersionFromSources']")
        $script:steps = $target.SelectNodes('Exec | Error | PropertyGroup[CatzcTypesShadowRoot] | Warning')
        # The stamp locates the loader from the project's own folder; the project sits in TestDrive, so that folder is a property here.
        $body = ($script:steps | ForEach-Object { $_.OuterXml }) -join ''
        $body = $body.Replace('$(MSBuildProjectDirectory)', '$(CatzcAssets)')
        $script:project = Join-Path $TestDrive 'Check.proj'
        [System.IO.File]::WriteAllText($script:project, "<Project><Target Name=`"Check`">$body</Target></Project>")
        $script:assets = Join-Path $root 'pwsh/.internal/assets'
        $script:shadow = Join-Path $TestDrive 'shadow'
        $script:saved = @{ LOCALAPPDATA = $env:LOCALAPPDATA; HOME = $env:HOME }
        $env:LOCALAPPDATA = $script:shadow
        $env:HOME = $script:shadow
        $script:types = if ($IsWindows) { Join-Path $script:shadow 'catzc/types' } else { Join-Path $script:shadow '.local/share/catzc/types' }
        [void][System.IO.Directory]::CreateDirectory($script:types)

        function script:Invoke-Check {
            & dotnet msbuild $script:project -t:Check -nologo "-p:CatzcAssets=$script:assets" 2>&1 | Out-String
        }
    }

    AfterAll {
        $env:LOCALAPPDATA = $script:saved.LOCALAPPDATA
        $env:HOME = $script:saved.HOME
    }

    It 'lifts the stamp, the shadow root and the warning from the template' {
        $script:steps.Count | Should -Be 4
    }

    It 'warns when only an older-hash DLL is in the shadow root' {
        [System.IO.File]::WriteAllText((Join-Path $script:types 'Catzc.Types.old999.dll'), '')
        $output = Invoke-Check
        $output -match 'the loaded types are older than the sources \(needs Catzc\.Types\.(\w+)\.dll\)' | Should -BeTrue -Because $output
        $script:hash = $Matches[1]
    }

    It 'stays silent when the current-hash DLL is in the shadow root' {
        [System.IO.File]::WriteAllText((Join-Path $script:types "Catzc.Types.$script:hash.dll"), '')
        Invoke-Check | Should -Not -Match 'the loaded types are older than the sources'
    }
}
