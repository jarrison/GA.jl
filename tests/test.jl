include("blade.jl")
include("multivector.jl")
@basis e1 e2 e3

a = e1*e2
b = e1*e3

a*b
b*a

a + b

1.0 + b

b *(1/99999)
