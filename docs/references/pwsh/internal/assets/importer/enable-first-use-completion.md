# pwsh/.internal/assets/importer/Enable-FirstUseCompletion.ps1

The completion half of the first-use hook: while a module's load is deferred, its commands are not yet known to the engine, so tab
completion would miss them. This function wraps the session's `TabExpansion2` so the names the first-use index holds still complete. The
loader calls it when the hook is armed and again with `-Remove` when the index empties or the hook is disarmed.

## help

### synopsis

Wraps the session's tab completion so the commands of not-yet-loaded modules still complete, or takes the wrap out again.

### description

Keeps the engine's own `TabExpansion2` in the loader's `firstUseCompletionOriginal` entry and installs a wrapper with the same two parameter
sets, so PSReadLine and `CompleteInput` bind to it as they do to the original. The wrapper runs the original first, and at a command-name
position (the first word, or one after a pipe or a semicolon) it adds each first-use index name that matches the word under the cursor and
that the engine did not already offer. When the engine found nothing, the word itself is the replacement span. Both loader entries are read
through the strict-safe probe
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)). A call
first puts back any wrap it made earlier, so calling it twice never stacks wrappers. It changes only the session's function table, nothing
on disk.

### parameter `Remove`

Takes the wrap out and puts the engine's own `TabExpansion2` back, without installing a new wrap.
