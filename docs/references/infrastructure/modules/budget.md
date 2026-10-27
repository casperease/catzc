# infrastructure/modules/budget.bicep

The reusable module for a cost budget. It deploys at subscription level (`targetScope = 'subscription'`) and creates one alert per threshold
the caller lists.

## Alerts

Each alert goes to the holders of the listed subscription roles, Owner by default. No email address is kept in configuration; the recipients
follow the role assignments of the subscription.

## Use

A template references the module with a relative `module` declaration, and `bicep build` inlines it into the template's `main.json`.
