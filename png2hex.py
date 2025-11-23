import sys
from PIL import Image
import numpy as np

if len(sys.argv) > 1:
    try:
        KERNEL_SIZE = int(sys.argv[1])
        if KERNEL_SIZE not in [3, 4]:
            raise ValueError
    except ValueError:
        sys.exit(1)
else:
    KERNEL_SIZE = 4

WIDTH, HEIGHT = 128, 128
INPUT_IMG = "img/input.png"
OUTPUT_HEX = "img/input.hex"


img = Image.open(INPUT_IMG).convert('L').resize((WIDTH, HEIGHT), Image.BICUBIC)
pixels = np.array(img, dtype=np.uint8)

pad = KERNEL_SIZE // 2
padded = np.pad(pixels, pad, mode='edge')

with open(OUTPUT_HEX, "w") as f:
    for y in range(HEIGHT):
        for x in range(WIDTH):
            block = padded[y:y+KERNEL_SIZE, x:x+KERNEL_SIZE].flatten()
            for p in block:
                f.write(f"{p:02X}\n")

print(f"Generared input.hex ({WIDTH}x{HEIGHT} px) for kernel size {KERNEL_SIZE}")
