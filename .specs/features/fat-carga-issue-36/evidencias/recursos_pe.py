"""Read the PE resource table without loading or executing the ERP module."""

import struct
import sys
from pathlib import Path


if len(sys.argv) != 2:
    raise SystemExit("Usage: python recursos_pe.py <path-to-FaturamentoMC.exe>")
source = Path(sys.argv[1])
data = source.read_bytes()


def u16(offset):
    return struct.unpack_from("<H", data, offset)[0]


def u32(offset):
    return struct.unpack_from("<I", data, offset)[0]


pe = u32(0x3C)
assert data[pe : pe + 4] == b"PE\0\0"
section_count = u16(pe + 6)
optional_size = u16(pe + 20)
optional = pe + 24
magic = u16(optional)
directory_base = optional + (96 if magic == 0x10B else 112)
resource_rva = u32(directory_base + 2 * 8)
section_base = optional + optional_size
sections = []
for index in range(section_count):
    pos = section_base + index * 40
    name = data[pos : pos + 8].split(b"\0", 1)[0].decode("ascii", "replace")
    virtual_size, virtual_address, raw_size, raw_address = struct.unpack_from(
        "<IIII", data, pos + 8
    )
    sections.append((name, virtual_address, max(virtual_size, raw_size), raw_address))


def file_offset(rva):
    for _, address, size, raw in sections:
        if address <= rva < address + size:
            return raw + rva - address
    raise ValueError(f"RVA not mapped: {rva:x}")


root = file_offset(resource_rva)


def resource_name(value):
    if not value & 0x80000000:
        return str(value)
    pos = root + (value & 0x7FFFFFFF)
    count = u16(pos)
    return data[pos + 2 : pos + 2 + count * 2].decode("utf-16le")


def walk(relative, labels=()):
    pos = root + relative
    named, ids = struct.unpack_from("<HH", data, pos + 12)
    for index in range(named + ids):
        name_value, target = struct.unpack_from("<II", data, pos + 16 + index * 8)
        path = labels + (resource_name(name_value),)
        if target & 0x80000000:
            yield from walk(target & 0x7FFFFFFF, path)
        else:
            rva, size, _, _ = struct.unpack_from("<IIII", data, root + target)
            offset = file_offset(rva)
            yield path, offset, size, data[offset : offset + min(size, 24)]


print("sections", sections)
print("resource root", hex(root))
entries = list(walk(0))
print("resource count", len(entries))
print("RCDATA headers", {header: sum(1 for path, offset, size, sample in entries if path[0] == "10" and sample.startswith(header)) for header in (b"TPF0", b"object", b"\x78\x9c", b"\x78\xda")})
marker = data.find(b"TPF0")
print("first TPF0", hex(marker), ["/".join(path) for path, offset, size, _ in entries if offset <= marker < offset + size][:8])
for path, offset, size, sample in entries:
    if path[1] in ("TFPRINCIPAL", "TFCADCARGA"):
        print("comparison", "/".join(path), hex(offset), size, "TPF0", data[offset : offset + size].find(b"TPF0"), sample.hex(" "))
for path, offset, size, sample in entries:
    if any("carga" in part.lower() for part in path):
        relative_tpf = data[offset : offset + size].find(b"TPF0")
        print("/".join(path), hex(offset), size, "TPF0", relative_tpf, sample.hex(" "))
if len(sys.argv) > 2:
    wanted = sys.argv[2].upper()
    output = Path(sys.argv[3])
    matches = [(offset, size) for path, offset, size, _ in entries if len(path) > 1 and path[1].upper() == wanted]
    assert len(matches) == 1, matches
    offset, size = matches[0]
    output.write_bytes(data[offset : offset + size])
    print("extracted", wanted, output, size)
