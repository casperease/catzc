# pwsh/.internal/tests/Invoke-ImporterJanitors.Tests.ps1

The tests of the build janitors the importer runs and of the writers list they read from `generated-files.yml`.

## The registry

The registry the janitor reads holds the eight at-import writers in the order the import runs them, and one writer the import leaves alone
(`at_import` false). The janitor considers only the writers marked at import, none of its own list.
