a = [[0]*16 for _ in range(16)]
a[0][0] = 1
a[0][1] = 1
a[0][2] = 1
a[0][3] = 1
a[0][4] = 1

a[1][0] = 1
a[1][4] = 1
a[1][5] = 1
a[1][6] = 1
a[1][7] = 1
a[1][8] = 1

a[2][0] = 1
a[2][2] = 3
a[2][3] = 3
a[2][4] = 1
a[2][5] = 1
a[2][8] = 1

a[3][0] = 1
a[3][1] = 2
a[3][2] = 3
a[3][8] = 1

a[4][0] = 1
a[4][1] = 1
a[4][2] = 1
a[4][3] = 1
a[4][4] = 1
a[4][8] = 1

a[5][4] = 1
a[5][6] = 1
a[5][7] = 1
a[5][8] = 1

a[6][2] = 1
a[6][3] = 1
a[6][4] = 1
a[6][7] = 1

a[7][2] = 1
a[7][3] = 4
a[7][4] = 4
a[7][5] = 4
a[7][7] = 1

a[8][2] = 1
a[8][3] = 1
a[8][4] = 1
a[8][5] = 1
a[8][6] = 1
a[8][7] = 1

with open("pushbox_map.hex", "w") as f:
    f.write("v2.0 raw\n")
    for i in range(16):
        for j in range(16):
            f.write(f"{a[i][j]}\n")
