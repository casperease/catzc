# pwsh/Base.QualityGates/private/Get-ModuleSourceFile.ps1

The canonical set of authored PowerShell files the analysis quality gates cover. Formatting covers a wider set; this one leaves out
`.vendor`, `.compiled` and generated manifests.

## help

### synopsis

The canonical set of authored PowerShell files the analysis quality gates cover.

### description

Formatting covers a wider set (Format-Code); this set leaves out .vendor, .compiled and generated manifests.

### outputs

`[string[]]` Absolute paths, in discovery order.

## Module tests

Each module's tests are found by recursing its tests folder, so nested test code such as `tests/types/*.Tests.ps1` is covered too. Only
`*.Tests.ps1` matches, and `tests/assets/` holds no test files, so the walk picks up real test code only.

## Dot folders

The module loop skips dot-prefixed folders, because they are not modules. `.internal` and `.scriptanalyzer` still hold authored PowerShell
the repository runs, so they are enumerated by name and meet the same bar.

- `.scriptanalyzer` holds the custom analyzer rules and their tests.
- `.internal` holds the shared code the bootstrap and the modules both call (the loader, the bootstrap and the shared library modules), plus
  their tests.
- `.vendor` is third-party and `.compiled` is build output, so both stay excluded.

## Files outside the module tree

Authored files outside the module tree that still ship and run with it meet the same bar: the root `importer.ps1` and the analyzer config
under `.internal/assets`. The analyzer config is the one authored `.psd1`, committed and not generated. Generated module manifests
(`pwsh/**/*.psd1`) are gitignored build output and are left out on purpose.
