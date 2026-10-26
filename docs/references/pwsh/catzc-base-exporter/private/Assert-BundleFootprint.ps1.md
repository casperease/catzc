# pwsh/Base.Exporter/private/Assert-BundleFootprint.ps1

The private guard that counts the files and bytes of a build and throws when they exceed the bundle's `max_files` or `max_bytes`.

## help

### synopsis

Throws when a build holds more files or bytes than its bundle's footprint limits allow.

### description

A bundle is a small engine carried to other environments, so how big it is is a checked property, not a hope
([ADR-AUTO-BUNDLE](../../../../drs/automation/platform-bundle.md)). The limits are the bundle's own max_files and max_bytes in exporter.yml
(ExporterBundle); a limit the bundle does not state is not checked. Every exceeded limit is reported in one throw, with the build's
top-level folders by size, so the message says where the weight is.

### parameter `Path`

The build root (the `Catzc/<version>/` folder).

### parameter `Bundle`

The bundle's exporter.yml entry (an ExporterBundle).

### outputs

`[pscustomobject]` Files, Bytes — the measured footprint, also when no limit is stated.

## The walk

The walk is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the footprint
counts every shipped byte, so nothing is pruned.
