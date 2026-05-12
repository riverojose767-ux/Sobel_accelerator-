from PIL import Image
 
IMG_W = 128
IMG_H = 128
 
img = Image.open("greyscale.png").convert("L")
img = img.resize((IMG_W, IMG_H))
 
with open("input_pixels.txt", "w") as f:
    for y in range(IMG_H):
        for x in range(IMG_W):
            f.write(f"{img.getpixel((x, y))}\n")
 
print(f"Created input_pixels.txt ({IMG_W}x{IMG_H} = {IMG_W*IMG_H} pixels)")
