include("../src/multivector.jl")
@basis e1 e2 e3
# Vectors
a = e1
b = e2
c = e3

# Bivectors
A = e1*e2
B = e2*e3
C = e3*e1

# Pseudoscalar
I = e1*e2*e3

# Duals
i = -1*I*A
j = -1*I*B
k = -1*I*C
