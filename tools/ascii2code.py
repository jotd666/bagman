s = "PORTED BY JOTD 2023"

code = {" " : 0xE0}

for i in range(ord('A'),ord('Z')+1):
    code[chr(i)] = i-0x30

for i in range(0x30,0x3A):
    code[chr(i)] = i-0x30

lst = [code[c] for c in s] + [0x3F]

print("""
* {}
    .byte   {}
""".format(s,",".join("0x{:02x}".format(c) for c in lst)))

