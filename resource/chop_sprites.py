import PIL.Image,subprocess,os,glob,struct,shutil,collections

imconv = r"K:\progs\ImageMagickWin\convert.exe"

align_size = 16

def aligned_on_16(s):
    if s % align_size:
        s = (s // align_size)*align_size + align_size
    return s

SHIFTABLE_BOB = 0
SHIFTABLE_TRANSPARENT_BOB = 1
BOB = 2


image_type_table = {"va_logo":SHIFTABLE_BOB,"presents":SHIFTABLE_BOB,"life":SHIFTABLE_TRANSPARENT_BOB}

def get_image_type(image_filename,default_image_type):
    return image_type_table.get(os.path.basename(os.path.splitext(image_filename)[0]),default_image_type)

workdir = "amiga/work"
if not os.path.exists(workdir):
    os.mkdir(workdir)
# first concatenate all images together to have a shared palette
all_images = os.path.join(workdir,"all_images.png")
paletted_images = os.path.join(workdir,"paletted.png")

images = sorted([i,PIL.Image.open(i)] for i in glob.glob(os.path.join("1x","*","*.bmp")))

widths, heights = zip(*(i[1].size for i in images))

total_width = sum(widths)
max_height = max(heights)

new_im = PIL.Image.new('RGB', (total_width, max_height))

x_offset = 0
for im in images:
  new_im.paste(im[1], (x_offset,0))
  im.append(x_offset)
  x_offset += im[1].size[0]

new_im.save(all_images)
# game uses 18 or 19 colors, maybe not at the same time, but we're forced to use 5 planes ATM
# maybe later this can be reduced to 4 planes now that the hardcoding to 4 has been removed from this
# script AND the C++ program!!!
nb_planes = 4
nb_colors = 1<<nb_planes

subprocess.check_call([imconv,"-type","Palette","-colors",str(nb_colors),"+dither","-depth",str(nb_planes),all_images,paletted_images])
# now save copperlist
copper_out = os.path.join(workdir,"copperlist.raw")

subprocess.check_call(["amigeconv.exe","-p","pal4","-f","palette","-c",str(nb_colors),"-x",paletted_images,copper_out])
# now read back copperlist to generate RGB C file
with open(copper_out,"rb") as f:
    colors = []
    for i in range(nb_colors):
        f.read(2)
        color = struct.unpack(">H",f.read(2))[0]
        colors.append(color)

image_dict = collections.defaultdict(list)
for path,img,x_offset in images:
    sd = os.path.basename(os.path.dirname(path))
    image_dict[sd].append((path,img,x_offset))


sorted_colors = sorted(set(colors))
print("nb unique colors {}".format(len(sorted_colors)))
print("colors: {}".format(",".join("{:03x}".format(x) for x in sorted_colors)))

with open(os.path.join(workdir,"palette.hpp"),"w") as f:
    f.write("static const unsigned int palette[] = {")
    f.write(",".join(hex(x) for x in colors))
    f.write("};\n")

# pics in "images" are generally not "shiftable", whereas "sprite" ones are
# I wish we could have used sprites but it's too limited (colors/width/number of sprites)
# or AGA would have been required. But for such a small game... well, and AGA sprites seem to
# be not as easy, and probably not supported by imageconv...

new_im = PIL.Image.open(paletted_images)

for default_image_type,subdir in [(BOB,"images"),(SHIFTABLE_TRANSPARENT_BOB,"sprites")]:
    outdir = os.path.join("amiga",subdir)
    indir = os.path.join("1x",subdir)

    # now chop the converted png to raw amiga data, making sure all images have the same palette
    for image_name,im,x_offset in image_dict[subdir]:

        nim = new_im.crop((x_offset,0,im.size[0]+x_offset,im.size[1]))
        workimg = os.path.join(workdir,os.path.splitext(os.path.basename(image_name))[0]+".png")

        xsize = aligned_on_16(im.size[0])
        image_type = get_image_type(workimg,default_image_type)
        if image_type in (SHIFTABLE_BOB,SHIFTABLE_TRANSPARENT_BOB):
            xsize += align_size

        #print(image_name,xsize,im.size[0])
        if xsize != im.size[0]:
            # create another buffer
            print("create another buf {} {} != {}".format(workimg,xsize, im.size[0]))
            nim_2 = PIL.Image.new(nim.mode, (xsize,im.size[1]))
            nim_2.paste(nim, (0,0))
            nim = nim_2
        # the resized image has a broken palette (and temp images appear all dark),
        # but it doesn't matter as the global palette
        # matches the palette order
        nim.save(workimg)


        raw_name = os.path.join(outdir,os.path.basename(os.path.splitext(workimg)[0])+".raw")
        subprocess.check_call(["amigeconv.exe","-f","bitplane","-d",str(nb_planes),workimg,raw_name])
        with open(raw_name,"rb") as f:
            contents = f.read()
            # now encode width/height & nb of planes, image type: BOB/SHIFTED_BOB is planar, SPRITE is sprite
            if image_type == SHIFTABLE_TRANSPARENT_BOB:
                # create extra bitplane
                plane_size = len(contents)//nb_planes
                mask = []
                for i in range(plane_size):
                    v = 0
                    for j in range(nb_planes):
                        v |= contents[i+j*plane_size]
                    mask.append(v)

            contents = struct.pack(">2H2B",xsize,im.size[1],nb_planes,image_type) + contents
            if image_type == SHIFTABLE_TRANSPARENT_BOB:
                contents += bytearray(mask)

        with open(raw_name,"wb") as f:
            f.write(contents)
        subprocess.check_call(["rnc",raw_name])


