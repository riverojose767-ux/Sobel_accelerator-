from PIL import Image

IMG_W = 128
IMG_H = 128

# The Sobel pipeline only produces valid edge outputs for the interior pixels —
# the first 2 rows and first 2 columns are skipped while the line buffer fills.
# Use the actual output dimensions so pixels map to the correct (x, y).
EDGE_W = IMG_W - 2
EDGE_H = IMG_H - 2

pixels = []
with open("edge_output.txt", "r") as f:
    for line in f:
        line = line.strip()
        if line:
            pixels.append(255 if int(line) else 0)
            #pixels.append(0 if int(line) else 255)

print(f"Read {len(pixels)} edge pixels (expected {EDGE_W * EDGE_H})")

if len(pixels) != EDGE_W * EDGE_H:
    print(f"WARNING: pixel count mismatch — got {len(pixels)}, expected {EDGE_W * EDGE_H}")

# Create a full-size output image (same dimensions as input) with black borders,
# then place the valid edge region in the correct interior position.
img = Image.new("L", (IMG_W, IMG_H), 0)

for i, value in enumerate(pixels):
    if i >= EDGE_W * EDGE_H:
        break
    # Interior pixel coordinates: offset by 1 to skip the border rows/cols
    x = (i % EDGE_W) + 1
    y = (i // EDGE_W) + 1
    img.putpixel((x, y), value)

img.save("hardware_edges.png")
print("Saved hardware_edges.png")
