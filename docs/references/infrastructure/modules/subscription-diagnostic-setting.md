# infrastructure/modules/subscription-diagnostic-setting.bicep

The reusable module that sends the subscription's activity log to a Log Analytics workspace, which may live in another subscription. It
deploys at subscription level (`targetScope = 'subscription'`).

## Related module

Resource-level settings use `diagnostic-setting.bicep`. `az bicep build` inlines this module into the template that references it.
