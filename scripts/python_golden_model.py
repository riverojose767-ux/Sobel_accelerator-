#this ony works for fixed threshold mode, not adaptive threshold mode.
from PIL import Image

IMG_W = 128
IMG_H = 128
THRESHOLD = 130

INPUT_IMAGE = "input_1.jpg"

EXPECTED_TXT = "expected_edges.txt"
EXPECTED_IMG = "python_expected_edges.png"
EXPECTED_JPG = "expected_output.jpg"


def abs_val(value):
    if value < 0:
        return -value
    return value


img = Image.open(INPUT_IMAGE).convert("L")
img = img.resize((IMG_W, IMG_H))

pixels = list(img.getdata())

edges = [[0 for _ in range(IMG_W)] for _ in range(IMG_H)]

for y in range(1, IMG_H - 1):
    for x in range(1, IMG_W - 1):

        p1 = pixels[(y - 1) * IMG_W + (x - 1)]
        p2 = pixels[(y - 1) * IMG_W + x]
        p3 = pixels[(y - 1) * IMG_W + (x + 1)]

        p4 = pixels[y * IMG_W + (x - 1)]
        p5 = pixels[y * IMG_W + x]
        p6 = pixels[y * IMG_W + (x + 1)]

        p7 = pixels[(y + 1) * IMG_W + (x - 1)]
        p8 = pixels[(y + 1) * IMG_W + x]
        p9 = pixels[(y + 1) * IMG_W + (x + 1)]

        gx = (-p1) + (p3) + (-2 * p4) + (2 * p6) + (-p7) + (p9)

        gy = (p1) + (2 * p2) + (p3) + (-p7) + (-2 * p8) + (-p9)

        magnitude = abs_val(gx) + abs_val(gy)

        if magnitude >= THRESHOLD:
            edges[y][x] = 1
        else:
            edges[y][x] = 0


with open(EXPECTED_TXT, "w") as f:
    for y in range(1, IMG_H - 1):
        for x in range(1, IMG_W - 1):
            f.write(str(edges[y][x]) + "\n")


out_img = Image.new("L", (IMG_W, IMG_H), 0)

for y in range(IMG_H):
    for x in range(IMG_W):
        if edges[y][x] == 1:
            out_img.putpixel((x, y), 255)
        else:
            out_img.putpixel((x, y), 0)

out_img.save(EXPECTED_IMG)
out_img.save(EXPECTED_JPG)

print("Python golden model complete")
print(f"Created {EXPECTED_TXT}")
print(f"Created {EXPECTED_IMG}")
print(f"Created {EXPECTED_JPG}")
print(f"Expected edge count entries = {(IMG_W - 2) * (IMG_H - 2)}")

####
# this is used for adpative and fixed threshold modes, 

# from PIL import Image

# # =============================================================================
# # Configuration
# # =============================================================================

# IMG_W       = 128
# IMG_H       = 128
# THRESHOLD   = 130          # used only when MODE = "fixed"
# MODE        = "adaptive"   # "fixed" or "adaptive"
# INPUT_IMAGE = "input_1.jpg"

# EXPECTED_TXT = "expected_edges.txt"
# EXPECTED_IMG = "python_expected_edges.png"
# EXPECTED_JPG = "expected_output.jpg"

# # =============================================================================
# # Helpers
# # =============================================================================

# def abs_val(value):
#     return -value if value < 0 else value


# def compute_block_threshold(pixels, block_row, block_col, img_w):
#     """
#     Compute the 8x8 block midrange threshold for the block whose
#     top-left corner is at (block_row, block_col).

#     Matches hardware behavior exactly:
#       threshold = (max + min + 1) >> 1   (unconditional carry / round-up)
#     """
#     block_max = 0
#     block_min = 255

#     for r in range(block_row, block_row + 8):
#         for c in range(block_col, block_col + 8):
#             px = pixels[r * img_w + c]
#             if px > block_max:
#                 block_max = px
#             if px < block_min:
#                 block_min = px

#     return (block_max + block_min + 1) >> 1


# def get_adaptive_threshold_map(pixels, img_w, img_h):
#     """
#     Build a per-pixel threshold map using the same 8x8 block midrange
#     logic as the hardware adaptive_threshold module.

