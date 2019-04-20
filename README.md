# GA.jl
Geometric Algebra in Julia.

### About this
  This is currently just a fun place for me to explore geometric algebra in Julia. The inspiration for this code is from Doran and Lasenby's Geometric Algebra for Physicists as well as Chris Doran's short implementation in haskell. I am deliberately avoiding referencing implementations in other languages as a learning tool.

For an alternative way of building up a basis we can use the @basis macro.
```julia
@basis e0 e1 e2 # This parses "e0 e2 e3" as being 3 separate basis vectors and creates them.

a = e0*e2
b = e2*e3

c = a * b  # The Geometric Product.
i = b*b # This object squares to -1. Imaginary numbers aren't real!
d = a + b # Adding Blades together makes a Multivector.
```
### References
  Geometric Algebra for Physicists. Chris Doran and Anthony Lasenby .Cambridge University Press; 1 edition (December 10, 2007)  
  http://geometry.mrao.cam.ac.uk/2017/10/geometric-algebra-in-haskell/
