# pwsh/Base.Config/private/Register-ConsumerConfigModule.ps1

The seam through which the importer hands `Get-Config` a consumer module: its namespace, its name and its folder. The resolver walks the
folder's `configs/` on its next read and indexes what it finds under the namespace
([ADR-AUTO-CONSUMER-OWNCONFIGS](../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-ownconfigs)).

## help

### synopsis

Registers one consumer module with the config index, under its track's namespace.

### description

Records the module for `Resolve-ConfigEntry`, which reads every registered module's `configs/*.yml` and `configs/configs.yml` into the
(namespace, name) index when it next builds it, and drops the built index so that read happens. The importer calls it for each module of a
consumer track after it found them by layout and before it reads the consumer's own `dependencies` config, so the index knows the module by
then. A module registered again, as a re-import does, replaces its earlier registration. The system's namespace is refused: a consumer's
configs live in its own ([ADR-AUTO-CONSUMER-OWNTRACKS](../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntracks)).

### parameter `Namespace`

The track's namespace, the one the module's configs resolve in.

### parameter `Module`

The module's full name, `<namespace><join><folder>`, the owner its index entries name.

### parameter `Directory`

The module's folder under the working root; its `configs/` child holds the module's configs and its registry.
