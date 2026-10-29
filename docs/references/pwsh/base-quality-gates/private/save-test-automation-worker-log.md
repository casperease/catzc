# pwsh/Base.QualityGates/private/Save-TestAutomationWorkerLog.ps1

Saves a test worker's whole console to its log file, so an error Pester only printed is read after the run.

## help

### synopsis

Writes a test worker's standard output, then its standard error, to the worker's log file.

### description

Writes the worker's standard output and, when the worker wrote any errors, a `--- stderr ---` line followed by its standard error, to the
log file as UTF-8 without a byte order mark. An empty or absent stream writes nothing for that stream.

### parameter `Path`

The worker's log file, `worker-shard-<n>.log` in the run folder.

### parameter `StandardOutput`

The worker's captured standard output.

### parameter `StandardError`

The worker's captured standard error.
