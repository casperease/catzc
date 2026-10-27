# infrastructure/modules/log-analytics.bicep

The reusable module for a Log Analytics workspace, the sink that the diagnostic-setting modules send logs to.

## Use

A template references it with a relative `module` declaration (`../../modules/log-analytics.bicep`), and `bicep build` inlines it.
