---
catzc:
  config:
    pattern: table
    deck: product-thesis
    order: 12
---

# Configure, don't program

## Eyebrow

Principle 2 of 6 · PDR-CONFIG

## Rows

| Rule                                       | Says                                                                                    |
| ------------------------------------------ | --------------------------------------------------------------------------------------- |
| PDR-CONFIG-VARYINGBEHAVIOURISCONFIG        | Behaviour that varies by instance is a config entry; code is one mechanism per kind     |
| PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE       | Adding an instance is a config change; new code means the mechanism is missing or wrong |
| PDR-CONFIG-DEFAULTDECLAREDONCE             | Every setting has a sensible default, declared once on its config type                  |
| PDR-CONFIG-EXCEPTIONISCONFIGENTRY          | An exception is a declared config entry with its reason, never a branch in code         |
| PDR-CONFIG-DEFAULTANSWERSINSTANCEQUESTIONS | A question about one instance is answered by the default; ask only about the default    |

## Notes

One mechanism per kind, one config entry per instance. Rule five saves meetings: supporting an instance costs one line of config, so nobody
asks whether it is worth supporting.
