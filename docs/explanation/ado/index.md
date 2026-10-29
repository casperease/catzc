# Ado explanations

```text
How Azure DevOps REST calls choose and prove their credentials.

Azure DevOps auth precedence   the first configured credential wins, and it must prove its org
```

These articles explain decisions from the [ado DRS domain](../../drs/index.md#ado). Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.

## Azure DevOps auth precedence

The first configured credential wins, and it must prove its org ([dual-authentication](../../drs/ado/dual-authentication.md)).

- **meta**: [The first configured credential wins, and it must prove its org](configured-credential-proves-its-org.md)
- **architecture**:
  [One function owns the credential precedence, and ado.yml anchors every proof](where-the-ado-credential-precedence-lives.md)
- **implementation**:
  [The header function is four checks and three returns, and none falls through on failure](how-the-ado-header-function-checks-a-credential.md)
- **operations**:
  [What you set decides the credential, and each wrong setup stops with its own message](which-ado-credential-a-setup-selects.md)
- **governance**: [The PAT proof and the empty-token assert have no gate](which-ado-auth-checks-have-a-gate.md)
