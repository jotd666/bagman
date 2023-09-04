import json,os,collections

clut_dump = r"C:\Users\Public\Documents\Amiga Files\WinUAE\used_tiles"
this_dir = os.path.dirname(__file__)

rw_json = os.path.join(this_dir,"used_cluts.json")

with open(clut_dump,"rb") as f:
    dump = f.read()

used_cluts_ = dict()
if os.path.exists(rw_json):
    with open(rw_json) as f:
        used_cluts_ = json.load(f)

used_cluts = collections.defaultdict(set)
for k,v in used_cluts_.items():
    used_cluts[int(k)] = set(v)

# force letters & digits
alpha_clut = {0,
    11,
    16,
    17,
    22,
    23,
    24,
    25
  }

#for k in range(ord('A'),ord('Z')+1):
#    used_cluts[k].update(alpha_clut)
#for k in range(ord('0'),ord('9')+1):
#    used_cluts[k].update(alpha_clut)

for raw_tile_index in range(256):
    for raw_clut_index in range(256):
        if dump[raw_tile_index*256+raw_clut_index]:
            print("fffff")

##used_cluts = {k:sorted(v) for k,v in sorted(used_cluts.items())}
##
##with open(rw_json,"w") as f:
##   json.dump(used_cluts,f,indent=2)
