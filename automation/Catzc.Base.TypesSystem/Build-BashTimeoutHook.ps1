function Build-BashTimeoutHook {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $OutputDirectory = (Join-Path (Get-RepositoryRoot) '.claude/hooks/bin'),
        [switch] $Force
    )

    Assert-SourceTree

    $project = Join-Path (Get-RepositoryRoot) '.claude/hooks/Assert-BashTimeout'
    Assert-PathExist $project -PathType Container

    $csproj = Join-Path $project 'Assert-BashTimeout.csproj'
    Assert-PathExist $csproj
    $projectXml = [xml](Get-Content -LiteralPath $csproj -Raw)

    $sources = @(Get-ChildPath $project -File -Filter '*.cs', '*.csproj' -Depth 1 | Sort-Object { [System.IO.Path]::GetFileName($_) })
    Assert-True ($sources.Count -gt 0) -ErrorText "No hook files (*.cs, *.csproj) in $project"
    $linked = @($projectXml.SelectNodes('//Compile/@Include') | ForEach-Object Value | Sort-Object)
    $hashLines = @($sources | ForEach-Object { "$([System.IO.Path]::GetFileName($_)):$((Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash)" })
    foreach ($include in $linked) {
        $linkedPath = Join-Path $project $include
        Assert-PathExist $linkedPath -PathType Leaf
        $hashLines += "$($include):$((Get-FileHash -LiteralPath $linkedPath -Algorithm SHA256).Hash)"
    }
    $sourceHash = $hashLines -join "`n"

    $assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object { $_ } | Select-Object -First 1
    Assert-NotNullOrWhitespace $assemblyName -ErrorText "No <AssemblyName> in $csproj — it names the published hook program."
    $programBase = Join-Path $OutputDirectory $assemblyName
    $findProgram = {
        $application = Get-Command -Name $programBase -CommandType Application -ErrorAction Ignore | Select-Object -First 1
        if ($application) {
            $application.Source
        }
    }

    $stamp = Join-Path $OutputDirectory 'source.sha256'
    $program = & $findProgram
    $isCurrent = $program -and (Test-Path -LiteralPath $stamp) -and ((Get-Content -LiteralPath $stamp -Raw).Trim() -ceq $sourceHash.Trim())
    if ($isCurrent -and -not $Force) {
        return $program
    }

    if (-not (Test-Command 'dotnet')) {
        throw 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Build-BashTimeoutHook.'
    }

    Invoke-Executable "dotnet publish `"$csproj`" --configuration Release --output `"$OutputDirectory`" --verbosity quiet --disable-build-servers" -Silent
    $program = & $findProgram
    Assert-NotNullOrWhitespace $program -ErrorText "dotnet publish succeeded but produced no runnable '$assemblyName' program in $OutputDirectory."
    Set-Content -LiteralPath $stamp -Value $sourceHash -NoNewline
    Write-Message "Agent hook: published the Bash time safeguard to $program"

    $program
}
