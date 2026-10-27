# infrastructure/modules/diagnostic-setting.bicep

The reusable module that sends one resource's logs and metrics to a Log Analytics workspace.

## How it attaches

A diagnostic setting attaches to a typed resource, so the caller names the resource kind and the resource. The module picks the log and
metric categories that kind exposes, taking the logs through the `allLogs` category group.

## Related module

The subscription's activity log has its own module, `subscription-diagnostic-setting.bicep`. `bicep build` inlines this module into the
template that references it.