#     Hardware applies the threshold computed from block N to block N+1
#     (one block of latency). This model replicates that behavior:
#       - Block (0,0) uses the reset default threshold (128)
#       - Every subsequent block uses the threshold from the previous block

#     Returns a 2D list threshold_map[row][col].
#     """
#     threshold_map = [[128] * img_w for _ in range(img_h)]

#     prev_threshold = 128   # matches hardware reset default (8'h80)

#     for br in range(0, img_h, 8):
#         for bc in range(0, img_w, 8):
#             # apply previous block's threshold to this block
#             for r in range(br, min(br + 8, img_h)):
#                 for c in range(bc, min(bc + 8, img_w)):
#                     threshold_map[r][c] = prev_threshold

#             # compute this block's threshold for the next block
#             prev_threshold = compute_block_threshold(pixels, br, bc, img_w)

#     return threshold_map


# # =============================================================================
# # Load image
# # =============================================================================

# img = Image.open(INPUT_IMAGE).convert("L")
# img = img.resize((IMG_W, IMG_H))
# pixels = list(img.getdata())

# # =============================================================================
# # Build threshold map
# # =============================================================================

# if MODE == "adaptive":
#     threshold_map = get_adaptive_threshold_map(pixels, IMG_W, IMG_H)
#     print(f"Mode: ADAPTIVE (8x8 block midrange)")
# else:
#     # fixed — every pixel uses the same threshold
#     threshold_map = [[THRESHOLD] * IMG_W for _ in range(IMG_H)]
#     print(f"Mode: FIXED (threshold={THRESHOLD})")

# # =============================================================================
# # Sobel gradient + threshold
# # =============================================================================

# edges = [[0] * IMG_W for _ in range(IMG_H)]

# for y in range(1, IMG_H - 1):
#     for x in range(1, IMG_W - 1):

#         p1 = pixels[(y - 1) * IMG_W + (x - 1)]
#         p2 = pixels[(y - 1) * IMG_W +  x     ]
#         p3 = pixels[(y - 1) * IMG_W + (x + 1)]
#         p4 = pixels[ y      * IMG_W + (x - 1)]
#         p5 = pixels[ y      * IMG_W +  x     ]
#         p6 = pixels[ y      * IMG_W + (x + 1)]
#         p7 = pixels[(y + 1) * IMG_W + (x - 1)]
#         p8 = pixels[(y + 1) * IMG_W +  x     ]
#         p9 = pixels[(y + 1) * IMG_W + (x + 1)]

#         gx = -p1 + p3 - 2*p4 + 2*p6 - p7 + p9
#         gy =  p1 + 2*p2 + p3 - p7 - 2*p8 - p9

#         magnitude = abs_val(gx) + abs_val(gy)

#         # use per-pixel threshold from the map
#         thresh = threshold_map[y][x]

#         edges[y][x] = 1 if magnitude >= thresh else 0

# # =============================================================================
# # Write expected edges text file
# # (matches testbench output format — interior pixels only, row-major)
# # =============================================================================

# with open(EXPECTED_TXT, "w") as f:
#     for y in range(1, IMG_H - 1):
#         for x in range(1, IMG_W - 1):
#             f.write(str(edges[y][x]) + "\n")

# # =============================================================================
# # Write output images
# # =============================================================================

# out_img = Image.new("L", (IMG_W, IMG_H), 0)
# for y in range(IMG_H):
#     for x in range(IMG_W):
#         out_img.putpixel((x, y), 255 if edges[y][x] == 1 else 0)

# out_img.save(EXPECTED_IMG)
# out_img.save(EXPECTED_JPG)

# # =============================================================================
# # Summary
# # =============================================================================

# edge_count = sum(edges[y][x] for y in range(IMG_H) for x in range(IMG_W))

# print(f"Python golden model complete")
# print(f"Created {EXPECTED_TXT}")
# print(f"Created {EXPECTED_IMG}")
# print(f"Created {EXPECTED_JPG}")
# print(f"Expected edge count entries = {(IMG_W - 2) * (IMG_H - 2)}")
# print(f"Total edges detected        = {edge_count}")