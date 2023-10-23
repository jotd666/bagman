import os,re,collections

prefix_len = len("01 08 14     ")

def extract_offset(a):
    """ convert $xxxx => xxxx value
    variable_name_hexoffset => hexoffset value
    if not found returns None
    """
    v = None
    if a.startswith("$"):
        v = int(a[1:],16)
    if a.startswith("0x"):
        v = int(a,16)
    elif len(a)>5 and "_" in a:
        offset = a.split("_")[-1]
        try:
            v = int(offset,16)
        except ValueError:
            pass
    return v

def read(filepath):
    inst_dict = {}
    data_args = set()
    labels = {}
    raw = []
    entrypoints = collections.Counter()

    with open(filepath,"rb") as f:
        for line in f:
            line = line.decode(errors="ignore").rstrip()+"\n"
            raw.append(line)
            line = line.split(";")
            comment = ""
            if len(line)>1:
                comment = line[1].strip()
            line = line[0].strip()
            if line.endswith(":"):
                # label
                line = line.rstrip(":")
                offset = None
                if len(line)>5:
                    label_offset = line[-4:]
                    try:
                        offset = int(label_offset,16)
                    except ValueError:
                        pass
                    labels[line] = offset
            # decompose offset, opcodes
            toks = line.split()
            if len(toks)>1 and (toks[0].startswith("dc.") or toks[0] in [".long",".word",".byte"]):
                for t in toks[1].split(","):
                    data_args.add(t)
            toks = line.split(":")
            if len(toks)==2 and len(toks[0])==4:
                offset = int(toks[0],16)
                instruction = toks[1][prefix_len:]

                inst_toks = instruction.split()
                if inst_toks:
                    if inst_toks[0] in ["call","jp","jr"] and "," not in inst_toks[1]:
                        # unconditional call: entrypoint
                        entrypoints[inst_toks[1]] += 1

                    inst_dict[offset] = {"tokens":inst_toks,"comment":comment}

    label_offsets = {v:k for k,v in labels.items() if v is not None}
    return {"raw":raw,"instructions":inst_dict,"labels":labels,"data_args":data_args,
            "label_offsets":label_offsets,"entrypoints":dict(entrypoints)}

def write(filepath,lines):
    with open(filepath,"w") as f:
        f.writelines(lines)

