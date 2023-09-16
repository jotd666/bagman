import os,re,bitplanelib,ast,json,glob
from PIL import Image,ImageOps


import collections

def ensure_empty(d):
    if os.path.exists(d):
        for f in glob.glob(os.path.join(d,"*")):
            os.remove(f)
    else:
        os.mkdir(d)


this_dir = os.path.dirname(__file__)
src_dir = os.path.join(this_dir,"../../src/amiga")
dump_dir = os.path.join(this_dir,"dumps")
tiles_dump_dir = os.path.join(dump_dir,"tiles")
sprites_dump_dir = os.path.join(dump_dir,"sprites")

NB_POSSIBLE_SPRITES = 128  #64+64 alternate

##rw_json = os.path.join(this_dir,"used_sprites.json")
##if os.path.exists(rw_json):
##    with open(rw_json) as f:
##        used_sprites = json.load(f)
##    # key as integer, list as set for faster lookup (not that it matters...)
##    used_sprites = {int(k):set(v) for k,v in used_sprites.items()}
##else:
##    print("Warning: no {} file, no sprite/clut filter, expect BIG graphics.68k file")
##    used_sprites = None

used_sprites = {}
# this game is so simple sprite-wise that it's possible to manually enter the clut/code
# combination instead of ripping them from running game. Besides, the game has a tendency
# to display sprites with wrong clut (briefly but would still be logged)

def add_sprites(start,stop,clut):
    for i in range(start,stop+1):
        used_sprites[i] = clut

# guard frames
add_sprites(0x21,0x31,0xC)
# player frames
add_sprites(0x11,0x21,0x8)
# pick frames
add_sprites(0x77,0x79,0x9)
#add_sprites(0x77,0x79,0x9)  # intro: pick has a different color!
# barrow frames
add_sprites(0x7A,0x7B,0x8)
# wagon
#add_sprites(0x35,0x35,0x??)
# elevator
#add_sprites(????)
# bag
add_sprites(0x7F,0x7F,0x9)  # yellow
add_sprites(0x7F,0x7F,0x4)  # blue


# load all tiles/cluts from screens
# (logging the tiles is tedious and logs transitions which isn't good)

used_cluts = collections.defaultdict(set)


screens_dir = os.path.join(this_dir,os.pardir,"screens")
for sf in glob.glob(os.path.join(screens_dir,"*.bin")):
    with open(sf,"rb") as f:
        contents = f.read()
        tiles = contents[0:0x400]
        attribs = contents[0x800:0xC00]

        for raw_tile_index,raw_clut_index in zip(tiles,attribs):
            tile_index = raw_tile_index
            if raw_clut_index & 0x10:
                tile_index += 0x200
            if raw_clut_index & 0x20:
                tile_index += 0x100

            clut_index = raw_clut_index & 0xF
            used_cluts[tile_index].add(clut_index)

used_cluts.update({k:range(0,16) for k in range(0,64)})

dump_tiles = True
if dump_tiles:
    if not os.path.exists(dump_dir):
        os.mkdir(dump_dir)
    ensure_empty(tiles_dump_dir)

def dump_asm_bytes(*args,**kwargs):
    bitplanelib.dump_asm_bytes(*args,**kwargs,mit_format=True)


opposite = {"left":"right","right":"left"}

block_dict = {}

# hackish convert of c gfx table to dict of lists
# (Thanks to Mark Mc Dougall for providing the ripped gfx as C tables)
with open(os.path.join(this_dir,"..","bagman_gfx.c")) as f:
    block = []
    block_name = ""
    start_block = False

    for line in f:
        if "uint8" in line:
            # start group
            start_block = True
            if block:
                txt = "".join(block).strip().strip(";")

                block_dict[block_name] = {"size":size,"data":ast.literal_eval(txt)}
                block = []
            block_name = line.split()[1].split("[")[0]
            size = int(line.split("[")[2].split("]")[0])
        elif start_block:
            line = re.sub("//.*","",line)
            line = line.replace("{","[").replace("}","]")
            block.append(line)

    if block:
        txt = "".join(block).strip().strip(";")
        block_dict[block_name] = {"size":size,"data":ast.literal_eval(txt)}



# 26 colors total, we're going 32 colors total
palette = block_dict["palette"]["data"]

# TODO: reorder so sprites can use upper palette 16-31

palette = [tuple(x) for x in palette]

with open(os.path.join(src_dir,"palette.68k"),"w") as f:
    bitplanelib.palette_dump(palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)

# for some reason, colors 1 and 2 of the cluts must be swapped to match
# the palette! invert the colors back for perfect coloring of sprites & tiles!!
bg_cluts = block_dict["clut"]["data"]

cluts = bg_cluts

character_codes_list = list()


rgb_cluts = [[tuple(palette[pidx]) for pidx in clut] for clut in bg_cluts]



# dump cluts as RGB4 for sprites
with open(os.path.join(src_dir,"palette_cluts.68k"),"w") as f:
        f.write("cluts:")
        for clut in rgb_cluts:
            rgb4 = [bitplanelib.to_rgb4_color(x) for x in clut]
            bitplanelib.dump_asm_bytes(rgb4,f,mit_format=True,size=2)


tiles_used_colors = set()

