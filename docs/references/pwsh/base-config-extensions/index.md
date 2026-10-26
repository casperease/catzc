# Catzc.Base.ConfigExtensions

The PowerShell extension point for config validation. Core configs validate through their C# config type when `Get-Config` loads them (see
[Catzc.Base.Config](catzc-base-config.md)). A config whose owner cannot ship a C# type validates here instead: through a PowerShell
validator that receives the parsed dictionary and throws on a violation. This is the form for tracks and deployable-units that carry their
own configuration on PowerShell extension points (see [module-config-loading](../../drs/configuration/module-config-loading.md), the
PowerShell extension point). The module deliberately does **not** load configs, and core configs never use it.

## Responsibilities

| Responsibility   | Area       | Name                                                             |
| ---------------- | ---------- | ---------------------------------------------------------------- |
| responsibility:1 | validation | [PowerShell validators](#responsibility1--powershell-validators) |
| responsibility:2 | gate       | [Validator coverage](#responsibility2--validator-coverage)       |

### responsibility:1 — PowerShell validators

Running a config's PowerShell validator in the module that owns it. The validator is found by convention, `Assert-<TitleCase(name)>Config`
(so `widget-parts` is `Assert-WidgetPartsConfig`), or named explicitly, and runs inside the owning module's scope, so a private validator
resolves and the result does not depend on the caller. A conventional validator that does not exist is a no-op; a named one that does not
exist fails.

### responsibility:2 — Validator coverage

Keeping the convention honest: a validator whose name maps to no shipped config of its module is never called, so the quality gate lists
every such orphan over the loaded code root.

## What the module does

Most of the platform's configuration is typed: a C# config type maps and validates each file once, at load. That path needs a compiled type
in an automation module. A track or deployable-unit that rests on PowerShell extension points has no such type, yet its configuration still
deserves one checked shape. This module keeps that second form alive and separate, so the core reader stays one path (typed, or raw) and the
PowerShell form is used only where a C# type cannot be.

## Division

Each function belongs to one responsibility.

| Responsibility                           | Function                 |
| ---------------------------------------- | ------------------------ |
| responsibility:1 — PowerShell validators | `Invoke-ConfigValidator` |
| responsibility:2 — Validator coverage    | `Test-ConfigValidators`  |
