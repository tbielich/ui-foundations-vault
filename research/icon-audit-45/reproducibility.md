---
id: lesson.icon-audit-45-reproducibility
title: Icon Set Audit Reproducibility (Issue 45)
type: lesson
status: draft
owners:
  - ui-foundations
created: 2026-10-31
updated: 2026-10-31
authority: supporting
summary: Self-contained, executable reproduction of the icon audit tool and its tests, plus extraction and run commands.
consumers:
  - human
  - agent
  - codex
  - kiro
applies_to:
  - ui-foundations
  - ui-foundations-runtime
related:
  supports:
    - lesson.icon-audit-45
provenance:
  sources:
    - type: issue
      role: source
      repository: ui-foundations-vault
      number: 45
    - type: repository
      role: derived-from
      repository: ui-foundations-runtime
      path: src/assets/icons
verification:
  status: unverified
---

# Icon Set Audit Reproducibility (Issue 45)

## Why this document exists

The Vault forbids committing runtime implementation code (`AGENTS.md`: "Agents
must not add runtime implementation, application code, ..."). The issue, however,
requires executable JSON evidence produced by an audit script. To keep the Vault
self-contained and still honor that boundary, the **complete** Python source for
the audit tool and its tests is embedded here as fenced code blocks, not as
committed `.py` files inside the Vault. This markdown document is the canonical,
copy-pasteable record; a Vault checkout does **not** contain a `tools/`
directory or any runnable `.py` file.

To reproduce the evidence you do not reconstruct the tool by hand. The
extraction snippet below reads the two fenced `python` blocks out of this
document with `re.findall` and writes `audit_icons.py` and
`test_audit_icons.py` into a temporary working directory **outside** the Vault.
The audit is then run from that temporary directory, and the pinned source
snapshot and the generated JSON evidence are also written **outside** the Vault.
The embedded code blocks are the source of truth; do not hand-edit the generated
inventory/findings/summary JSON. The JSON produced by this run is expected to
match the research JSON committed under `vault/research/icon-audit-45/`
(`inventory.json`, `findings.json`, `summary.json`) byte-for-byte, including the
same provenance flags (`issue=45`, the runtime SHA, and the vault base) that the
committed output carries.

## Pinned source (repository / SHA / path)

- Runtime repository: `tbielich/ui-foundations-runtime`
- Runtime commit (SHA): `aa153b79668df7c3b655a96d9541171de1899580`
- Icon source path (owned input): `src/assets/icons/*.svg`
- Vault repository: `tbielich/ui-foundations-vault`
- Vault base (SHA): `995c580ce6f162fbf9baa2f5e4819da1aa3384d8`
- Implementation guide: `docs/agentic/icon-creation.md` at the runtime SHA above
- Usage guide: `site/patterns/icon.md` at the runtime SHA above

The pinned source contains **601** SVG files under `src/assets/icons`.

## Provenance to pass to the tool

Pass pinned provenance so the output is deterministic and self-describing:

- `issue=45`
- `runtime-commit=aa153b79668df7c3b655a96d9541171de1899580`
- `vault-base=995c580ce6f162fbf9baa2f5e4819da1aa3384d8`

## Extraction and run commands

The tool is stdlib-only and needs Python 3.10+ (it uses PEP 604 `X | None` type
hints at runtime in dataclass fields). The commands below are self-contained:
they extract the tool from this document, pin the runtime checkout by SHA via
`git archive`, and keep every generated artifact outside the Vault. Run them
from inside a Vault checkout (so this document is reachable); the commands
capture its absolute path first, then do all their work in a temporary
directory **outside** the Vault.

Step 0 is an **executable** extraction snippet: it reads the two fenced
`python` blocks out of this markdown file with `re.findall` and writes them to
`audit_icons.py` and `test_audit_icons.py` in a temporary `tools/` directory
**outside** the Vault. There is no manual reconstruction step, and the Vault
checkout is not expected to contain a `tools/` directory.

```bash
set -euo pipefail

# Avoid writing .pyc caches during the run.
export PYTHONDONTWRITEBYTECODE=1

RUNTIME_REPO="https://github.com/tbielich/ui-foundations-runtime.git"
RUNTIME_SHA="aa153b79668df7c3b655a96d9541171de1899580"

# Capture the absolute path to THIS document while still inside the Vault
# checkout, before we cd anywhere else. Adjust the prefix if your Vault
# checkout root differs; the path below is relative to the Vault repo root.
DOC="$(pwd)/research/icon-audit-45/reproducibility.md"

# Create a working directory OUTSIDE the Vault and move into it. Everything
# below (extracted tool, pinned source, JSON evidence) is written here, never
# inside the Vault checkout.
WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/icon-audit-45.XXXXXX")"
cd "$WORKDIR"
mkdir -p tools evidence

# 0. Extract the two embedded tool files from the markdown document into the
#    temporary tools/ directory. This reads the fenced ```python blocks in
#    order: the first is audit_icons.py, the second is test_audit_icons.py.
#    No manual copy/paste and no reconstruction by hand.
python3 - "$DOC" <<'PY'
import re
import sys

doc_path = sys.argv[1]
with open(doc_path, "r", encoding="utf-8") as fh:
    text = fh.read()

# Grab every fenced python block, in document order.
blocks = re.findall(r"```python\n(.*?)\n```", text, re.DOTALL)
if len(blocks) < 2:
    sys.exit(f"expected 2 python blocks in {doc_path}, found {len(blocks)}")

with open("tools/audit_icons.py", "w", encoding="utf-8") as fh:
    fh.write(blocks[0] + "\n")
with open("tools/test_audit_icons.py", "w", encoding="utf-8") as fh:
    fh.write(blocks[1] + "\n")
PY

# 1. Fetch ONLY the pinned icon source + guides at the exact SHA, with no
#    dependence on a local clone path. git archive streams a tarball of the
#    pinned tree; we extract just the paths the audit needs. All of this lands
#    inside the temporary WORKDIR, outside the Vault.
mkdir -p pinned-source
git clone --no-checkout "$RUNTIME_REPO" runtime-checkout
git -C runtime-checkout archive "$RUNTIME_SHA" \
      src/assets/icons \
      docs/agentic/icon-creation.md \
      site/patterns/icon.md \
  | tar -x -C pinned-source

# 2. Run the audit against the OWNED input directory. --source points at the
#    icon directory read by scripts/generate-icon-list.mjs (invoked from
#    build.mjs Stage 1). --output MUST be outside and not inside --source. The
#    --source-label keeps artifacts byte-identical regardless of run location.
python3 tools/audit_icons.py \
  --source pinned-source/src/assets/icons \
  --output evidence/initial-audit \
  --source-label src/assets/icons \
  --provenance issue=45 \
  --provenance runtime-commit="$RUNTIME_SHA" \
  --provenance vault-base=995c580ce6f162fbf9baa2f5e4819da1aa3384d8

# This writes evidence/initial-audit/inventory.json, findings.json, summary.json
# under the temporary WORKDIR. These JSON files are expected to match the
# research JSON committed under vault/research/icon-audit-45/ byte-for-byte,
# carrying the same provenance flags (issue=45, the runtime SHA, the vault
# base) as the committed output.

# 3. Run the fixture tests (from the tools/ directory so the import resolves),
#    with bytecode writing disabled so no __pycache__ is produced.
( cd tools && PYTHONDONTWRITEBYTECODE=1 python3 -m unittest test_audit_icons -v )
```

A parse failure in any icon exits non-zero (code 2) and writes no JSON, by
design: icons are never silently omitted. An empty source directory, or an
`--output` equal to or inside `--source`, exits non-zero before writing anything.

## Determinism notes

- Icons are sorted by canonical name; JSON is emitted with `sort_keys=True` and
  a trailing newline.
- The per-icon `source_path` and the inventory `source_root` are the stable,
  repository-relative `--source-label` (default `src/assets/icons`), not derived
  from the on-disk output location, so identical input bytes produce identical
  artifacts regardless of where or how deep the audit runs.
- Provenance is supplied by the caller; the tool never reads the clock, the
  environment, or the network.
- The stroke color is compared to the documented `#9747FF`; the observed
  stroke-color distribution is reported separately as a non-normative statistic
  with a deterministic ordering (highest count, then lexicographically smallest).

## Complete source: `audit_icons.py`

```python
#!/usr/bin/env python3
"""Icon audit tool for ui-foundations-vault#45.

Produces a reproducible, deterministic inventory, findings, and summary for the
SVG icon set that the runtime owns (``src/assets/icons/*.svg``, read by the
runtime ``scripts/generate-icon-list.mjs`` and invoked from ``build.mjs``
Stage 1).

Design constraints (see the vault research report):

* Standard library only. No third-party dependencies.
* No network, shell, or filesystem mutation outside the ``--output`` directory.
* Deterministic output: stable sort order, sorted JSON keys, pinned
  provenance supplied by the caller (never read from the environment or clock).
  The reported per-icon ``path`` and the inventory ``source_root`` are stable,
  repository-relative strings supplied by the caller, so the same input bytes
  produce the same output bytes regardless of where on disk the audit runs.
* Parse errors FAIL the run rather than silently omitting an icon.
* The tool *describes* what it observes and compares it to source-backed rule
  IDs. It never invents approved numeric governance, and it never promotes
  repeated implementation conventions to canonical rules. Everything that
  depends on rendered geometry, runtime usage, or human judgement is reported
  as ``requires-visual-review`` or ``guideline-gap``.

Rule provenance keys used throughout:

* ``impl-guide``  -> source/docs/agentic/icon-creation.md (implementation guide,
                      status: active, authority: implementation convention only)
* ``usage-guide`` -> source/site/patterns/icon.md (component usage scope)
* ``vault-pattern`` -> vault/patterns/base/icon.pattern.md (derived draft)

None of those sources is approved numeric governance. The audit therefore marks
numeric expectations as heuristic/proposed, never as hard canonical rules.

Authority note on color (D1):

The implementation guide states explicitly that every ``<path>`` uses
``stroke="#9747FF"``. That documented value is the comparison criterion for the
``impl-guide.stroke.color`` rule: ``#9747FF`` PASSES; any other concrete stroke
color is INCONSISTENT with the implementation guide (a convention conflict, not
a production defect, because the guide is a convention and not approved
governance). The observed color distribution is reported separately, with no
normative force. The runtime CSS ``mask``/``currentColor`` technique is a
DIFFERENT SCOPE (component usage, not the asset) and is not tested here; the
applicability of that usage to the asset-level hardcoded color is reported as
``requires-visual-review`` rather than invented as an approved exception.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from typing import Any

SVG_NS = "http://www.w3.org/2000/svg"
XLINK_NS = "http://www.w3.org/1999/xlink"

# Elements that carry raster content when referenced with a raster href.
RASTER_HREF_RE = re.compile(r"\.(png|jpe?g|gif|webp|bmp|tiff?)(\?|#|$)", re.IGNORECASE)
DATA_RASTER_RE = re.compile(r"^data:image/(png|jpe?g|gif|webp|bmp|tiff?)", re.IGNORECASE)

# Hex colors anywhere in an attribute value.
HEX_COLOR_RE = re.compile(r"#[0-9a-fA-F]{3,8}\b")
# Functional colors we treat as "hardcoded" when they appear on paint
# attributes. currentColor and none are explicitly NOT hardcoded colors.
FUNCTIONAL_COLOR_RE = re.compile(r"(rgb|rgba|hsl|hsla)\s*\(", re.IGNORECASE)

PAINT_ATTRS = ("stroke", "fill", "color", "stop-color", "flood-color", "lighting-color")

# The stroke color the implementation guide documents for every path. This is
# the documented comparison criterion for impl-guide.stroke.color, NOT an
# approved governance value and NOT a "placeholder/authoring" color (the guide
# does not call it that).
DOCUMENTED_STROKE = "#9747ff"

# CSS-wide keywords that resolve a property without naming a concrete value.
# These are legitimate, resolvable keywords (not "unknown CSS"); we record how
# they resolve rather than treating them as concrete paint values.
CSS_WIDE_KEYWORDS = ("inherit", "initial", "unset", "revert")

# CSS named colors that appear in this set (and the common ones we must never
# silently treat as non-colors). A named color on a paint attribute is a
# hardcoded color just like a hex value.
NAMED_COLORS = {
    "white", "black", "red", "green", "blue", "yellow", "orange", "purple",
    "gray", "grey", "silver", "maroon", "olive", "lime", "aqua", "teal",
    "navy", "fuchsia", "pink", "brown", "gold", "cyan", "magenta",
}

# Elements that mean "there is CSS / references this tool does not evaluate".
UNEVALUATED_ELEMENTS = {"style", "use"}


def local_name(tag: str) -> str:
    """Return the namespace-stripped local name of an element tag."""
    if tag.startswith("{"):
        return tag.split("}", 1)[1]
    return tag


def namespace_uri(tag: str) -> str | None:
    """Return the namespace URI of an element tag, or None if unqualified."""
    if tag.startswith("{"):
        return tag[1:].split("}", 1)[0]
    return None


def strip_attr_ns(attr: str) -> str:
    """Return a readable attribute name, mapping known namespaces to prefixes."""
    if attr.startswith("{"):
        uri, name = attr[1:].split("}", 1)
        if uri == XLINK_NS:
            return f"xlink:{name}"
        if uri == SVG_NS:
            return name
        return name
    return attr


class ParseError(Exception):
    """Raised when an icon cannot be parsed. Must fail the run, not be skipped."""

    def __init__(self, path: str, message: str):
        super().__init__(f"{path}: {message}")
        self.path = path
        self.message = message


@dataclass
class ElementObservation:
    """Flat observation of a single SVG element."""

    name: str
    attributes: dict[str, str]


@dataclass
class IconRecord:
    """Everything observed about one icon file. Ordering here is informational;
    JSON serialization uses sorted keys for determinism."""

    name: str
    path: str
    source_path: str
    sha256: str
    bytes: int
    root_attributes: dict[str, str] = field(default_factory=dict)
    root_namespace: str | None = None
    width: str | None = None
    height: str | None = None
    viewbox: str | None = None
    root_fill: str | None = None
    element_counts: dict[str, int] = field(default_factory=dict)
    path_count: int = 0
    group_count: int = 0
    paths: list[dict[str, Any]] = field(default_factory=list)
    # Aggregated paint analysis across all paint-bearing elements.
    stroke_values: list[str] = field(default_factory=list)
    effective_strokes: list[str] = field(default_factory=list)
    fill_values: list[str] = field(default_factory=list)
    effective_fills: list[str] = field(default_factory=list)
    stroke_widths: list[str] = field(default_factory=list)
    # Explicit stroke-width observed on ANY element (path, g, svg, ...), with
    # the element name for context. Catches inherited widths (D2).
    explicit_stroke_widths: list[str] = field(default_factory=list)
    # Paths that carry a literal `fill` attribute in the source, whatever its
    # value (D2 literal-syntax vs effective-model distinction).
    paths_with_literal_fill: list[str] = field(default_factory=list)
    linecaps: list[str] = field(default_factory=list)
    linejoins: list[str] = field(default_factory=list)
    hardcoded_colors: list[str] = field(default_factory=list)
    has_transform: bool = False
    has_mask: bool = False
    has_clip: bool = False
    has_defs: bool = False
    has_raster: bool = False
    has_title: bool = False
    has_desc: bool = False
    has_metadata: bool = False
    aria_attributes: dict[str, str] = field(default_factory=dict)
    role: str | None = None
    inline_style_present: bool = False
    unresolved_css: list[str] = field(default_factory=list)
    # <style> sheets, class references and <use>/href references we do not
    # evaluate. Their presence forces a review row, never a false pass (D3).
    unevaluated_refs: list[str] = field(default_factory=list)
    elements: list[ElementObservation] = field(default_factory=list)

    def to_json(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "path": self.path,
            "source_path": self.source_path,
            "sha256": self.sha256,
            "bytes": self.bytes,
            "root_attributes": self.root_attributes,
            "root_namespace": self.root_namespace,
            "width": self.width,
            "height": self.height,
            "viewbox": self.viewbox,
            "root_fill": self.root_fill,
            "element_counts": self.element_counts,
            "path_count": self.path_count,
            "group_count": self.group_count,
            "paths": self.paths,
            "paint": {
                "stroke_values": sorted(set(self.stroke_values)),
                "effective_strokes": sorted(set(self.effective_strokes)),
                "fill_values": sorted(set(self.fill_values)),
                "effective_fills": sorted(set(self.effective_fills)),
                "stroke_widths": sorted(set(self.stroke_widths)),
                "explicit_stroke_widths": sorted(set(self.explicit_stroke_widths)),
                "paths_with_literal_fill": sorted(set(self.paths_with_literal_fill)),
                "linecaps": sorted(set(self.linecaps)),
                "linejoins": sorted(set(self.linejoins)),
                "hardcoded_colors": sorted(set(self.hardcoded_colors)),
            },
            "structure": {
                "has_transform": self.has_transform,
                "has_mask": self.has_mask,
                "has_clip": self.has_clip,
                "has_defs": self.has_defs,
                "has_raster": self.has_raster,
            },
            "metadata": {
                "has_title": self.has_title,
                "has_desc": self.has_desc,
                "has_metadata": self.has_metadata,
                "role": self.role,
                "aria_attributes": self.aria_attributes,
            },
            "css": {
                "inline_style_present": self.inline_style_present,
                "unresolved": sorted(set(self.unresolved_css)),
                "unevaluated_refs": sorted(set(self.unevaluated_refs)),
            },
            "elements": [
                {"name": e.name, "attributes": e.attributes} for e in self.elements
            ],
        }


def is_hardcoded_color(value: str) -> list[str]:
    """Return the list of hardcoded color tokens found in a paint value.

    ``none``, ``currentColor``, ``transparent``, url() refs and the CSS-wide
    keywords (inherit/initial/unset/revert) are NOT hardcoded colors. Hex,
    rgb()/hsl() functional colors and named colors (white/red/...) are.
    """
    found: list[str] = []
    normalized = value.strip()
    low = normalized.lower()
    if low in ("none", "currentcolor", "transparent", ""):
        return found
    if low in CSS_WIDE_KEYWORDS:
        return found
    if low.startswith("url("):
        return found
    found.extend(HEX_COLOR_RE.findall(normalized))
    if FUNCTIONAL_COLOR_RE.search(normalized):
        found.append(normalized)
    if low in NAMED_COLORS:
        found.append(low)
    return found


def parse_inline_style(style: str) -> tuple[dict[str, str], list[str]]:
    """Parse an inline ``style`` attribute into declarations.

    Returns (declarations, unresolved). We resolve plain ``prop: value``
    declarations, including the CSS-wide keywords inherit/initial/unset/revert
    and ``!important`` (the priority is stripped and the value kept). Anything
    we cannot confidently resolve (custom properties, var(), functions,
    at-rules, malformed chunks) is reported as unresolved so the audit never
    silently pretends to understand CSS it does not evaluate (D3).
    """
    declarations: dict[str, str] = {}
    unresolved: list[str] = []
    for chunk in style.split(";"):
        decl = chunk.strip()
        if not decl:
            continue
        if ":" not in decl:
            unresolved.append(decl)
            continue
        prop, value = decl.split(":", 1)
        prop = prop.strip().lower()
        value = value.strip()
        # Strip a trailing !important priority (simple, supported case): we keep
        # the declared value and drop the priority marker.
        m = re.search(r"!\s*important\s*$", value, re.IGNORECASE)
        if m:
            value = value[: m.start()].strip()
        if prop.startswith("--") or "var(" in value.lower():
            unresolved.append(decl)
            continue
        if not value:
            unresolved.append(decl)
            continue
        declarations[prop] = value
    return declarations, unresolved


# Presentation attributes that cascade from an ancestor to descendants in SVG.
INHERITED_PAINT = ("stroke", "fill", "stroke-width", "stroke-linecap", "stroke-linejoin", "color")

# Initial (default) values for the paint properties per the SVG spec when no
# value is specified anywhere in the inheritance chain.
SVG_INITIAL = {
    "stroke": "none",
    "fill": "black",
    "stroke-width": "1",
    "stroke-linecap": "butt",
    "stroke-linejoin": "miter",
    "color": "black",
}


def resolve_property(
    prop: str,
    own: dict[str, str],
    inherited: dict[str, str],
) -> tuple[str, str]:
    """Resolve the effective value of a paint property for an element.

    Returns (value, source) where source is one of ``explicit`` (set on the
    element, incl. inline style), ``inherited`` (from an ancestor), or
    ``initial`` (SVG default). The CSS-wide keywords are resolved against the
    inheritance chain: ``inherit`` takes the inherited value; ``initial`` and
    ``unset``/``revert`` (for inherited properties ``unset``==``inherit``) are
    mapped to the inherited value if present else the SVG initial. We never emit
    a bare keyword as if it were a concrete paint value (D3).
    """
    def resolve_keyword(raw: str, kw_source: str) -> tuple[str, str]:
        low = raw.strip().lower()
        if low == "inherit":
            if prop in inherited:
                return inherited[prop], f"{kw_source}:inherit"
            return SVG_INITIAL.get(prop, ""), f"{kw_source}:inherit-initial"
        if low == "initial":
            return SVG_INITIAL.get(prop, ""), f"{kw_source}:initial"
        # unset/revert: for inherited paint properties this behaves like
        # inherit; fall back to the SVG initial when nothing is inherited.
        if prop in inherited:
            return inherited[prop], f"{kw_source}:{low}-inherit"
        return SVG_INITIAL.get(prop, ""), f"{kw_source}:{low}-initial"

    if prop in own:
        raw = own[prop]
        if raw.strip().lower() in CSS_WIDE_KEYWORDS:
            return resolve_keyword(raw, "explicit")
        return raw, "explicit"
    if prop in inherited:
        raw = inherited[prop]
        if raw.strip().lower() in CSS_WIDE_KEYWORDS:
            return resolve_keyword(raw, "inherited")
        return raw, "inherited"
    return SVG_INITIAL.get(prop, ""), "initial"


def collect_element(
    el: ET.Element,
    inherited: dict[str, str],
    record: IconRecord,
) -> None:
    """Recursively walk an element, recording observations and resolving paint."""
    name = local_name(el.tag)
    record.element_counts[name] = record.element_counts.get(name, 0) + 1

    # Flatten attributes with readable names.
    attrs: dict[str, str] = {}
    for raw_key, raw_val in el.attrib.items():
        attrs[strip_attr_ns(raw_key)] = raw_val
    record.elements.append(ElementObservation(name=name, attributes=dict(attrs)))

    # Unevaluated CSS / references: <style> sheets, class selectors, <use>
    # references. Their mere presence means some paint/geometry may be decided
    # by CSS/refs this tool does not evaluate; force a review, never a pass.
    if name in UNEVALUATED_ELEMENTS:
        text = (el.text or "").strip()
        detail = f"<{name}>" + (f": {text[:60]}" if text else "")
        record.unevaluated_refs.append(detail)
    if "class" in attrs:
        record.unevaluated_refs.append(f"{name}[class={attrs['class']!r}]")

    # Inline style parsing.
    own_props: dict[str, str] = {}
    if "style" in attrs:
        record.inline_style_present = True
        decls, unresolved = parse_inline_style(attrs["style"])
        own_props.update(decls)
        for u in unresolved:
            record.unresolved_css.append(f"{name}: {u}")

    # Presentation attributes: an explicit presentation attribute is only used
    # if the same property was not already set via inline style (style wins).
    for p in INHERITED_PAINT:
        if p in attrs and p not in own_props:
            own_props[p] = attrs[p]

    # Explicit stroke-width on ANY element (D2): record it with element context
    # so an inherited <g stroke-width=...> is not missed.
    if "stroke-width" in own_props:
        record.explicit_stroke_widths.append(f"{name}={own_props['stroke-width']}")

    # ARIA / role / metadata flags.
    if name == "title":
        record.has_title = True
    if name == "desc":
        record.has_desc = True
    if name == "metadata":
        record.has_metadata = True
    if "role" in attrs and record.role is None:
        record.role = attrs["role"]
    for key, val in attrs.items():
        if key.startswith("aria-"):
            record.aria_attributes[key] = val

    # Structure flags.
    if "transform" in attrs:
        record.has_transform = True
    if "mask" in attrs or name == "mask":
        record.has_mask = True
    if "clip-path" in attrs or name == "clipPath":
        record.has_clip = True
    if name == "defs":
        record.has_defs = True
    href = attrs.get("href") or attrs.get("xlink:href")
    if name == "image" or (href and (RASTER_HREF_RE.search(href) or DATA_RASTER_RE.match(href))):
        record.has_raster = True
    if href and name == "use":
        record.unevaluated_refs.append(f"use[href={href!r}]")

    # Compute the inherited context passed to children.
    child_inherited = dict(inherited)
    for p in INHERITED_PAINT:
        if p in own_props:
            child_inherited[p] = own_props[p]

    # Paint analysis for drawable, paint-bearing elements.
    if name == "path":
        record.path_count += 1
        stroke_val, stroke_src = resolve_property("stroke", own_props, inherited)
        fill_val, fill_src = resolve_property("fill", own_props, inherited)
        width_val, width_src = resolve_property("stroke-width", own_props, inherited)
        cap_val, cap_src = resolve_property("stroke-linecap", own_props, inherited)
        join_val, join_src = resolve_property("stroke-linejoin", own_props, inherited)

        record.stroke_values.append(stroke_val)
        record.effective_strokes.append(stroke_val)
        record.fill_values.append(fill_val)
        record.effective_fills.append(fill_val)
        record.stroke_widths.append(width_val)
        record.linecaps.append(cap_val)
        record.linejoins.append(join_val)

        # Literal fill attribute present in the source on this path (D2):
        # distinct from the effective fill model. The guide says fill is
        # omitted on paths, so a literal fill="..." (even "none") is a
        # syntax-level deviation worth recording.
        literal_fill = None
        if "fill" in attrs:
            literal_fill = attrs["fill"]
        elif "fill" in own_props and "style" in attrs:
            literal_fill = own_props["fill"]
        if literal_fill is not None:
            record.paths_with_literal_fill.append(literal_fill)

        for paint_val in (stroke_val, fill_val):
            record.hardcoded_colors.extend(is_hardcoded_color(paint_val))

        record.paths.append(
            {
                "d": attrs.get("d", ""),
                "stroke": {"value": stroke_val, "source": stroke_src},
                "fill": {"value": fill_val, "source": fill_src},
                "fill_literal": literal_fill,
                "stroke_width": {"value": width_val, "source": width_src},
                "stroke_linecap": {"value": cap_val, "source": cap_src},
                "stroke_linejoin": {"value": join_val, "source": join_src},
                "fill_rule": attrs.get("fill-rule"),
                "clip_rule": attrs.get("clip-rule"),
            }
        )

    if name == "g":
        record.group_count += 1

    # Any hardcoded color on any paint attribute, anywhere (incl. rect, g, svg).
    for p in PAINT_ATTRS:
        if p in attrs:
            record.hardcoded_colors.extend(is_hardcoded_color(attrs[p]))

    for child in list(el):
        # Skip comment/PI pseudo-elements that ET may surface as callables.
        if not isinstance(child.tag, str):
            continue
        collect_element(child, child_inherited, record)


def canonical_name(source_path: str) -> str:
    """Canonical icon name: the repository-relative source path with the .svg
    extension stripped from the leaf, forward-slash separated."""
    rel = source_path.replace(os.sep, "/")
    if rel.endswith(".svg"):
        rel = rel[: -len(".svg")]
    # The canonical NAME is the leaf (stable icon identifier); the full
    # repository path is retained separately as source_path.
    return rel.rsplit("/", 1)[-1]


def discover_svgs(source_root: str) -> list[str]:
    """Return a deterministically sorted list of in-scope SVG files.

    In-scope == every ``*.svg`` directly under the source icons directory.
    Generated copies (e.g. a build output directory) are excluded by only
    scanning the directory the caller points at; callers must point --source at
    the owned input directory, never at generated output.
    """
    results: list[str] = []
    for entry in os.scandir(source_root):
        if entry.is_file() and entry.name.lower().endswith(".svg"):
            results.append(entry.path)
    results.sort(key=lambda p: os.path.basename(p))
    return results


def audit_icon(path: str, source_root: str, source_label: str) -> IconRecord:
    """Audit a single SVG.

    ``path`` is the on-disk path (may be absolute). ``source_root`` is the
    on-disk root used to compute the leaf. ``source_label`` is the stable,
    repository-relative label (e.g. ``src/assets/icons``) used to build the
    deterministic ``source_path`` reported in the output, so that the same
    input bytes yield identical artifacts regardless of run location (D5).
    """
    with open(path, "rb") as fh:
        raw = fh.read()
    sha = hashlib.sha256(raw).hexdigest()
    leaf = os.path.basename(path).replace(os.sep, "/")
    source_path = f"{source_label.rstrip('/')}/{leaf}"
    record = IconRecord(
        name=canonical_name(leaf),
        path=leaf,
        source_path=source_path,
        sha256=sha,
        bytes=len(raw),
    )
    try:
        root = ET.fromstring(raw)
    except ET.ParseError as exc:  # pragma: no cover - exercised via fixtures
        raise ParseError(record.path, f"XML parse error: {exc}") from exc

    if local_name(root.tag) != "svg":
        raise ParseError(record.path, f"root element is <{local_name(root.tag)}>, expected <svg>")

    record.root_namespace = namespace_uri(root.tag)
    if record.root_namespace not in (SVG_NS, None):
        raise ParseError(
            record.path,
            f"root <svg> namespace is {record.root_namespace!r}, expected {SVG_NS!r}",
        )

    root_attrs = {strip_attr_ns(k): v for k, v in root.attrib.items()}
    record.root_attributes = root_attrs
    record.width = root_attrs.get("width")
    record.height = root_attrs.get("height")
    record.viewbox = root_attrs.get("viewBox")
    record.root_fill = root_attrs.get("fill")

    # Build the paint context contributed by the root <svg> element so that
    # descendants resolve inherited/effective defaults correctly.
    root_own: dict[str, str] = {}
    if "style" in root_attrs:
        record.inline_style_present = True
        decls, unresolved = parse_inline_style(root_attrs["style"])
        for k, v in decls.items():
            if k in INHERITED_PAINT:
                root_own[k] = v
        for u in unresolved:
            record.unresolved_css.append(f"svg: {u}")
    for p in INHERITED_PAINT:
        if p in root_attrs and p not in root_own:
            root_own[p] = root_attrs[p]
    if "class" in root_attrs:
        record.unevaluated_refs.append(f"svg[class={root_attrs['class']!r}]")

    # An explicit stroke-width on the root itself is an inherited width (D2).
    if "stroke-width" in root_own:
        record.explicit_stroke_widths.append(f"svg={root_own['stroke-width']}")

    # Count the root element itself, then walk its children with the root's
    # paint context as their inherited context. A single, correct pass.
    record.element_counts["svg"] = record.element_counts.get("svg", 0) + 1
    record.elements.append(
        ElementObservation(name="svg", attributes=dict(root_attrs))
    )
    # Hardcoded colors declared directly on the root paint attributes.
    for p in PAINT_ATTRS:
        if p in root_attrs:
            record.hardcoded_colors.extend(is_hardcoded_color(root_attrs[p]))
    for child in list(root):
        if not isinstance(child.tag, str):
            continue
        collect_element(child, root_own, record)

    return record


# ---------------------------------------------------------------------------
# Rule catalog
# ---------------------------------------------------------------------------
#
# Each rule is evaluated per-icon and produces exactly one status row per icon
# per rule. Statuses are mutually exclusive:
#
#   pass                   -> observed value matches the source-backed expectation
#   documented-exception   -> deviates, but a source explicitly documents the case
#   inconsistent           -> deviates from the documented/observed expectation
#                             with no documented exception (a convention conflict,
#                             not a governance violation, because the convention
#                             is not approved governance)
#   guideline-gap          -> no source defines an expectation for this attribute,
#                             so compliance cannot be asserted
#   requires-visual-review -> correctness depends on rendered geometry, runtime
#                             usage, or optical judgement that static analysis
#                             cannot decide
#
# Every rule declares `evaluation`: "automated" (decided here, deterministically)
# or "manual" (surfaced for human/visual decision; never auto-passed). Rule IDs
# are namespaced by provenance. "impl-guide"/"usage-guide" are conventions, NOT
# approved numeric governance.

RULES = [
    {
        "id": "impl-guide.canvas.viewbox",
        "provenance": "impl-guide",
        "section": "Canvas",
        "class": "hard",
        "evaluation": "automated",
        "summary": "viewBox must be '0 0 24 24'.",
    },
    {
        "id": "impl-guide.canvas.dimensions",
        "provenance": "impl-guide",
        "section": "Canvas",
        "class": "hard",
        "evaluation": "automated",
        "summary": "width and height must both be '24'.",
    },
    {
        "id": "impl-guide.canvas.root-fill-none",
        "provenance": "impl-guide",
        "section": "Canvas",
        "class": "hard",
        "evaluation": "automated",
        "summary": "root <svg> fill must be 'none'.",
    },
    {
        "id": "impl-guide.stroke.cap-round",
        "provenance": "impl-guide",
        "section": "Stroke rules",
        "class": "hard",
        "evaluation": "automated",
        "summary": "every path effective stroke-linecap must be 'round'.",
    },
    {
        "id": "impl-guide.stroke.join-round",
        "provenance": "impl-guide",
        "section": "Stroke rules",
        "class": "hard",
        "evaluation": "automated",
        "summary": "every path effective stroke-linejoin must be 'round'.",
    },
    {
        "id": "impl-guide.stroke.width-default",
        "provenance": "impl-guide",
        "section": "Stroke rules",
        "class": "hard",
        "evaluation": "automated",
        "summary": "stroke-width must never be set explicitly on any element "
        "(SVG default 1); inherited widths count.",
    },
    {
        "id": "impl-guide.fill.no-fill-on-path",
        "provenance": "impl-guide",
        "section": "Stroke rules",
        "class": "hard",
        "evaluation": "automated",
        "summary": "the fill attribute is omitted on every path (guide: 'Never "
        "use fill on any path'); a literal fill attribute, even fill='none', is "
        "a syntax-level deviation.",
    },
    {
        "id": "impl-guide.stroke.color",
        "provenance": "impl-guide",
        "section": "Stroke rules",
        "class": "hard",
        "evaluation": "automated",
        "summary": "the implementation guide documents stroke '#9747FF' on every "
        "path; '#9747FF' passes, any other concrete color is inconsistent with "
        "the guide (convention conflict, not a production defect).",
    },
    {
        "id": "usage-guide.color.mask-applicability",
        "provenance": "usage-guide",
        "section": "Behaviors / Color",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "whether the runtime CSS mask + currentColor technique "
        "neutralizes a hardcoded asset color is a DIFFERENT SCOPE (component "
        "usage) that is not tested by this asset-level audit.",
    },
    {
        "id": "impl-guide.structure.no-raster",
        "provenance": "impl-guide",
        "section": "Canvas / composition",
        "class": "hard",
        "evaluation": "automated",
        "summary": "icons must be vector only; no raster image content.",
    },
    {
        "id": "impl-guide.structure.transform",
        "provenance": "impl-guide",
        "section": "Composition rules",
        "class": "heuristic",
        "evaluation": "manual",
        "summary": "the guide describes direct path geometry; transforms are not "
        "documented and are surfaced for review.",
    },
    {
        "id": "impl-guide.structure.mask-clip-defs",
        "provenance": "impl-guide",
        "section": "Canvas / composition",
        "class": "heuristic",
        "evaluation": "manual",
        "summary": "masks/clip-paths/defs are undocumented structural variants "
        "(export artifacts); their presence is surfaced for review rather than "
        "passed as whole-structure compliance.",
    },
    {
        "id": "impl-guide.path-order",
        "provenance": "impl-guide",
        "section": "Composition rules",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "keyshape-first path ordering is described but the guide's own "
        "examples contradict it; ordering cannot be auto-verified.",
    },
    {
        "id": "impl-guide.naming.kebab-case",
        "provenance": "impl-guide",
        "section": "Naming conventions",
        "class": "hard",
        "evaluation": "automated",
        "summary": "file name is lowercase kebab-case matching "
        "<object>[-variant][-modifier] (lexical syntax only).",
    },
    {
        "id": "impl-guide.naming.double-dash-semantics",
        "provenance": "impl-guide",
        "section": "Naming conventions (Special: double-dash)",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "the guide reserves '--' for dual-state icons (thumbs-up--down); "
        "whether a given '--' name is dual-state or an overloaded directional use "
        "is a semantic decision, not a lexical pass.",
    },
    {
        "id": "css.unevaluated-references",
        "provenance": "impl-guide",
        "section": "Composition rules",
        "class": "heuristic",
        "evaluation": "automated",
        "summary": "presence of <style> sheets, class selectors, <use> or other "
        "references this tool does not evaluate forces a review row; never a "
        "false pass.",
    },
    {
        "id": "usage-guide.a11y.metadata",
        "provenance": "usage-guide",
        "section": "Accessibility",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "accessibility (aria-hidden/aria-label) is applied by the "
        "consuming component, not the asset; asset-level a11y metadata is a gap.",
    },
    {
        "id": "impl-guide.safe-area",
        "provenance": "impl-guide",
        "section": "Keyshapes",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "inner-symbol safe-area insets depend on rendered geometry.",
    },
    {
        "id": "impl-guide.optical-correction",
        "provenance": "impl-guide",
        "section": "Composition rules",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "optical alignment/correction requires visual review.",
    },
    {
        "id": "usage-guide.rtl",
        "provenance": "usage-guide",
        "section": "Behaviors",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "directional/RTL mirroring behavior is undocumented for assets.",
    },
    {
        "id": "impl-guide.corner-radius",
        "provenance": "impl-guide",
        "section": "Keyshapes (Square)",
        "class": "judgment",
        "evaluation": "manual",
        "summary": "corner radius / internal spacing is geometry-dependent.",
    },
]

# Lexical kebab-case: lowercase letters, digits, single hyphens, with an
# optional single double-dash segment. This is a SYNTAX check only; the
# semantic meaning of '--' is judged separately (impl-guide.naming.double-dash).
KEBAB_RE = re.compile(r"^[a-z0-9]+(?:-{1,2}[a-z0-9]+)*$")

# The only '--' name the guide explicitly documents as a legitimate dual-state
# icon. Every other '--' name is a semantic decision (not an auto pass).
DOCUMENTED_DUAL_STATE = {"thumbs-up--down"}


def _row(rule_id: str, status: str, detail: str) -> dict[str, str]:
    return {"rule": rule_id, "status": status, "detail": detail}


def evaluate_icon(record: IconRecord) -> list[dict[str, str]]:
    """Return one findings row per rule for a single icon."""
    rows: list[dict[str, str]] = []

    # Canvas: viewBox.
    if record.viewbox == "0 0 24 24":
        rows.append(_row("impl-guide.canvas.viewbox", "pass", "viewBox 0 0 24 24"))
    else:
        rows.append(
            _row("impl-guide.canvas.viewbox", "inconsistent", f"viewBox={record.viewbox!r}")
        )

    # Canvas: dimensions.
    if record.width == "24" and record.height == "24":
        rows.append(_row("impl-guide.canvas.dimensions", "pass", "24x24"))
    else:
        rows.append(
            _row(
                "impl-guide.canvas.dimensions",
                "inconsistent",
                f"width={record.width!r} height={record.height!r}",
            )
        )

    # Canvas: root fill none.
    if (record.root_fill or "").lower() == "none":
        rows.append(_row("impl-guide.canvas.root-fill-none", "pass", "fill=none"))
    else:
        rows.append(
            _row(
                "impl-guide.canvas.root-fill-none",
                "inconsistent",
                f"root fill={record.root_fill!r}",
            )
        )

    # Stroke caps (effective values across all paths).
    caps = sorted(set(record.linecaps))
    if caps == ["round"]:
        rows.append(_row("impl-guide.stroke.cap-round", "pass", "all round"))
    elif not caps:
        rows.append(_row("impl-guide.stroke.cap-round", "guideline-gap", "no path strokes"))
    else:
        rows.append(_row("impl-guide.stroke.cap-round", "inconsistent", f"caps={caps}"))

    # Stroke joins (effective values across all paths).
    joins = sorted(set(record.linejoins))
    if joins == ["round"]:
        rows.append(_row("impl-guide.stroke.join-round", "pass", "all round"))
    elif not joins:
        rows.append(_row("impl-guide.stroke.join-round", "guideline-gap", "no path strokes"))
    else:
        rows.append(_row("impl-guide.stroke.join-round", "inconsistent", f"joins={joins}"))

    # Stroke width default: no explicit stroke-width on ANY element, AND no path
    # whose effective width came from an explicit source (catches inherited
    # widths from a <g>, D2).
    explicit_any = sorted(set(record.explicit_stroke_widths))
    effective_non_default = sorted(
        {
            f"{p['stroke_width']['value']}({p['stroke_width']['source']})"
            for p in record.paths
            if p["stroke_width"]["source"] != "initial"
        }
    )
    if not explicit_any and not effective_non_default:
        rows.append(_row("impl-guide.stroke.width-default", "pass", "no explicit width (default 1)"))
    else:
        detail_parts = []
        if explicit_any:
            detail_parts.append(f"explicit on elements={explicit_any}")
        if effective_non_default:
            detail_parts.append(f"path effective widths={effective_non_default}")
        rows.append(
            _row("impl-guide.stroke.width-default", "inconsistent", "; ".join(detail_parts))
        )

    # No fill on path. The guide says the fill attribute is OMITTED on paths.
    # Distinguish literal-syntax (a fill attribute is present at all) from the
    # effective model (does the fill paint anything). A literal fill attribute
    # of ANY value, including "none", is a syntax-level deviation.
    literal_fills = sorted(set(record.paths_with_literal_fill))
    painted_fills = [
        p["fill"]["value"]
        for p in record.paths
        if p["fill"]["value"].lower() not in ("none",)
    ]
    if not record.paths:
        rows.append(_row("impl-guide.fill.no-fill-on-path", "guideline-gap", "no paths"))
    elif painted_fills:
        rows.append(
            _row(
                "impl-guide.fill.no-fill-on-path",
                "inconsistent",
                f"path has a painting fill value={sorted(set(painted_fills))}",
            )
        )
    elif literal_fills:
        rows.append(
            _row(
                "impl-guide.fill.no-fill-on-path",
                "inconsistent",
                f"literal fill attribute present on a path (guide omits it): "
                f"{literal_fills}",
            )
        )
    else:
        rows.append(
            _row("impl-guide.fill.no-fill-on-path", "pass", "fill attribute omitted on all paths")
        )

    # Stroke color vs the DOCUMENTED guide value #9747FF (D1). No "dominant"
    # criterion, no "placeholder/authoring" framing.
    strokes = sorted(set(s.lower() for s in record.effective_strokes))
    concrete = [s for s in strokes if s not in ("none", "currentcolor") and not s.startswith("url(")]
    if not record.paths:
        rows.append(_row("impl-guide.stroke.color", "guideline-gap", "no paths"))
    elif not concrete:
        rows.append(
            _row(
                "impl-guide.stroke.color",
                "requires-visual-review",
                f"no concrete stroke color (effective strokes={strokes}); "
                "runtime paint not tested",
            )
        )
    elif concrete == [DOCUMENTED_STROKE]:
        rows.append(
            _row("impl-guide.stroke.color", "pass", "stroke #9747FF matches the implementation guide")
        )
    else:
        rows.append(
            _row(
                "impl-guide.stroke.color",
                "inconsistent",
                f"stroke colors {concrete} differ from the guide's documented "
                "#9747FF (convention conflict vs implementation guide, not a "
                "production defect)",
            )
        )

    # Mask/currentColor applicability is a different scope, not tested here.
    if record.hardcoded_colors:
        rows.append(
            _row(
                "usage-guide.color.mask-applicability",
                "requires-visual-review",
                f"asset carries hardcoded color(s) {sorted(set(record.hardcoded_colors))}; "
                "whether the component's CSS mask+currentColor neutralizes this at "
                "runtime is out of scope for this asset-level audit",
            )
        )
    else:
        rows.append(
            _row(
                "usage-guide.color.mask-applicability",
                "guideline-gap",
                "no hardcoded asset color; render-time mask applicability not evaluated",
            )
        )

    # No raster.
    if record.has_raster:
        rows.append(_row("impl-guide.structure.no-raster", "inconsistent", "raster content"))
    else:
        rows.append(_row("impl-guide.structure.no-raster", "pass", "vector only"))

    # Transform.
    if record.has_transform:
        rows.append(
            _row(
                "impl-guide.structure.transform",
                "requires-visual-review",
                "uses transform; effective geometry needs rendered review",
            )
        )
    else:
        rows.append(_row("impl-guide.structure.transform", "pass", "no transforms"))

    # Masks / clip-paths / defs: undocumented structural variants (D6). Never
    # silently passed as whole-structure compliance.
    if record.has_mask or record.has_clip or record.has_defs:
        rows.append(
            _row(
                "impl-guide.structure.mask-clip-defs",
                "requires-visual-review",
                f"mask={record.has_mask} clip={record.has_clip} defs={record.has_defs}; "
                "undocumented structural variant, review clipping/mask effect",
            )
        )
    else:
        rows.append(
            _row("impl-guide.structure.mask-clip-defs", "pass", "no mask/clip/defs")
        )

    # Path ordering: guide self-contradicts; never auto-passed.
    rows.append(
        _row(
            "impl-guide.path-order",
            "requires-visual-review",
            "path ordering convention is self-contradictory in the guide; "
            f"{record.path_count} path(s), {record.group_count} group(s)",
        )
    )

    # Naming: lexical kebab-case syntax ONLY (D4).
    leaf = record.name.rsplit("/", 1)[-1]
    if not KEBAB_RE.match(leaf):
        rows.append(
            _row("impl-guide.naming.kebab-case", "inconsistent", f"name {leaf!r} is not kebab-case")
        )
    else:
        rows.append(_row("impl-guide.naming.kebab-case", "pass", f"name {leaf!r} is kebab-case"))

    # Naming: double-dash SEMANTICS, separate from lexical syntax (D4).
    dd = leaf.count("--")
    if dd == 0:
        rows.append(
            _row("impl-guide.naming.double-dash-semantics", "pass", "no '--' segment")
        )
    elif dd == 1 and leaf in DOCUMENTED_DUAL_STATE:
        rows.append(
            _row(
                "impl-guide.naming.double-dash-semantics",
                "documented-exception",
                f"{leaf!r} is the guide's documented dual-state '--' icon",
            )
        )
    else:
        rows.append(
            _row(
                "impl-guide.naming.double-dash-semantics",
                "requires-visual-review",
                f"{leaf!r} uses '--' but the guide reserves '--' for dual-state "
                "icons; this appears to be an overloaded directional/other use "
                "needing a semantic decision",
            )
        )

    # Unevaluated CSS / references (D3): no false pass when present.
    refs = sorted(set(record.unevaluated_refs))
    unresolved = sorted(set(record.unresolved_css))
    if refs or unresolved:
        rows.append(
            _row(
                "css.unevaluated-references",
                "requires-visual-review",
                f"unevaluated refs={refs}; unresolved inline styles={unresolved}",
            )
        )
    else:
        rows.append(
            _row(
                "css.unevaluated-references",
                "pass",
                "no stylesheets/classes/use refs; all inline styles resolved",
            )
        )

    # Asset-level accessibility metadata gap.
    a11y_detail = "no asset-level title/desc/aria"
    if record.has_title or record.has_desc or record.aria_attributes or record.role:
        a11y_detail = (
            f"title={record.has_title} desc={record.has_desc} "
            f"role={record.role!r} aria={sorted(record.aria_attributes)}"
        )
    rows.append(_row("usage-guide.a11y.metadata", "guideline-gap", a11y_detail))

    # Judgment / geometry-dependent rules: always review.
    rows.append(
        _row(
            "impl-guide.safe-area",
            "requires-visual-review",
            "inner-symbol inset depends on rendered geometry",
        )
    )
    rows.append(
        _row(
            "impl-guide.optical-correction",
            "requires-visual-review",
            "optical alignment requires visual judgement",
        )
    )
    rows.append(
        _row(
            "usage-guide.rtl",
            "guideline-gap",
            "no documented RTL/mirroring expectation for assets",
        )
    )
    rows.append(
        _row(
            "impl-guide.corner-radius",
            "requires-visual-review",
            "corner radius / internal spacing is geometry-dependent",
        )
    )

    return rows


def compute_stroke_distribution(records: list[IconRecord]) -> dict[str, int]:
    """Return the observed concrete-stroke-color distribution across the set.

    This is a NON-NORMATIVE observed statistic reported alongside (never in
    place of) the deterministic comparison to the documented #9747FF.
    """
    counts: dict[str, int] = {}
    for rec in records:
        for s in rec.effective_strokes:
            low = s.lower()
            if low in ("none", "currentcolor", "") or low.startswith("url("):
                continue
            counts[low] = counts.get(low, 0) + 1
    return counts


# ---------------------------------------------------------------------------
# Duplicate / overlap detection
# ---------------------------------------------------------------------------


def _structural_signature(record: IconRecord) -> str:
    """A normalized geometry signature: the ordered list of path 'd' values plus
    element-count shape. Deliberately independent of file name and stroke color
    so it surfaces structurally identical icons under different names. This is a
    CANDIDATE signature, not a claim of rendered-visual equivalence."""
    path_ds = [p["d"].strip() for p in record.paths]
    payload = {
        "paths": path_ds,
        "element_counts": record.element_counts,
    }
    return json.dumps(payload, sort_keys=True, separators=(",", ":"))


def _normalized_path_set(record: IconRecord) -> frozenset[str]:
    """Order-independent set of path 'd' values, for structural-equivalence
    candidates that differ only in path ordering."""
    return frozenset(p["d"].strip() for p in record.paths)


def detect_duplicates(records: list[IconRecord]) -> dict[str, Any]:
    """Detect duplicate CANDIDATE signatures at three clearly separated levels.

    * exact_byte        -> identical SHA256 (certain duplicate bytes)
    * structural        -> identical normalized geometry signature (same paths
                           in the same order and same element shape), different
                           bytes (e.g. only stroke color differs)
    * order_independent -> identical set of path 'd' values regardless of order
    * semantic_overlap  -> shared leading name token (heuristic only)

    None of these asserts rendered-visual equivalence, which this static tool
    does not decide (see report).
    """
    by_sha: dict[str, list[str]] = {}
    by_sig: dict[str, list[str]] = {}
    by_pathset: dict[frozenset[str], list[str]] = {}
    for rec in records:
        by_sha.setdefault(rec.sha256, []).append(rec.name)
        by_sig.setdefault(_structural_signature(rec), []).append(rec.name)
        by_pathset.setdefault(_normalized_path_set(rec), []).append(rec.name)

    exact = sorted([sorted(names) for names in by_sha.values() if len(names) > 1])
    structural = sorted([sorted(names) for names in by_sig.values() if len(names) > 1])
    order_independent = sorted(
        [sorted(names) for names in by_pathset.values() if len(names) > 1]
    )

    by_token: dict[str, list[str]] = {}
    for rec in records:
        leaf = rec.name.rsplit("/", 1)[-1]
        token = re.split(r"-{1,2}", leaf)[0]
        by_token.setdefault(token, []).append(rec.name)
    semantic = sorted(
        [
            {"token": token, "icons": sorted(names)}
            for token, names in by_token.items()
            if len(names) > 1
        ],
        key=lambda d: d["token"],
    )

    return {
        "note": "All groups below are CANDIDATE signatures, not assertions of "
        "rendered-visual equivalence. exact_byte is certain duplicate bytes; the "
        "rest require human confirmation.",
        "exact_byte": exact,
        "structural": structural,
        "order_independent_candidates": order_independent,
        "semantic_overlap_candidates": semantic,
        "visual_equivalence": "not decided by static analysis; requires rendered "
        "comparison (see report).",
    }


# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------


def build_summary(
    records: list[IconRecord],
    findings: list[dict[str, Any]],
    duplicates: dict[str, Any],
    stroke_distribution: dict[str, int],
    provenance: dict[str, str],
) -> dict[str, Any]:
    status_values = (
        "pass",
        "documented-exception",
        "inconsistent",
        "guideline-gap",
        "requires-visual-review",
    )

    row_status_counts: dict[str, int] = {s: 0 for s in status_values}
    affected_icons: dict[str, set[str]] = {s: set() for s in status_values}
    per_rule: dict[str, dict[str, int]] = {}

    for entry in findings:
        icon = entry["icon"]
        for row in entry["rows"]:
            status = row["status"]
            rule = row["rule"]
            row_status_counts[status] = row_status_counts.get(status, 0) + 1
            affected_icons.setdefault(status, set()).add(icon)
            per_rule.setdefault(rule, {s: 0 for s in status_values})
            per_rule[rule][status] += 1

    affected_counts = {s: len(icons) for s, icons in affected_icons.items()}

    return {
        "provenance": provenance,
        "counts": {
            "icons_total": len(records),
            "rules_total": len(RULES),
            "finding_rows_total": sum(row_status_counts.values()),
            "row_status_totals": row_status_counts,
            "affected_icon_totals": affected_counts,
            "per_rule": per_rule,
        },
        "observed": {
            "documented_stroke_color": DOCUMENTED_STROKE,
            "stroke_color_distribution": dict(
                sorted(stroke_distribution.items(), key=lambda kv: (-kv[1], kv[0]))
            ),
            "observed_distribution_note": "Observed distribution is NON-NORMATIVE. "
            "The pass criterion for impl-guide.stroke.color is the guide's "
            "documented #9747FF, not the most frequent observed color.",
        },
        "duplicates": {
            "exact_byte_groups": len(duplicates["exact_byte"]),
            "structural_groups": len(duplicates["structural"]),
            "order_independent_groups": len(duplicates["order_independent_candidates"]),
            "semantic_overlap_groups": len(duplicates["semantic_overlap_candidates"]),
        },
        "notes": [
            "Row totals count (icon, rule) pairs; affected-icon totals count "
            "distinct icons with at least one row of that status.",
            "No status asserts approved governance compliance; impl-guide and "
            "usage-guide are conventions, not canonical numeric governance.",
            "impl-guide.stroke.color compares against the guide's documented "
            "#9747FF; the observed color distribution is reported separately "
            "with no normative force.",
            "requires-visual-review, manual-evaluation and judgment-class rules "
            "are never auto-passed.",
            "Duplicate groups are candidate signatures, not rendered-visual "
            "equivalence.",
        ],
    }


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def write_json(path: str, data: Any) -> None:
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(data, fh, indent=2, sort_keys=True, ensure_ascii=False)
        fh.write("\n")


def _is_within(child: str, parent: str) -> bool:
    """Return True if ``child`` is equal to or nested inside ``parent``."""
    child_abs = os.path.abspath(child)
    parent_abs = os.path.abspath(parent)
    try:
        common = os.path.commonpath([child_abs, parent_abs])
    except ValueError:
        return False
    return common == parent_abs


def run_audit(
    source: str,
    output: str,
    provenance: dict[str, str],
    source_label: str = "src/assets/icons",
) -> dict[str, Any]:
    """Run the full audit. Returns the summary dict. Raises ParseError on any
    unparseable icon (never silently omits).

    ``source_label`` is the stable, repository-relative label recorded in the
    output so artifacts are byte-identical regardless of on-disk location (D5).
    """
    source = os.path.abspath(source)
    output = os.path.abspath(output)

    if not os.path.isdir(source):
        raise SystemExit(f"--source is not a directory: {source}")

    # Protect source immutability: the output must never be the source or live
    # inside it, which could let generated JSON pollute the audited input (D5).
    if _is_within(output, source):
        raise SystemExit(
            "refusing to write output inside or equal to the source directory: "
            f"source={source} output={output}"
        )

    svg_paths = discover_svgs(source)
    if not svg_paths:
        # Fail an empty source rather than silently emitting a success with zero
        # icons, which would be a false pass (D5).
        raise SystemExit(f"no .svg files found under --source {source}; refusing empty audit")

    os.makedirs(output, exist_ok=True)

    records = [audit_icon(p, source, source_label) for p in svg_paths]
    records.sort(key=lambda r: r.name)

    stroke_distribution = compute_stroke_distribution(records)

    findings = [{"icon": rec.name, "rows": evaluate_icon(rec)} for rec in records]
    findings.sort(key=lambda f: f["icon"])

    duplicates = detect_duplicates(records)
    summary = build_summary(records, findings, duplicates, stroke_distribution, provenance)

    inventory = {
        "provenance": provenance,
        "source_root": source_label,
        "icon_count": len(records),
        "icons": [rec.to_json() for rec in records],
    }
    findings_doc = {
        "provenance": provenance,
        "rules": RULES,
        "duplicates": duplicates,
        "findings": findings,
    }

    write_json(os.path.join(output, "inventory.json"), inventory)
    write_json(os.path.join(output, "findings.json"), findings_doc)
    write_json(os.path.join(output, "summary.json"), summary)
    return summary


def parse_provenance(pairs: list[str]) -> dict[str, str]:
    """Parse --provenance key=value pairs into a dict for pinned, deterministic
    provenance. Never read from the clock or environment."""
    result: dict[str, str] = {}
    for item in pairs:
        if "=" not in item:
            raise SystemExit(f"invalid --provenance value (expected key=value): {item!r}")
        key, value = item.split("=", 1)
        result[key.strip()] = value.strip()
    return result


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Audit the UI Foundations SVG icon set (stdlib only, "
        "deterministic, read-only aside from the output directory)."
    )
    parser.add_argument(
        "--source",
        required=True,
        help="Path to the owned icon input directory (src/assets/icons).",
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Directory to write inventory.json, findings.json, summary.json. "
        "Must not be the source directory or inside it.",
    )
    parser.add_argument(
        "--source-label",
        default="src/assets/icons",
        help="Stable repository-relative label recorded as source_root and the "
        "prefix of each icon's source_path (default: src/assets/icons). Keeps "
        "artifacts byte-identical across run locations.",
    )
    parser.add_argument(
        "--provenance",
        action="append",
        default=[],
        metavar="KEY=VALUE",
        help="Pinned provenance key=value (repeatable). e.g. "
        "runtime-commit=..., vault-base=..., issue=...",
    )
    args = parser.parse_args(argv)

    provenance = parse_provenance(args.provenance)
    try:
        summary = run_audit(args.source, args.output, provenance, args.source_label)
    except ParseError as exc:
        print(f"PARSE FAILURE: {exc}", file=sys.stderr)
        return 2

    counts = summary["counts"]
    print(
        "audited {icons} icons, {rows} finding rows".format(
            icons=counts["icons_total"], rows=counts["finding_rows_total"]
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
```

## Complete source: `test_audit_icons.py`

```python
#!/usr/bin/env python3
"""Tests for audit_icons.py (stdlib unittest only).

These fixtures are synthetic SVGs written to a temp directory. They exercise:

* inheritance of paint from ancestors (stroke/fill/width via <g>),
* inline style resolution, CSS-wide keyword resolution, and unresolved CSS,
* unevaluated references (<style>, class, <use>) forcing a review row,
* effective SVG defaults when nothing is specified (bare canvas),
* named-color hardcoding and clip-path <rect fill="white"> handling,
* parse failures (malformed XML, non-svg root, wrong namespace) FAILING the run
  rather than omitting icons,
* exact-byte, structural and order-independent duplicate candidates,
* rule failures producing the correct mutually-exclusive statuses,
* color compared to the documented #9747FF (not a 'dominant' value),
* inherited stroke-width being caught (not only source=explicit on a path),
* lexical naming vs double-dash semantic judgement,
* reproducibility: identical artifacts regardless of output depth, empty-source
  failure, and refusal to write output inside the source directory.

Run (from the tools/ directory, with bytecode writing disabled so no __pycache__
is produced):

    PYTHONDONTWRITEBYTECODE=1 python3 -m unittest test_audit_icons -v
"""

from __future__ import annotations

import json
import os
import tempfile
import unittest

import audit_icons as A


CANVAS = '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
# A minimal root WITHOUT a fill, so paint resolves to SVG initial values.
BARE_CANVAS = '<svg xmlns="http://www.w3.org/2000/svg">'


def svg(body: str, open_tag: str = CANVAS) -> str:
    return f"{open_tag}\n{body}\n</svg>\n"


def load_json(path: str):
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


class TempIcons:
    """Context manager that writes name->content SVGs into a temp source dir."""

    def __init__(self, files: dict[str, str], out_subdir: str = "out"):
        self.files = files
        self.out_subdir = out_subdir

    def __enter__(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.source = os.path.join(self.tmp.name, "icons")
        self.output = os.path.join(self.tmp.name, self.out_subdir)
        os.makedirs(self.source)
        for name, content in self.files.items():
            with open(os.path.join(self.source, name), "w", encoding="utf-8") as fh:
                fh.write(content)
        return self

    def __exit__(self, *exc):
        self.tmp.cleanup()
        return False


PROV = {"issue": "45", "runtime-commit": "aa153b7", "vault-base": "995c580"}


def find_rows(findings, icon):
    for entry in findings:
        if entry["icon"] == icon:
            return {r["rule"]: r for r in entry["rows"]}
    raise AssertionError(f"icon {icon} not in findings")


def _single(name, content):
    with TempIcons({name: content}) as t:
        A.run_audit(t.source, t.output, PROV)
        f = load_json(os.path.join(t.output, "findings.json"))
    return find_rows(f["findings"], name[: -len(".svg")])


class InheritanceTest(unittest.TestCase):
    def test_stroke_inherited_from_group(self):
        files = {
            "inherit.svg": svg(
                '<g stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round">'
                '<path d="M1 1L2 2"/></g>'
            )
        }
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
        path = inv["icons"][0]["paths"][0]
        self.assertEqual(path["stroke"]["value"], "#9747FF")
        self.assertEqual(path["stroke"]["source"], "inherited")
        self.assertEqual(path["stroke_linecap"]["value"], "round")
        self.assertEqual(path["stroke_linecap"]["source"], "inherited")

    def test_svg_defaults_when_unspecified(self):
        # A bare canvas with NO fill on the root and a bare path: stroke defaults
        # to none, fill to black, width to 1, cap butt, join miter (SVG initial
        # values). The previous fixture incorrectly used a root fill="none",
        # which made fill resolve to inherited 'none', not the initial 'black'.
        files = {"bare.svg": svg('<path d="M1 1L2 2"/>', BARE_CANVAS)}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
        path = inv["icons"][0]["paths"][0]
        self.assertEqual((path["stroke"]["value"], path["stroke"]["source"]), ("none", "initial"))
        self.assertEqual((path["fill"]["value"], path["fill"]["source"]), ("black", "initial"))
        self.assertEqual(path["stroke_width"]["value"], "1")
        self.assertEqual(path["stroke_width"]["source"], "initial")
        self.assertEqual(path["stroke_linecap"]["value"], "butt")
        self.assertEqual(path["stroke_linejoin"]["value"], "miter")

    def test_inline_style_resolution_and_unresolved(self):
        files = {
            "styled.svg": svg(
                '<path style="stroke:#9747FF;stroke-linecap:round;'
                'stroke-linejoin:round;--custom:bad;fill:var(--x)" d="M1 1L2 2"/>'
            )
        }
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
        icon = inv["icons"][0]
        path = icon["paths"][0]
        self.assertEqual(path["stroke"]["value"], "#9747FF")
        self.assertEqual(path["stroke"]["source"], "explicit")
        self.assertTrue(icon["css"]["inline_style_present"])
        joined = " ".join(icon["css"]["unresolved"])
        self.assertIn("--custom:bad", joined)
        self.assertIn("fill:var(--x)", joined)

    def test_css_wide_keyword_inherit_resolved(self):
        # stroke:inherit on a path inside a group that sets a concrete stroke
        # resolves to the inherited value, and the source records the keyword.
        files = {
            "kw.svg": svg(
                '<g stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round">'
                '<path d="M1 1" style="stroke:inherit"/></g>'
            )
        }
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
        path = inv["icons"][0]["paths"][0]
        self.assertEqual(path["stroke"]["value"], "#9747FF")
        self.assertEqual(path["stroke"]["source"], "explicit:inherit")

    def test_css_wide_keyword_initial_resolved(self):
        files = {"kw.svg": svg('<path d="M1 1" style="stroke:initial"/>', BARE_CANVAS)}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
        path = inv["icons"][0]["paths"][0]
        # stroke initial is 'none'; never emitted as the bare keyword 'initial'.
        self.assertEqual(path["stroke"]["value"], "none")
        self.assertEqual(path["stroke"]["source"], "explicit:initial")


class CssReferenceTest(unittest.TestCase):
    def test_style_sheet_forces_review(self):
        files = {
            "s.svg": svg(
                '<style>.a{stroke:#9747FF}</style><path class="a" d="M1 1"/>'
            )
        }
        rows = _single("s.svg", files["s.svg"])
        self.assertEqual(rows["css.unevaluated-references"]["status"], "requires-visual-review")

    def test_class_reference_forces_review(self):
        rows = _single("c.svg", svg('<path class="icon" d="M1 1"/>'))
        self.assertEqual(rows["css.unevaluated-references"]["status"], "requires-visual-review")

    def test_use_reference_forces_review(self):
        rows = _single("u.svg", svg('<use href="#x"/>'))
        self.assertEqual(rows["css.unevaluated-references"]["status"], "requires-visual-review")

    def test_named_color_counted_as_hardcoded(self):
        # A named color on a paint attribute is a hardcoded color, so the
        # mask-applicability row must flag review (not guideline-gap).
        with TempIcons({"n.svg": svg('<path d="M1 1" stroke="red"/>')}) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
            f = load_json(os.path.join(t.output, "findings.json"))
        self.assertIn("red", inv["icons"][0]["paint"]["hardcoded_colors"])
        rows = find_rows(f["findings"], "n")
        self.assertEqual(rows["usage-guide.color.mask-applicability"]["status"], "requires-visual-review")

    def test_clip_rect_white_fill_inventoried_and_structure_review(self):
        # Mirrors the two real clipped icons: a <g clip-path> wrapping a path,
        # with <defs><clipPath><rect fill="white"/></clipPath>. The white rect
        # fill must be inventoried as a hardcoded color and the structure row
        # must require review (D3 + D6).
        content = svg(
            '<g clip-path="url(#c)" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round">'
            '<path d="M1 1"/></g>'
            '<defs><clipPath id="c"><rect width="24" height="24" fill="white"/></clipPath></defs>'
        )
        with TempIcons({"clip.svg": content}) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
            f = load_json(os.path.join(t.output, "findings.json"))
        icon = inv["icons"][0]
        self.assertIn("white", icon["paint"]["hardcoded_colors"])
        self.assertTrue(icon["structure"]["has_clip"])
        self.assertTrue(icon["structure"]["has_defs"])
        self.assertIn("rect", icon["element_counts"])
        rows = find_rows(f["findings"], "clip")
        self.assertEqual(rows["impl-guide.structure.mask-clip-defs"]["status"], "requires-visual-review")


class ParseFailureTest(unittest.TestCase):
    def test_malformed_xml_fails_run(self):
        files = {"broken.svg": "<svg><path d='M1 1'></svg"}  # unclosed
        with TempIcons(files) as t:
            with self.assertRaises(A.ParseError):
                A.run_audit(t.source, t.output, PROV)

    def test_non_svg_root_fails_run(self):
        files = {"notsvg.svg": "<html><body/></html>"}
        with TempIcons(files) as t:
            with self.assertRaises(A.ParseError):
                A.run_audit(t.source, t.output, PROV)

    def test_wrong_namespace_fails_run(self):
        files = {"ns.svg": '<svg xmlns="http://example.com/not-svg"><path d="M1 1"/></svg>'}
        with TempIcons(files) as t:
            with self.assertRaises(A.ParseError):
                A.run_audit(t.source, t.output, PROV)

    def test_parse_failure_does_not_omit_silently(self):
        files = {
            "good.svg": svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
            "broken.svg": "<svg><path",
        }
        with TempIcons(files) as t:
            with self.assertRaises(A.ParseError):
                A.run_audit(t.source, t.output, PROV)
            self.assertFalse(os.path.exists(os.path.join(t.output, "inventory.json")))


class DuplicateTest(unittest.TestCase):
    def test_exact_byte_duplicates(self):
        body = '<path d="M1 1L2 2" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'
        files = {"a.svg": svg(body), "b.svg": svg(body)}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            f = load_json(os.path.join(t.output, "findings.json"))
        self.assertIn(["a", "b"], f["duplicates"]["exact_byte"])

    def test_structural_duplicate_differs_only_by_color(self):
        a = svg('<path d="M1 1L2 2" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')
        b = svg('<path d="M1 1L2 2" stroke="#333333" stroke-linecap="round" stroke-linejoin="round"/>')
        files = {"a.svg": a, "b.svg": b}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            f = load_json(os.path.join(t.output, "findings.json"))
        dups = f["duplicates"]
        self.assertEqual(dups["exact_byte"], [])
        self.assertIn(["a", "b"], dups["structural"])

    def test_order_independent_candidate(self):
        a = svg(
            '<path d="M1 1L2 2" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'
            '<path d="M3 3L4 4" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'
        )
        b = svg(
            '<path d="M3 3L4 4" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'
            '<path d="M1 1L2 2" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'
        )
        files = {"a.svg": a, "b.svg": b}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            f = load_json(os.path.join(t.output, "findings.json"))
        dups = f["duplicates"]
        self.assertIn(["a", "b"], dups["order_independent_candidates"])
        self.assertNotIn(["a", "b"], dups["structural"])


class RuleFailureTest(unittest.TestCase):
    def test_wrong_viewbox_inconsistent(self):
        open_tag = '<svg width="24" height="24" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">'
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>', open_tag),
        )
        self.assertEqual(rows["impl-guide.canvas.viewbox"]["status"], "inconsistent")

    def test_butt_cap_inconsistent(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="butt" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.stroke.cap-round"]["status"], "inconsistent")

    def test_explicit_stroke_width_inconsistent(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.stroke.width-default"]["status"], "inconsistent")

    def test_inherited_stroke_width_inconsistent(self):
        # D2 regression: an explicit width on a <g> that a bare <path> inherits
        # must be flagged, even though the path itself has no explicit width.
        rows = _single(
            "x.svg",
            svg(
                '<g stroke-width="2" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round">'
                '<path d="M1 1"/></g>'
            ),
        )
        self.assertEqual(rows["impl-guide.stroke.width-default"]["status"], "inconsistent")

    def test_painting_fill_on_path_inconsistent(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" fill="#9747FF" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.fill.no-fill-on-path"]["status"], "inconsistent")

    def test_literal_fill_none_on_path_inconsistent(self):
        # D2 literal-syntax vs effective-model: fill="none" paints nothing, but
        # the guide says the fill attribute is OMITTED on paths, so a literal
        # fill="none" is still a syntax-level deviation.
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" fill="none" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.fill.no-fill-on-path"]["status"], "inconsistent")

    def test_omitted_fill_passes(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.fill.no-fill-on-path"]["status"], "pass")

    def test_documented_stroke_color_passes(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.stroke.color"]["status"], "pass")

    def test_other_concrete_stroke_color_inconsistent(self):
        # #333333 is NOT the documented color; it is inconsistent with the guide
        # regardless of how common it is across the set (D1: no dominant pass).
        default = svg('<path d="M1 1" stroke="#333333" stroke-linecap="round" stroke-linejoin="round"/>')
        files = {"a.svg": default, "b.svg": default, "c.svg": default}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            f = load_json(os.path.join(t.output, "findings.json"))
        rows = find_rows(f["findings"], "a")
        self.assertEqual(rows["impl-guide.stroke.color"]["status"], "inconsistent")

    def test_mask_applicability_is_review_not_exception(self):
        # A hardcoded asset color must NOT be auto-labelled a documented
        # exception; render-time mask applicability is a different scope.
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(
            rows["usage-guide.color.mask-applicability"]["status"], "requires-visual-review"
        )

    def test_no_documented_exception_for_plain_icon(self):
        # 0 documented exceptions is valid; a plain icon yields none.
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        statuses = {r["status"] for r in rows.values()}
        self.assertNotIn("documented-exception", statuses)

    def test_bad_name_inconsistent(self):
        rows = _single(
            "Bad_Name.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.naming.kebab-case"]["status"], "inconsistent")

    def test_double_dash_dual_state_is_documented_exception(self):
        # The guide's one documented dual-state name passes lexically and is a
        # documented-exception on the semantic rule (D4).
        rows = _single(
            "thumbs-up--down.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.naming.kebab-case"]["status"], "pass")
        self.assertEqual(
            rows["impl-guide.naming.double-dash-semantics"]["status"], "documented-exception"
        )

    def test_directional_double_dash_requires_review(self):
        # A single-direction '--' name is lexically valid but the '--' use is an
        # overloaded directional case, not the documented dual-state meaning, so
        # it is a semantic review, NOT an auto pass (D4).
        rows = _single(
            "arrow--left.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.naming.kebab-case"]["status"], "pass")
        self.assertEqual(
            rows["impl-guide.naming.double-dash-semantics"]["status"], "requires-visual-review"
        )

    def test_single_dash_name_no_double_dash_passes(self):
        rows = _single(
            "arrow-left-right.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.naming.double-dash-semantics"]["status"], "pass")

    def test_heavy_filename_not_auto_exempted(self):
        rows = _single(
            "plus-heavy.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="butt" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.stroke.cap-round"]["status"], "inconsistent")

    def test_path_order_always_requires_review(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.path-order"]["status"], "requires-visual-review")

    def test_mutually_exclusive_one_row_per_rule(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(len(rows), len(A.RULES))


class RasterAndStructureTest(unittest.TestCase):
    def test_raster_image_flagged(self):
        rows = _single("x.svg", svg('<image href="pic.png" width="24" height="24"/>'))
        self.assertEqual(rows["impl-guide.structure.no-raster"]["status"], "inconsistent")

    def test_transform_requires_review(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" transform="translate(1 1)" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.structure.transform"]["status"], "requires-visual-review")

    def test_no_mask_clip_defs_passes(self):
        rows = _single(
            "x.svg",
            svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>'),
        )
        self.assertEqual(rows["impl-guide.structure.mask-clip-defs"]["status"], "pass")


class ReproducibilityTest(unittest.TestCase):
    def test_identical_artifacts_across_output_depths(self):
        # D5: the same input bytes must produce byte-identical inventory/findings
        # regardless of how deep the output directory is, because source_path and
        # source_root are stable repository-relative labels, not derived from the
        # output location.
        body = svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')
        files = {"search.svg": body, "plus.svg": body.replace("M1 1", "M2 2")}

        def run(out_subdir):
            with TempIcons(files, out_subdir=out_subdir) as t:
                A.run_audit(t.source, t.output, PROV)
                blob = {}
                for fn in ("inventory.json", "findings.json", "summary.json"):
                    with open(os.path.join(t.output, fn), encoding="utf-8") as fh:
                        blob[fn] = fh.read()
                return blob

        shallow = run("out")
        deep = run(os.path.join("a", "b", "c", "deep-out"))
        self.assertEqual(shallow, deep)
        # And the recorded path is the stable repository-relative source_path.
        inv = json.loads(shallow["inventory.json"])
        self.assertEqual(inv["source_root"], "src/assets/icons")
        self.assertEqual(inv["icons"][0]["source_path"], "src/assets/icons/plus.svg")
        self.assertEqual(inv["icons"][0]["path"], "plus.svg")

    def test_identical_output_across_runs(self):
        body = svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')
        files = {
            "search.svg": body,
            "plus.svg": body.replace("M1 1", "M2 2"),
            "menu.svg": body.replace("M1 1", "M3 3"),
        }
        outputs = []
        for _ in range(2):
            with TempIcons(files) as t:
                A.run_audit(t.source, t.output, PROV)
                blob = {}
                for fn in ("inventory.json", "findings.json", "summary.json"):
                    with open(os.path.join(t.output, fn), encoding="utf-8") as fh:
                        blob[fn] = fh.read()
                outputs.append(blob)
        self.assertEqual(outputs[0], outputs[1])

    def test_empty_source_fails(self):
        # D5: an empty source directory must fail, not silently succeed.
        with tempfile.TemporaryDirectory() as tmp:
            source = os.path.join(tmp, "icons")
            output = os.path.join(tmp, "out")
            os.makedirs(source)
            with self.assertRaises(SystemExit):
                A.run_audit(source, output, PROV)

    def test_output_inside_source_rejected(self):
        # D5: refuse to write output inside the source directory (source
        # immutability / no pollution of the audited input).
        body = svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')
        with tempfile.TemporaryDirectory() as tmp:
            source = os.path.join(tmp, "icons")
            os.makedirs(source)
            with open(os.path.join(source, "a.svg"), "w", encoding="utf-8") as fh:
                fh.write(body)
            output = os.path.join(source, "generated")
            with self.assertRaises(SystemExit):
                A.run_audit(source, output, PROV)

    def test_icons_sorted(self):
        body = svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')
        files = {"zebra.svg": body, "alpha.svg": body.replace("M1 1", "M2 2")}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            inv = load_json(os.path.join(t.output, "inventory.json"))
        names = [i["name"] for i in inv["icons"]]
        self.assertEqual(names, sorted(names))


class SummaryTest(unittest.TestCase):
    def test_row_totals_vs_affected_icons_distinct(self):
        body = svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')
        files = {"a.svg": body, "b.svg": body.replace("M1 1", "M2 2")}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            summary = load_json(os.path.join(t.output, "summary.json"))
        counts = summary["counts"]
        self.assertEqual(counts["icons_total"], 2)
        self.assertEqual(counts["finding_rows_total"], 2 * len(A.RULES))
        self.assertIn("row_status_totals", counts)
        self.assertIn("affected_icon_totals", counts)
        rvr_rows = counts["row_status_totals"]["requires-visual-review"]
        rvr_icons = counts["affected_icon_totals"]["requires-visual-review"]
        self.assertGreaterEqual(rvr_rows, rvr_icons)

    def test_observed_distribution_is_non_normative(self):
        # The summary reports an observed distribution, but it is explicitly
        # separate from the documented pass criterion (D1).
        default = svg('<path d="M1 1" stroke="#333333" stroke-linecap="round" stroke-linejoin="round"/>')
        purple = svg('<path d="M2 2" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')
        files = {"a.svg": default, "b.svg": default, "p.svg": purple}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            summary = load_json(os.path.join(t.output, "summary.json"))
        observed = summary["observed"]
        self.assertEqual(observed["documented_stroke_color"], "#9747ff")
        self.assertEqual(observed["stroke_color_distribution"]["#333333"], 2)
        self.assertEqual(observed["stroke_color_distribution"]["#9747ff"], 1)
        self.assertIn("NON-NORMATIVE", observed["observed_distribution_note"])

    def test_provenance_pinned_in_outputs(self):
        files = {"a.svg": svg('<path d="M1 1" stroke="#9747FF" stroke-linecap="round" stroke-linejoin="round"/>')}
        with TempIcons(files) as t:
            A.run_audit(t.source, t.output, PROV)
            for fn in ("inventory.json", "findings.json", "summary.json"):
                doc = load_json(os.path.join(t.output, fn))
                self.assertEqual(doc["provenance"]["issue"], "45")


class RuleCatalogTest(unittest.TestCase):
    def test_every_rule_declares_class_and_evaluation(self):
        # D7: field classification (class) is separate from status, and every
        # rule ties to either automated or manual evaluation.
        for rule in A.RULES:
            self.assertIn(rule["class"], ("hard", "heuristic", "judgment"), rule["id"])
            self.assertIn(rule["evaluation"], ("automated", "manual"), rule["id"])

    def test_rule_ids_unique(self):
        ids = [r["id"] for r in A.RULES]
        self.assertEqual(len(ids), len(set(ids)))


if __name__ == "__main__":
    unittest.main()
```
