# pwsh/Base.Overlay/private/Get-ConsumerModuleViolation.ps1

The check of a consumer's own modules: it returns one message per reason a module of a consumer track breaks the rules, so `Assert-Overlay`
can list them all.

## help

### synopsis

Returns every rule a consumer track's modules break.

### description

A consumer's own code lives in its own tracks, declared in its working-root variants, and its modules are named `<Namespace>.<Folder>`
([ADR-AUTO-CONSUMER-OWNTRACKS](../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntracks),
[ADR-AUTO-CONSUMER-SOURCEMODULES](../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-sourcemodules)). The check runs
over every track `Get-Track` lists in build mode apart from the engine's own, and over every module folder of a modules track's places:

```text
namespace   a track whose namespace is Catzc or starts with Catzc. (PDR-CATS-CATZCISSOURCENAME)
shadowing   a public function file (at the module folder's root) whose name is a command already loaded from another
            module: it would silently replace a bundled command, and a replacement is an override under .catzc/
config      a configs/configs.yml entry whose name a sealed catzc config has and whose type is in the Catzc namespace:
            it tries to override catzc's config. The same name registered in the consumer's own namespace and type is
            the design (ADR-AUTO-CONSUMER-OWNCONFIGS) and passes.
types/      allowed: a consumer's C# types compile in the working root (ADR-AUTO-CONSUMER-OWNTYPES)
```

In source mode there is no consumer, and nothing is checked.

### outputs

`[string]` One message per violation; nothing when the consumer is clean.

## Where the modules come from

The module folders are read from each modules track's places under the repository root, skipping dot folders and the folders a module-type
place excepts, such as a track's test holder, the same way the config index finds a consumer track's modules. Each module's full name is the
track's `FullNameOf` the folder ([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