for k,chardat in enumerate(block_dict["tile"]["data"]):
    # k < 0x100: normal tileset
    # k >= 0x100: alternate pack ice tileset
    img = Image.new('RGB',(8,8))
    local_palette = palette

    character_codes = list()

    for cidx,colors in enumerate(rgb_cluts):
        if not used_cluts or (k in used_cluts and cidx in used_cluts[k]):
            d = iter(chardat)
            for i in range(8):
                for j in range(8):
                    v = next(d)
                    c = colors[v]
                    tiles_used_colors.add(c)
                    img.putpixel((j,i),c)
            character_codes.append(bitplanelib.palette_image2raw(img,None,local_palette))
            if dump_tiles:
                scaled = ImageOps.scale(img,5,0)
                scaled.save(os.path.join(tiles_dump_dir,f"char_{k:02x}_{cidx:02x}.png"))
        else:
            character_codes.append(None)
    character_codes_list.append(character_codes)


##with open(os.path.join(this_dir,"sprite_config.json")) as f:
##    sprite_config = {int(k):v for k,v in json.load(f).items()}
##
##
##
##sprites = collections.defaultdict(dict)
##
##clut_index = 12  # temp
##
### pick a clut index with different colors
### it doesn't matter which one
##for clut in bg_cluts:
##    if len(clut)==len(set(clut)):
##        spritepal = clut
##        break
##else:
##    # can't happen
##    raise Exception("no way jose")
##
### convert our picked palette to RGB
##spritepal = [tuple(palette[pidx]) for pidx in spritepal]
##
##for k,data in sprite_config.items():
##    sprdat = block_dict["sprite"]["data"][k]
##
##    d = iter(sprdat)
##    img = Image.new('RGB',(16,16))
##    y_start = 0
##
##
##    for i in range(16):
##        for j in range(16):
##            v = next(d)
##            if j >= y_start:
##                img.putpixel((j,i),spritepal[v])
##
##    spr = sprites[k]
##    spr["name"] = data['name']
##    mirror = any(x in data["name"] for x in ("left","right"))
##
##    right = None
##    outname = f"{k:02x}_{clut_index}_{data['name']}.png"
##
##    left = bitplanelib.palette_image2sprite(img,None,spritepal)
##    if mirror:
##        right = bitplanelib.palette_image2sprite(ImageOps.mirror(img),None,spritepal)
##
##    spr["left"] = left
##    spr["right"] = right
##
##    if dump_sprites:
##        scaled = ImageOps.scale(img,5,0)
##        scaled.save(os.path.join(sprites_dump_dir,outname))



with open(os.path.join(src_dir,"graphics.68k"),"w") as f:
    f.write("\t.global\tcharacter_table\n")
    f.write("\t.global\tsprite_table\n")


    f.write("character_table:\n")
    for i,c in enumerate(character_codes_list):
        # c is the list of the same character with 31 different cluts
        if any(c):
            f.write(f"\t.long\tchar_{i}\n")
        else:
            f.write("\t.long\t0\n")
    for i,c in enumerate(character_codes_list):
        if any(c):
            f.write(f"char_{i}:\n")
            # this is a table
            for j,cc in enumerate(c):
                if cc is None:
                    f.write(f"\t.word\t0\n")
                else:
                    f.write(f"\t.word\tchar_{i}_{j}-char_{i}\n")

            for j,cc in enumerate(c):
                if cc is not None:
                    f.write(f"char_{i}_{j}:")
                    bitplanelib.dump_asm_bytes(cc,f,mit_format=True)
    f.write("sprite_table:\n")

##    sprite_names = [None]*NB_POSSIBLE_SPRITES
##    for i in range(NB_POSSIBLE_SPRITES):
##        sprite = sprites.get(i)
##        f.write("\t.long\t")
##        if sprite:
##            name = f"{sprite['name']}_{i:02x}"
##            sprite_names[i] = name
##            f.write(name)
##        else:
##            f.write("0")
##        f.write("\n")
##
##    for i in range(NB_POSSIBLE_SPRITES):
##        sprite = sprites.get(i)
##        if sprite:
##            name = sprite_names[i]
##            f.write(f"{name}:\n")
##            for j in range(8):
##                f.write("\t.long\t")
##                f.write(f"{name}_{j}")
##                f.write("\n")
##
##    for i in range(NB_POSSIBLE_SPRITES):
##        sprite = sprites.get(i)
##        if sprite:
##            name = sprite_names[i]
##            for j in range(8):
##                f.write(f"{name}_{j}:\n")
##
##                for d in ["left","right"]:
##                    bitmap = sprite[d]
##                    if bitmap:
##                        f.write(f"\t.long\t{name}_{j}_sprdata\n".replace(d,opposite[d]))
##                    else:
##                        # same for both
##                        f.write(f"\t.long\t{name}_{j}_sprdata\n")

    f.write("\t.section\t.datachip\n")

##    for i in range(256):
##        sprite = sprites.get(i)
##        if sprite:
##            name = sprite_names[i]
##            for j in range(8):
##                # clut is valid for this sprite
##
##                for d in ["left","right"]:
##                    bitmap = sprite[d]
##                    if bitmap:
##                        sprite_label = f"{name}_{j}_sprdata".replace(d,opposite[d])
##                        f.write(f"{sprite_label}:\n\t.long\t0\t| control word")
##                        bitplanelib.dump_asm_bytes(sprite[d],f,mit_format=True)
##                        f.write("\t.long\t0\n")
