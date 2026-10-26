# pwsh/Base.Docs/tests/types/DocsConfig.Tests.ps1

The tests of the compiled `DocsConfig`, `DocMapping` and `DocPattern` types, called directly: the constructor is the gate that stops a
malformed or duplicated `readme.yml` registry from ever producing an instance.
