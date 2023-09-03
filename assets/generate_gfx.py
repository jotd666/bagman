# generate equivalent of Mark C format _gfx.* from MAME tilesaving edition gfxrips

from PIL import Image
import os,glob,collections,itertools

indir = "bagman"
palette_name = "palette0 *_0000.txt"
game_name = "bagman"
groups = {0:{"name":"tile"},1:{"name":"sprite"},2:{"name":"tiles"}}
text_bitmap = " .=#"
def get_clut(tile_group_index,clut_index):
    # for this game it's just palette blocks in order
    return palette[clut_index*4:clut_index*4+4]


def count_color(image):
    rval = set()
    for x in range(image.size[0]):
        for y in range(image.size[1]):
            p = image.getpixel((x,y))
            rval.add(p)

    return len(rval)

def write_tiles(blocks,size,f):
    for i,data in enumerate(blocks):
        f.write(f"  // ${i:X}\n  {{\n")
        offset = 0
        for k in range(size[1]):
            for j in range(size[0]):
                f.write("0x{:02d},".format(data[offset+j]))
            f.write("    // ")
            for j in range(size[0]):
                f.write(text_bitmap[data[offset+j]])
            f.write("\n   ")
            offset+=size[0]
        f.write("   },\n")

# dumped text file has a damn BOM
palette_file = glob.glob(os.path.join(indir,palette_name))
if not palette_file:
    raise Exception(f"Cannot locate palette wildcard {palette_name} in {indir}")
with open(palette_file[0],encoding='utf-8-sig') as f:
    line = next(f).split()
    nb_colors = int(line[0])
    next(f)
    next(f)
    palette = []
    for line in f:
        toks = line.strip().split(",")
        r,g,b,a = map(int,toks)
        palette.append((r,g,b))


global_palette = sorted(set(palette))
max_cols = collections.defaultdict(int)
max_col_image = dict()
name_image = dict()

gfxset_files = {os.path.basename(x):x for x in glob.glob(os.path.join(indir,"gfxset*.png"))}
for gf,file in gfxset_files.items():
    # locate pictures with max colors for each tileset or there will
    # be color index mixup when recognizing the tiles
    tileset = int(gf[6])  # index
    img = Image.open(file)
    name_image[gf] = img
    nbc = count_color(img)
    if nbc > max_cols[tileset]:
        max_cols[tileset] = nbc
        max_col_image[tileset] = gf
    # custom-made optimization
    if len(max_cols) == 4 and all(x==4 for x in max_cols.values()):
        break


# now we have one pic with max colors for each tileset
# we'll use those to compute colors as there's no ambiguity
max_colors = max(max_cols.values())

blocks = []
for k,v in max_col_image.items():
    block = []
    # compute data from name
    toks = v.split()
    clut_index = int(toks[-1].split("_")[0],16)
    w,h = map(int,toks[2].split("x"))
    img = name_image[v]
    nb_cols = img.size[0]//w
    nb_rows = img.size[1]//h
    nb_items = nb_cols*nb_rows
    groups[k]["dims"] = (w,h)


    clut = get_clut(k,clut_index)
    for sy in range(0,img.size[1],h):
        for sx in range(0,img.size[0],w):
            # for each tile
            data = []
            for y in range(sy,sy+h):
                for x in range(sx,sx+w):
                    rgb = img.getpixel((x,y))
                    try:
                        idx = clut.index(rgb)
                    except ValueError:
                        print(f"Warning: '{v}': {sx//w},{sy//h}: {rgb} not in clut {clut}")
                    data.append(idx)
            block.append(data)
    groups[k]["data"] = block

if True:
    with open(os.path.join(indir,f"{game_name}_gfx.h"),"w") as f:
        inc_protect = f"__{game_name.upper()}_GFX_H__"
        f.write(f"""#ifndef {inc_protect}
#define {inc_protect}

#define NUM_COLOURS {len(global_palette)}

#define NUM_TILES {len(groups[0]["data"])}
#define NUM_TILES {len(groups[1]["data"])*3}

#endif //  {inc_protect}
"""
)
    with open(os.path.join(indir,f"{game_name}_gfx.c"),"w") as f:
        f.write(f"""#include "{game_name}_gfx.h"

    // tile data
    """)
        tiles = groups[0]
        size = tiles["dims"]
        nb = size[0]*size[1]
        f.write(f"uint8_t tile[NUM_TILES][{nb}] =\n{{")
        blocks = [tiles["data"][0]+tiles["data"][2]]
        write_tiles(blocks,size,f)

        f.write("""};\n
    // sprite data
    """)
        tiles = groups[1]
        size = tiles["dims"]
        nb = size[0]*size[1]
        f.write(f"uint8_t sprite[NUM_SPRITES][{nb}] =\n{{")
        blocks = [tiles["data"][1]]
        write_tiles(blocks,size,f)

        f.write("""};\n   // cluts

    uint8_t cluts[NUM_CLUTS][4] =
    {
      """)

        nb_items=0
        for i in range(0,len(palette),4):
            f.write("{")
            for j in range(4):
                color = palette[i+j]
                idx = global_palette.index(color)
                f.write("{}".format(idx))
                if j != 3:
                    f.write(",")
            f.write("},\n")
        f.write("};\n")

        f.write("""};\n   // palette

    uint8_t palette[NUM_COLOURS][3] =
    {
      """)

        nb_items=0
        for p in global_palette:
            f.write("{{ {:3d},{:3d},{:3d} }},".format(*p))
            nb_items+=1
            if nb_items==4:
                nb_items=0
                f.write("\n  ")
            else:
                f.write("  ")
        f.write("\n};\n")
