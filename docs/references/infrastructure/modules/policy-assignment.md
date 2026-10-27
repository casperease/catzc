# infrastructure/modules/policy-assignment.bicep

The reusable module for one policy assignment. It deploys at subscription level (`targetScope = 'subscription'`).

## Inputs

The caller passes the policy definition id, its parameters and the enforcement mode. The mode has no default here: the template reads it
from the repository-wide `policy_enforcement` setting in `azure.yml`.

## Remediation identity

A policy whose effect deploys or modifies resources (`deployIfNotExists`, `modify`) needs a managed identity and the roles its remediation
uses. Set `assignIdentity` and list the role definition ids, and the module grants them on the subscription.

## Use

`bicep build` inlines the module into the template that references it.
