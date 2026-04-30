// Trivial subscription-kind fixture template. One parameter (workspaceName), configured per
// per-subscription env in configuration/subn.yml / subp.yml.

param workspaceName string

output name string = workspaceName
