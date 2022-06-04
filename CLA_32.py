file1 = open(r'E:\Codes\Programming\Python Scripts\Verilog\myfile.txt', 'w')

l = ""
# s = "CLA_4bit c{}(.A(A[{}:{}]),.B(B[{}:{}]),.Cin(c{}),.Cout(c{}),.Sum(Sum[{}:{}]));\n"

# for i in range(1,9):
#     l.append(s.format(i-1,4*i-1,4*i-4,4*i-1,4*i-4,i-1,i,4*i-1,4*i-4))


file1.writelines(l)
file1.close()