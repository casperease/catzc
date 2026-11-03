function Invoke-LanguageModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('^[^/\\]+(/[^/\\]+)+$', Options = 'None')]
        [string] $Module,

        [string[]] $Arguments,

        [string] $WorkingDirectory,

        [switch] $PassThru,

        [switch] $Silent
    )

    # The module is '<track place>/<Module>', the last segment its folder name and the rest its place.
    $segments = $Module.Replace('\', '/').Trim('/').Split('/')
    $name = $segments[-1]
    $place = $segments[0..($segments.Count - 2)] -join '/'
    $folder = Get-CatzcModuleRoot -Place $place -Module $name
    $hasFile = { param($leaf) [System.IO.File]::Exists([System.IO.Path]::Combine($folder, $leaf)) }

    # One resolution order: a manifest the exporters wrote first, then the source form of the folder.
    $runner = $null
    $entry = $null
    $prefix = @()
    $folderDirectory = $false
    $pythonPath = $null
    if (& $hasFile 'wheels.json') {
        $uv = Resolve-ToolExecutable -Tool uv
        if (-not ($uv.Found -and $uv.VersionOk)) {
            throw "The python module $Module needs the managed uv at the tools.yml pin '$($uv.Required)' (found: $($uv.Version ?? 'none')). Run Install-Uv."
        }
        $manifestPath = [System.IO.Path]::Combine($folder, 'wheels.json')
        $manifestHash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($manifestPath))).ToLowerInvariant()
        $venv = Join-Path (Get-OutputRoot) "language-modules/$($place.Replace('/', '-'))-$name/venv"
        $stamp = Join-Path $venv 'catzc-wheels.sha256'
        $venvPython = Join-Path $venv ($IsWindows ? 'Scripts/python.exe' : 'bin/python')

        # The environment is made once, offline, from the shipped wheels, and redone when wheels.json changed.
        $current = [System.IO.File]::Exists($stamp) -and [System.IO.File]::ReadAllText($stamp).Trim() -eq $manifestHash
        if (-not $current) {
            $pin = (Resolve-ToolExecutable -Tool python).Required
            $wheelArguments = @(ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText($manifestPath)) | ForEach-Object { "`"$([System.IO.Path]::Combine($folder, 'wheels', $_.name))`"" })
            if ([System.IO.Directory]::Exists($venv)) {
                Remove-Item -LiteralPath $venv -Recurse -Force
            }
            $saved = [System.Environment]::GetEnvironmentVariable('UV_PYTHON_DOWNLOADS')
            [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', 'never')
            try {
                $create = Invoke-Executable "`"$($uv.Path)`" venv --offline --python $pin `"$venv`"" -PassThru -NoAssert -Silent
                if ($create.ExitCode -ne 0) {
                    throw "uv could not create the environment of $Module (exit $($create.ExitCode)); is the python pin installed? Run Install-Python.`n$($create.Full)"
                }
                if ($wheelArguments.Count) {
                    $install = Invoke-Executable "`"$($uv.Path)`" pip install --offline --no-index --find-links `"$([System.IO.Path]::Combine($folder, 'wheels'))`" --python `"$venvPython`" $($wheelArguments -join ' ')" -PassThru -NoAssert -Silent
                    if ($install.ExitCode -ne 0) {
                        throw "uv could not install the wheels of $Module (exit $($install.ExitCode)).`n$($install.Full)"
                    }
                }
            }
            finally {
                [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', $saved)
            }
            $null = New-Item -ItemType Directory -Path $venv -Force
            [System.IO.File]::WriteAllText($stamp, $manifestHash)
        }
        $runner = $venvPython
        $prefix = @('-m')
        $entry = $name
        $folderDirectory = $true
        $pythonPath = [System.IO.Path]::GetDirectoryName($folder)
    }
    elseif (& $hasFile 'binaries.json') {
        $platform = Get-HostPlatform
        $records = @(ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText([System.IO.Path]::Combine($folder, 'binaries.json'))))
        $record = @($records | Where-Object { $_.path.StartsWith("$($platform.Replace('/', '-'))/", [System.StringComparison]::Ordinal) }) | Select-Object -First 1
        if (-not $record) {
            throw "The go module $Module has no binary for this platform ($platform); its binaries.json lists: $((@($records | ForEach-Object { $_.path }) -join ', '))."
        }
        $runner = [System.IO.Path]::Combine($folder, $record.path)
    }
    elseif (& $hasFile 'executables.json') {
        $listed = @(ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText([System.IO.Path]::Combine($folder, 'executables.json'))))
        if ($listed.Count -ne 1) {
            throw "The bash module $Module lists $($listed.Count) executables in executables.json; running one needs exactly one entry."
        }
        $runner = Resolve-EngineExecutable -Engine bash
        $entry = [string]$listed[0]
        $folderDirectory = $true
    }
    elseif (& $hasFile 'go.mod') {
        $go = Resolve-ToolExecutable -Tool go
        if (-not $go.Found) {
            throw 'go is not installed (no managed go found). Run Install-Go.'
        }
        if (-not $go.VersionOk) {
            throw "go at $($go.Path) reports version '$($go.Version)', but tools.yml pins '$($go.Required)'. Run Install-Go."
        }
        $runner = $go.Path
        $prefix = @('run', '.')
        $folderDirectory = $true
    }
    else {
        $scripts = @([System.IO.Directory]::GetFiles($folder, '*.sh', [System.IO.SearchOption]::TopDirectoryOnly))
        $jsEntry = @('index.js', 'extension.js') | Where-Object { & $hasFile $_ } | Select-Object -First 1
        if ($scripts.Count -eq 1) {
            $runner = Resolve-EngineExecutable -Engine bash
            $entry = [System.IO.Path]::GetFileName($scripts[0])
            $folderDirectory = $true
        }
        elseif ($jsEntry) {
            $node = Resolve-ToolExecutable -Tool node_js
            if (-not $node.Found -or -not $node.VersionOk) {
                throw "node is not installed at the tools.yml pin '$($node.Required)' (found: $($node.Version ?? 'none')). Run Install-NodeJs."
            }
            $runner = $node.Path
            $entry = $jsEntry
            $folderDirectory = $true
        }
        else {
            throw "Invoke-LanguageModule found nothing to run in $Module (no binaries.json, executables.json, go.mod, one *.sh, index.js or extension.js)."
        }
    }

    $quote = { param($text) if ($text -match '\s') {
            "`"$text`""
        }
        else {
            $text
        } }
    $parts = @("`"$runner`"") + @($prefix) + @(if ($entry) {
            & $quote $entry
        }) + @($Arguments | Where-Object { $null -ne $_ } | ForEach-Object { & $quote $_ })

    $directory = if ($WorkingDirectory) {
        $WorkingDirectory
    }
    elseif ($folderDirectory) {
        $folder
    }
    else {
        Get-RepositoryRoot
    }
    $savedPythonPath = [System.Environment]::GetEnvironmentVariable('PYTHONPATH')
    try {
        if ($pythonPath) {
            [System.Environment]::SetEnvironmentVariable('PYTHONPATH', $pythonPath)
        }
        Invoke-Executable ($parts -join ' ') -WorkingDirectory $directory -PassThru:$PassThru -Silent:$Silent
    }
    finally {
        if ($pythonPath) {
            [System.Environment]::SetEnvironmentVariable('PYTHONPATH', $savedPythonPath)
        }
    }
}
