function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
