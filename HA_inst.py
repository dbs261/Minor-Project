file1 = open(r'E:\Codes\Programming\Python Scripts\Verilog\myfile.txt', 'w')
l = ""
N = 32
s_top = "HA h{0}_{1}(X{1}Y{0},X{2}Y{3},c{0}_{1},z{0}_{1});\n"
s_side = "HA h{0}_{1}(X{1}Y{0},c{2}_{1},c{0}_{1},z{0}_{1});\n"
s_BR = "HA h{0}(z{1}_{2},c{1}_{3},c{0},Z[{0}]);\n"
# Top HA
i=1
for j in range(N-1):
    l = l + s_top.format(i,j,j+1,i-1)

# Side HA
j = N-1
for i in range(1,N):
    l = l + s_side.format(i,j,i-1)    

# Bottom right
l = l + s_BR.format(N,N-1,1,0)

file1.writelines(l)

file1.close()