# pwsh/Base.ModuleSystem/tests/types/FunctionCallCollector.Tests.ps1

The tests of [FunctionCallCollector](../../types/function-call-collector.md). It must attribute every statically named call in a file to
the top-level function whose body holds it, and list the functions nested inside each, the walk `Test-FunctionDependency` resolves calls
from. Each case parses the source of a small widget and gadget script.
