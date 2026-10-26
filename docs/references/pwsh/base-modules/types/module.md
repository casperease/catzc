# pwsh/Base.Modules/types/Module.cs

A module of a deployable track as the one resolver, `Get-CatzcModule`, returns it: identity only. Its needs and its place in the order are
functions of the declared graph over module names, not members of this type.

It rests on [ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../../../drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule)
and [ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel).

## Properties

A module has a name, the track and module type that hold it, its place and root, the shape of the root (folder, file or root), its files and
languages in ordinal order, the execution engines it runs under, and the files its layout places in no row, which are findings and never
silently part of the module.
