"""List readable occurrences related to Carga in a local Delphi executable."""

import re
import sys
from pathlib import Path


if len(sys.argv) != 2:
    raise SystemExit("Usage: python inspecionar_exe.py <path-to-FaturamentoMC.exe>")
SOURCE = Path(sys.argv[1])
data = SOURCE.read_bytes()
patterns = (
    ("ansi", re.compile(rb"[\x20-\x7e]{5,}")),
    ("utf16", re.compile(rb"(?:[\x20-\x7e]\x00){5,}")),
)
hits = []
for encoding, pattern in patterns:
    for match in pattern.finditer(data):
        value = match.group().decode("latin1" if encoding == "ansi" else "utf-16le")
        if "carga" in value.lower():
            hits.append((match.start(), encoding, value))

for offset, encoding, value in sorted(hits):
    print(f"{offset:08x} {encoding:5} {value[:300]}")
print(f"TOTAL: {len(hits)}")
