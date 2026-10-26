# pwsh/.internal/tests/Set-RedirectedOutputEncoding.Tests.ps1

The tests of `Set-RedirectedOutputEncoding`, which sets the output encoding when a process's standard output is redirected.

## The sandbox

An isolated sandbox holds the importer, the `.internal` shared modules and vendor, with no application modules, imported in a fresh child
pwsh (the same shape as `Import-AllModules.Tests.ps1`). Capturing the child's output redirects its standard output, which is the case under
test.

## One cold import

One cold import runs, with its verbose load record merged into the captured output. The child gets its own console (`CreateNoWindow`):
assigning the output encoding sets the code page of the console a process is attached to, so a child sharing this worker's console would
inherit whatever the worker's own import already set.
