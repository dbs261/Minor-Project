file1 = open(r'E:\Codes\Programming\Python Scripts\Verilog\myfile.txt', 'w')
l = ""

N = 32

# # For partial products
# s = "assign X{}Y{} = {}(X[{}]&Y[{}]);\n"

# for i in range(N):
#     for j in range(N):
#         if i!=N-1 and j!=N-1 or (i==N-1 and j==N-1):
#             l = l + s.format(i,j,"",i,j)
#         else:
#             l = l + s.format(i,j,"~",i,j)

# For 1st 32 output bits
s1 = "assign Z[{0}] = z{0}_0;\n"
for i in range(1,N):
    l = l + s1.format(i)

file1.writelines(l)
file1.close()