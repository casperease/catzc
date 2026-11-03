function Get-FunctionDependencyCachePath {
    [OutputType([string])]
    param()

    Join-Path (Get-OutputRoot) 'cache/function-dependency.json'
}
