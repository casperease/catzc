# Azure explanations

```text
How cats models and names what it deploys onto Azure.

Azure name assembly    a name is a pure function of its components, never typed, never truncated
Infrastructure kinds   templates, configuration slots and reusable modules, and what a change to each reaches
```

These articles explain decisions from the [azure DRS domain](../../drs/index.md#azure): how a resource name is assembled from the identity
data model and never typed by hand. Each article narrates one diagram; the [explanation index](../index.md) says how to read them.

## Azure name assembly

An Azure name is a pure function of its components, and it is never truncated
([azure-naming-standard](../../drs/azure/azure-naming-standard.md)).

| Lens           | Article                                                                                                                   |
| -------------- | ------------------------------------------------------------------------------------------------------------------------- |
| meta           | [An Azure name is a pure function of its components, and it is never truncated](what-an-azure-name-is-made-from.md)       |
| architecture   | [One resolver gathers the components and one namer assembles every Azure name](which-code-builds-azure-names.md)          |
| implementation | [The namer looks up, forms, checks and renders a name in that order](how-an-azure-resource-gets-its-name.md)              |
| operations     | [Nobody types an Azure name: cats derives it, and a bad name stops with an error](where-an-azure-name-comes-from.md)      |
| governance     | [Code holds all eight naming rules, seven of them behind a check that throws](how-the-azure-naming-rules-are-enforced.md) |

## Infrastructure kinds

Infrastructure code is of three kinds, each placed by the infrastructure track
([infrastructure-kinds](../../drs/azure/infrastructure-kinds.md)).

- **meta**: [Infrastructure code is of three kinds, and a template pulls its modules and its configuration slots together][kinds]
- **operations**: [Changing one configuration slot runs only its owner's pipeline and reaches only its resource group][one-slot]
- **operations**: [A change to one module fans out to every template that references it and every pipeline that deploys one][fan-out]
- **operations**: [A new template is one folder in the templates place, found through the track and named in the pipelines that deploy
  it][add-template]
- **operations**: [A new configuration slot is one new file; discovery finds it, one subscription must fit it, and it deploys a new resource
  group][add-env]

[kinds]: what-kinds-of-infrastructure-code-exist.md
[one-slot]: what-a-configuration-slot-change-reaches.md
[fan-out]: what-a-bicep-module-change-reaches.md
[add-template]: how-a-bicep-template-is-added.md
[add-env]: how-a-configuration-slot-is-added.md
