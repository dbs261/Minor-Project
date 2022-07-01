# with open(r'E:\Dhanush\Minor_project\Minor_project.srcs\sources_1\new\wine.txt', 'r') as f:
#     lines = f.readlines()

# for i in range(len(lines)):
#     lines[i] = lines[i][4:len(lines[i])-1]+' '+lines[i][:3]
#     # lines[i] = lines[i].replace(' ', '_')
#     x = lines[i].split(" ")
#     for j in range(len(x)):
#         if len(x[j])==3:
#             x[j] = '0' + x[j]
#         elif len(x[j])==2:
#             x[j] = '00' + x[j]
#         elif len(x[j])==1:
#             x[j] = '000' + x[j]
#     lines[i] = '_'.join(x)+'\n'


# # print(lines)

# with open(r'E:\Dhanush\Minor_project\Minor_project.srcs\sources_1\new\wine2.txt', 'w') as f:
#     f.writelines(lines)

# s = "ABCDEFGHI"

# s = s[2:]+s[:2]

# print(len(s))
import numpy as np

l_py = np.array([
0.5699862376872405 ,      
0.5769562456477056 ,      
0.5709895466578738 ,      
0.5397469346807249  ,     
0.5660398027899576   ,    
0.5397469346807249    ,   
0.5655389338166891     ,  
0.5330089813283011      , 
0.530849145977895        ,
0.42365366195853826      ])

l_verilog = np.array([
0.6020717024803162,
0.5695105195045471,
0.43944209814071655,
0.45045459270477295,
0.48126161098480225,
0.45045459270477295,
0.5694612264633179,
0.5293686389923096,
0.6127147078514099,
0.48796379566192627])

l_actual = np.array(
    [
        0.6,0.6,0.6,0.4,0.4,0.4,0.4,0.4,0.6,0.4
    ]
)

error_py = np.sum((l_py-l_actual)**2)/10
error_ver = np.sum((l_verilog-l_actual)**2)/10

print("Actual \t Python \t LR Hardware Accelerator")
for i in range(10):
    print(f'{l_actual[i]}\t{l_py[i]}\t{l_verilog[i]}')
print(f'\nMean Square Errors:\nPython:\t {error_py}\nLR Hardware Accelerator: {error_ver}')