"""The kit's YAML loaders, a leaf every module may import: one typed load for declarations and configs, and one that keeps every scalar
as written, for the kit's own defaults, whose values the kit reads as text."""

import yaml

# libyaml's loaders parse when they are present; the pure-Python ones are several times slower. Every kit read goes through these two.
LOADER = getattr(yaml, "CSafeLoader", yaml.SafeLoader)
TEXT_LOADER = getattr(yaml, "CBaseLoader", yaml.BaseLoader)


def load_yaml(text):
    """One YAML document, safely loaded with the kit's typed loader."""
    return yaml.load(text, Loader=LOADER)


def load_yaml_text(text):
    """One YAML document with every scalar a string as written: `yes` stays yes and `000000` stays 000000."""
    return yaml.load(text, Loader=TEXT_LOADER)
