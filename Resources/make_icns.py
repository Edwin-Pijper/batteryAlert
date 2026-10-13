#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.
"""Converts Resources/AppIcon.png (1024 x 1024 px, transparent corners) into Resources/AppIcon.icns.

To use another icon: replace Resources/AppIcon.png by your own 1024 x 1024 PNG and run
    pip3 install pillow      (once)
    python3 Resources/make_icns.py
Then run ./package.sh again.
"""
import io
import os
import struct
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
SOURCE = os.path.join(HERE, "AppIcon.png")
TARGET = os.path.join(HERE, "AppIcon.icns")

# icns chunk type -> pixel size (PNG data inside the chunk)
CHUNKS = [("icp4", 16), ("icp5", 32), ("icp6", 64), ("ic07", 128), ("ic08", 256),
          ("ic09", 512), ("ic10", 1024), ("ic11", 32), ("ic12", 64), ("ic13", 256), ("ic14", 512)]


def png_bytes(img: Image.Image, size: int) -> bytes:
    buf = io.BytesIO()
    img.resize((size, size), Image.LANCZOS).save(buf, "PNG", optimize=True)
    return buf.getvalue()


def main():
    img = Image.open(SOURCE).convert("RGBA")
    if img.size != (1024, 1024):
        print(f"Note: {SOURCE} is {img.size[0]}x{img.size[1]}; it is scaled to 1024x1024")
        img = img.resize((1024, 1024), Image.LANCZOS)

    body = b""
    for kind, size in CHUNKS:
        data = png_bytes(img, size)
        body += kind.encode("ascii") + struct.pack(">I", len(data) + 8) + data
    with open(TARGET, "wb") as f:
        f.write(b"icns" + struct.pack(">I", len(body) + 8) + body)
    print("Written", TARGET)


if __name__ == "__main__":
    main()
