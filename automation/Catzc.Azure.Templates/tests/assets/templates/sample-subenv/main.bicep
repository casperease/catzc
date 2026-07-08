// Trivial subscription-kind fixture template. One parameter (workspaceName), configured per
// per-subscription env in configuration/nsub.yml / psub.yml.

param workspaceName string

output name string = workspaceName
