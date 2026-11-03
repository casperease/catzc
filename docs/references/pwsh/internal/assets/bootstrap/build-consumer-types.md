# pwsh/.internal/assets/bootstrap/Build-ConsumerTypes.ps1

The consumer half of the types load: a bundle compiles the consumer's own `types/*.cs` in-process after catzc's prebuilt assembly is loaded
([ADR-AUTO-CONSUMER-OWNTYPES](../../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntypes)). `Import-CSharpTypes`
calls it in a bundle load only; source mode compiles nothing for a consumer.

## help

### synopsis

Compiles and loads a consumer's own C# types, one assembly per track namespace, against catzc's loaded assembly.

### description

Reads the consumer's tracks from the working root's `.catzc/configs/variants.yml`, since the config registry is not loaded this early. For
each `modules` track with a namespace, it gathers the `types/*.cs` of the modules under the track's places and compiles them through
`Build-CombinedTypeAssembly` into `<Namespace>.Types.<hash>.dll` under the working root's `out/`, referencing catzc's assembly. A deferred
catzc load happens first (`Initialize-Types`), and the catzc assembly is found by its file name, built from `Get-TypesAssemblyPrefix` so the
name has one place. A hash the namespace already loaded is reused; a changed hash warns on a devbox and throws in a pipeline. Each type's
`[PSTypeAlias]` accelerators are registered, and an alias outside the track's namespace is refused
([ADR-PWSH-TYPES-LOADKEYEDONNAMESPACE](../../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-loadkeyedonnamespace)).
A track whose namespace is `Catzc` or under it is refused
([ADR-AUTO-CONSUMER-OWNTRACKS](../../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntracks)). Nothing is read or
compiled when the working root has no variants config or no track with types.

### parameter `WorkingRoot`

The consumer's repository root, where `.catzc/configs/variants.yml` is read and `out/` receives the assemblies.

### parameter `CatzcHash`

The combined source hash of catzc's own assembly, which names the loaded `Catzc.Types.<hash>.dll` the consumer's assembly references.
