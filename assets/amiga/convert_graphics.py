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

NB_POSSIBLE_SPRITES = 128  # not a lot are really used

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


def add_sprites(start,stop,clut,name,mirror=True):
    for i in range(start,stop+1):
        add_sprite(i,clut,name,mirror)
def add_sprite(start,clut,name,mirror=True):
    if start in used_sprites:
        used_sprites[start]["clut"].add(clut)
    else:
        used_sprites[start] = {"name":name,"clut":{clut},"mirror":mirror}



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

# elevator wire 1F4 -> 1FB clut F

used_cluts.update({k:[0] for k in range(0x1F4,0x1FC)})


dump_tiles = True
dump_sprites = True
if dump_tiles:
    if not os.path.exists(dump_dir):
        os.mkdir(dump_dir)
    ensure_empty(tiles_dump_dir)
if dump_sprites:
    if not os.path.exists(dump_dir):
        os.mkdir(dump_dir)
    ensure_empty(sprites_dump_dir)

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




# for some reason, colors 1 and 2 of the cluts must be swapped to match
# the palette! invert the colors back for perfect coloring of sprites & tiles!!
bg_cluts = block_dict["clut"]["data"]

cluts = bg_cluts

character_codes_list = list()


rgb_cluts = [[tuple(palette[pidx]) for pidx in clut] for clut in bg_cluts]

# now time to reorder the palette. Hardware sprites set palette dynamically for the 16-31 range
# so we can get away with some hacks in title screen but a lot less during game
# during game, without sprites, the number of total colors is 13 yay!
#
# actually it's more than a reorder, it's a complete redefine for tiles (sprites use partial dynamic
# colors no need to change anything)

tiles_palette = [tuple(map(int,line.split())) for line in """0 0 0
222 151 0
184 104 0
151 255 247
71 184 247
71 255 247
255 255 0
255 255 247
0 0 247
255 0 0
255 33 79
255 184 0
28 19 0
0 255 0
255 222 247
255 0 247""".splitlines()]

original_palette = palette

# "VALADON" title uses other colors, we just replace them, we'll change them dynamically in the title screen
palette_replacement_dict = {(255,151,0):tiles_palette[1],(0,222,247):tiles_palette[2]}


with open(os.path.join(src_dir,"palette.68k"),"w") as f:
    bitplanelib.palette_dump(tiles_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)

# this game is so simple sprite-wise that it's possible to manually enter the clut/code
# combination instead of ripping them from running game. Besides, the game has a tendency
# to display sprites with wrong clut (briefly but would still be logged)

add_sprites(0x21,0x31,0xC,"guard")
# player frames symmetric but sometimes not useful
# (saves memory!)
add_sprite(0x12,0x8,"player",True)
add_sprites(0x14,0x1c,0x8,"player",False)
add_sprites(0x1d,0x20,0x8,"player",True)
# pick frames
add_sprites(0x77,0x78,0x9,"pickaxe")
#add_sprite(0x79,0x9,"pickaxe",False)  # no mirror
#add_sprites(0x77,0x79,0x9)  # intro: pick has a different color!
# barrow frames
add_sprites(0x7A,0x7B,0x8,"barrow",False)
# wagon
add_sprite(0x35,4,"wagon",False)
# elevators!!
add_sprite(0x33,4,"elevator",False)
add_sprite(0x33,8,"elevator",False)
#add_sprites(0x10,xx,"elevator",False)  # from Super Bagman ?
# bag
add_sprite(0x7F,0x9,"bag",True)  # yellow
add_sprite(0x7F,0x4,"bag",True)  # blue

# some sprite frames aren't used until super bagman. They're already in the sprite sheet, interesting!!!

# guard jumping/sliding
del used_sprites[0x2f]
del used_sprites[0x28]
del used_sprites[0x29]
# we also dropped player sliding (jump is used when exiting the wagon)



# compute colors used for sprites, we have to put them in the upper part 16:32



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
    local_palette = tiles_palette

    character_codes = list()

    for cidx,colors in enumerate(rgb_cluts):
        if not used_cluts or (k in used_cluts and cidx in used_cluts[k]):
            d = iter(chardat)
            for i in range(8):
                for j in range(8):
                    v = next(d)
                    c = colors[v]
                    tiles_used_colors.add(c)
                    img.putpixel((j,i),palette_replacement_dict.get(c,c))
            picname = f"char_{k:03x}_{cidx:02x}.png"
            try:
                character_codes.append(bitplanelib.palette_image2raw(img,None,local_palette))
            except bitplanelib.BitplaneException as e:
                print(picname,e)
                picname = "__dropped__"+picname
                character_codes.append(None)

            if dump_tiles:
                scaled = ImageOps.scale(img,5,0)
                scaled.save(os.path.join(tiles_dump_dir,picname))
        else:
            character_codes.append(None)
    character_codes_list.append(character_codes)



for k,data in used_sprites.items():
    sprdat = block_dict["sprite"]["data"][k]


    for clut_index in data["clut"]:
        spritepal = rgb_cluts[clut_index]
        d = iter(sprdat)
        img = Image.new('RGB',(16,16))
        y_start = 0

        for i in range(16):
            for j in range(16):
                v = next(d)
                if j >= y_start:
                    img.putpixel((j,i),spritepal[v])


        name = data['name']
        right = None

        outname = f"{k:02x}_{clut_index}_{name}.png"


        if "left" not in data:
            # all bitmaps are the same, only the colors change
            # the loop on the cluts is only useful for sprite dump
            left = bitplanelib.palette_image2sprite(img,None,spritepal)
            if data["mirror"]:
                data["right"] = bitplanelib.palette_image2sprite(ImageOps.mirror(img),None,spritepal)
            data["left"] = left


        if dump_sprites:
            scaled = ImageOps.scale(img,5,0)
            scaled.save(os.path.join(sprites_dump_dir,outname))


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

    # main table
    for i in range(NB_POSSIBLE_SPRITES):
        sprite = used_sprites.get(i)
        f.write("\t.long\t")
        if sprite:
            name = f"{sprite['name']}_{i:02x}"
            f.write(name)
        else:
            f.write("0")  # not used (yet)
        f.write("\n")

    for i in range(NB_POSSIBLE_SPRITES):
        sprite = used_sprites.get(i)
        if sprite:
            name = f"{sprite['name']}_{i:02x}:\n"
            f.write(name)
            for j in range(8):
                name = f"{sprite['name']}_{i:02x}_{j}"
                f.write(f"\t.long\t{name}\n")
    for i in range(NB_POSSIBLE_SPRITES):
        sprite = used_sprites.get(i)
        if sprite:
            for j in range(8):
                name = f"{sprite['name']}_{i:02x}_{j}"
                f.write(f"{name}:\n")
                f.write(f"\t.long   {name}_left\n")
                if sprite["mirror"]:
                    f.write(f"\t.long   {name}_right\n")
                else:
                    f.write(f"\t.long   {name}_left\n")


    f.write("\t.section\t.datachip\n")

    for i in range(NB_POSSIBLE_SPRITES):
        sprite = used_sprites.get(i)
        if sprite:
            name = f"{sprite['name']}_{i:02x}"
            for j in range(8):
                f.write(f"{name}_{j}_left:")
                bitplanelib.dump_asm_bytes(sprite["left"],f,mit_format=True)
                if sprite["mirror"]:
                    f.write(f"{name}_{j}_right:")
                    bitplanelib.dump_asm_bytes(sprite["right"],f,mit_format=True)

