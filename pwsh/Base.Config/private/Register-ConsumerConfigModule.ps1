function Register-ConsumerConfigModule {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Changes the session''s config index only, never a file.')]
    param(
        [Parameter(Mandatory)]
        [string] $Namespace,

        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $Directory
    )

    $systemNamespace = 'Catzc'
    if ($Namespace -ceq $systemNamespace -or $Namespace.StartsWith("$systemNamespace.", [System.StringComparison]::Ordinal)) {
        throw "The module '$Module' registers its configs in the namespace '$Namespace', which is the system's (ADR-AUTO-CONSUMER-OWNCONFIGS); a consumer's configs live in its own namespace."
    }

    # Probed through the variable table, so the first registration under strict mode finds no list instead of throwing.
    $modules = $ExecutionContext.SessionState.PSVariable.GetValue('script:consumerConfigModules')
    if ($null -eq $modules) {
        $modules = [System.Collections.Generic.List[hashtable]]::new()
        $script:consumerConfigModules = $modules
    }
    # A re-import registers a module again; the later registration stands.
    foreach ($earlier in @($modules | Where-Object { $_.Module -ceq $Module })) {
        [void] $modules.Remove($earlier)
    }
    $fullDirectory = [System.IO.Path]::GetFullPath($Directory)
    $modules.Add(@{
            Namespace = $Namespace
            Module    = $Module
            Directory = $fullDirectory
            Folder    = [System.IO.Path]::GetFileName([System.IO.Path]::TrimEndingDirectorySeparator($fullDirectory))
        })
    # The next resolve reads the index whole, this module in it.
    $script:configIndex = $null
}
