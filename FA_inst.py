file1 = open(r'E:\Codes\Programming\Python Scripts\Verilog\myfile.txt', 'w')
l = ""

N = 32

# Middle FA
s = "FA f{0}_{1}(X{1}Y{0},z{2}_{3},c{2}_{1},c{0}_{1},z{0}_{1});\n"

for i in range(2,N):
    for j in range(N-1):
        l = l + s.format(i,j,i-1,j+1)

#Bottom FA
sb = "FA f{0}(z{2}_{3},c{2}_{4},c{1},c{0},Z[{0}]);\n"
for i,j in zip(list(range(N+1,2*N)),list(range(1,N))):
    l = l + sb.format(i,i-1,N-1,j+1,j)

file1.writelines(l)

file1.close()