def xy2addr(x,y,current_screen):
     rval = 0x4062 + 0x400 * (current_screen-1) + y//8 + ((0xE0-x)//8)*0x20
     return rval
def addr2xy(addr):
    b = addr - 0x4000
    current_screen = 0
    while b < 0x400:
        b-=0x400
    current_screen+=1
    b -= 0x62
    y = (b % 0x20) * 8
    x = 0xE0 - b // 4
    return [x,y,current_screen]

print(hex(xy2addr(0xB0,0x2,1)))
print(hex(xy2addr(0x80,0x10,3)))
print(hex(xy2addr(0x3E,0xE0,1)))