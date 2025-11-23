from PIL import Image

def hex_to_png(hex_path, png_path, width=128, height=128):
    with open(hex_path, 'r') as f:
        content = f.read()

    tokens = content.split()
    pixels = []
    for val in tokens:
        val = val.strip().lower()
        if not val:
            continue
        val = ''.join(c if c in "0123456789abcdef" else '0' for c in val)
        try:
            pixels.append(int(val, 16))
        except ValueError:
            pixels.append(0)

    expected = width * height
    if len(pixels) < expected:
        pixels += [0] * (expected - len(pixels))

    img = Image.new("L", (width, height))
    img.putdata(pixels[:expected])
    img.save(png_path)

hex_to_png("img/output.hex", "img/output.png", 128, 128)
