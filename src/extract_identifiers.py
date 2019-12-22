import re,python_lacks

ident_re = re.compile(r"\b(\w+)_([0-9A-F][0-9A-F][0-9A-F][0-9A-F])\b")
lines = python_lacks.read_file("bagman_arcade.asm")
s = dict()

for l in lines:
    m=ident_re.search(l)
    if m:
        s[m.group(2)] = m.group(1)

ks = sorted(s.keys())
for k in ks:
    print s[k]+"_"+k
