# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The renderer settings of drawio.yml that a test may turn, read once and validated.

The edge label presentation, the route of an edge whose ends share no x or y, the keep-out check, the uniform label and the stick man are
the kit's one-setting switches. A module reads them as `declaration_settings.NAME`, never by importing the value, so one assignment here
reaches every reader."""

from .declaration_constants import ACTION
from .declaration_vocabulary import choices
from .drawio_png import DEFAULTS

UNIFORM_LABEL = str(DEFAULTS["renderer"]["uniform-label"]).strip()  # legend | pills: where a word every flow edge shares is said
if UNIFORM_LABEL not in ("legend", "pills"):
    raise ValueError(f"drawio.yml renderer uniform-label '{UNIFORM_LABEL}' is not one of: legend, pills")
EDGE_ROUTE = str(DEFAULTS["renderer"]["edge-route"]).strip()  # elbow | straight: how an edge whose ends share no x or y overlap is routed
if EDGE_ROUTE not in ("elbow", "straight"):
    raise ValueError(f"drawio.yml renderer edge-route '{EDGE_ROUTE}' is not one of: elbow, straight")
FINDINGS_FAIL = DEFAULTS["renderer"]["findings-fail"] == "yes"  # a keep-out hit is an error under the kit's one setting

LABEL_PRESENTATIONS = ("pill", "word")  # the two presentations of an edge's word
EDGE_LABEL = str(DEFAULTS["renderer"]["edge-label"]).strip()  # which one every diagram uses

ACTOR = str(ACTION["actor"]).strip() == "shown"  # the stick man drawn last over the drawing, the cause's fragment as his head

if EDGE_LABEL not in LABEL_PRESENTATIONS:
    choices("drawio.yml renderer edge-label", EDGE_LABEL, LABEL_PRESENTATIONS)
