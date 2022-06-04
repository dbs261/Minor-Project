file1 = open(r'E:\Codes\Programming\Python Scripts\Verilog\myfile.txt', 'w')
l=""
N = 32

wire = "wire "


# s = "X{}Y{}, "
# for i in range(N):
#     l = l + wire
#     for j in range(N):
#         l = l + s.format(i,j)
#     l = l[:-2] + ";"
#     l = l + "\n"

# s1 = "c{}_{}, "
# for i in range(1,N):
#     l = l + wire
#     for j in range(N):
#         l = l + s1.format(i,j)
#     l = l[:-2] + ";"
#     l = l + "\n"

# l = l + wire + "c{0}_{1};".format(0,N-1)
## assign c0_3 = 1;Generalize

# s2 = "z{}_{}, "
# for i in range(1,N):
#     l = l + wire
#     for j in range(N):
#         l = l + s2.format(i,j)
#     l = l[:-2] + ";"
#     l = l + "\n"
# l = l + wire + "z{0}_{1};".format(N-1,N)
# # assign z3_4 = 1;Generalize

# l = l + wire
# s3 = "c{} ,"
# for i in range(N,2*N):
#     l = l + s3.format(i)
# l = l[:-2] + ";"

l = l + wire
s4 = "z{} ,"
for i in range(N,2*N):
    l = l + s4.format(i)
l = l[:-2] + ";"

file1.write(l)
file1.close()