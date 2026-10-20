"""Inspect a Delphi TPF0 form resource; prints names, classes and selected properties."""

import struct
import sys
from pathlib import Path


data = Path(sys.argv[1]).read_bytes()
assert data.startswith(b"TPF0")
tab_summary = "--tabs" in sys.argv
pos = 4


def take(count):
    global pos
    if pos + count > len(data):
        raise ValueError(f"truncated at {pos:x}, wanted {count}")
    value = data[pos : pos + count]
    pos += count
    return value


def number(fmt):
    return struct.unpack(fmt, take(struct.calcsize(fmt)))[0]


def short():
    return take(number("<B")).decode("cp1252", "replace")


def long(encoding="cp1252", multiplier=1):
    size = number("<I") * multiplier
    return take(size).decode(encoding, "replace")


def value():
    kind = number("<B")
    if kind == 0:
        return None
    if kind == 1:
        result = []
        while data[pos] != 0:
            result.append(value())
        take(1)
        return result
    if kind == 2:
        return number("<b")
    if kind == 3:
        return number("<h")
    if kind == 4:
        return number("<i")
    if kind == 5:
        return f"<extended {take(10).hex()}>"
    if kind in (6, 7):
        return short()
    if kind == 8:
        return False
    if kind == 9:
        return True
    if kind == 10:
        size = number("<I")
        take(size)
        return f"<binary {size} bytes>"
    if kind == 11:
        items = []
        while (item := short()) != "":
            items.append(item)
        return items
    if kind == 12:
        return long()
    if kind == 13:
        return None
    if kind == 14:
        items = []
        while (item_kind := number("<B")) != 0:
            if item_kind != 1:
                raise ValueError(f"collection item {item_kind:x} at {pos:x}")
            items.append(properties())
        return items
    if kind == 15:
        return number("<f")
    if kind == 16:
        return number("<q") / 10000
    if kind == 17:
        return number("<d")
    if kind == 18:
        return long("utf-16le", 2)
    if kind == 19:
        return number("<q")
    if kind == 20:
        return long("utf-8")
    if kind == 21:
        return number("<d")
    if kind == 22:
        return long("utf-16le", 2)
    if kind == 23:
        return number("<Q")
    raise ValueError(f"value kind {kind:x} at {pos - 1:x}")


def properties():
    result = {}
    while (key := short()) != "":
        result[key] = value()
    return result


def component(depth=0):
    global pos
    flags = 0
    if data[pos] & 0xF0 == 0xF0:
        flags = number("<B") & 0x0F
    cls = short()
    if not cls:
        return None
    name = short()
    if flags & 2:
        value()
    props = properties()
    selected = {key: props[key] for key in ("Caption", "DataField", "DataSource", "OnClick", "ActivePage", "PageControl", "TabVisible") if key in props}
    if not tab_summary:
        print("  " * depth + f"{name}: {cls} {selected}")
    children = []
    while data[pos] != 0:
        children.append(component(depth + 1))
    take(1)
    return {"name": name, "class": cls, "flags": flags, "properties": props, "children": children}


root = component()
print(f"parsed {pos}/{len(data)} bytes")
if tab_summary:
    def list_tabs(node, ancestors=()):
        path = ancestors + (node["name"],)
        if node["class"] == "TPageControl":
            tabs = [child for child in node["children"] if child["class"] == "TTabSheet"]
            print("/".join(path), len(tabs))
            for child in tabs:
                print("  ", child["name"], "=", child["properties"].get("Caption", ""))
        for child in node["children"]:
            list_tabs(child, path)

    list_tabs(root)
