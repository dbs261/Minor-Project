import numpy as np
dps = np.array([[7,8,0,1],[9,1,2,3],[3,4,5,6],[2,4,3,6]])

y = np.array([16,15,18,15])

wt = np.array([0.25, 0.25, 0.25, 0.25])

y_cap = np.array([0.0,0.0,0.0,0.0])

for i in range(3):
    print(f"-------------epoch{i+1}-----------")
    for j in range(4):
        print("Products0123: ",wt*dps[j])
        print("Sum of product of errors")
        y_cap[j] = np.sum(wt*dps[j],dtype = np.float32)
        print("y_cap: \n",y_cap)
        wt = wt+(y[j]-y_cap[j])/128*dps[j]
        print("wt: \n", wt)