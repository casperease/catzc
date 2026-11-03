# pwsh/Base.Config/private/Get-CallerNamespace.ps1

The private walk behind the namespace a bare config name resolves in: it finds the module that called the reader and gives its namespace.

## help

### synopsis

Gives the namespace of the module that called the reader running it.

### description

The one place the caller's namespace is found, shared by Get-Config and Get-ConfigValue
([ADR-AUTO-CONSUMER-OWNCONFIGS](../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-ownconfigs)). It walks
`Get-PSCallStack` from the frame above the reader that called it to the first frame whose command has a module name, so a script block
inside a module function counts as that module. The first segment of that module name before its dot is the namespace. A script, the console
and a module with no dot in its name give `Catzc`, so catzc's call sites keep reading catzc's configs and a consumer module's calls read its
own.

The reader that calls it is a function of Catzc.Base.Config, whose own frame would always give `Catzc`, so the walk skips it. A function
that wraps a reader asks here for its own caller and hands the answer on as the reader's -Namespace, which is how Get-ConfigValue serves a
consumer module.
