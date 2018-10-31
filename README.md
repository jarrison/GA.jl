# GA.jl
Geometric Algebra in Julia.

### About this
  This is currently just a fun place for me to explore geometric algebra in Julia. The inspiration for this code is from Doran and Lasenby's Geometric Algebra for Physicists as well as Chris Doran's short implementation in haskell. I am deliberately avoiding referencing implementations in other languages as a learning tool.
```julia
a = toblade("e1e2")
b = toblade("e2e3")
c = a * b
```
### References
  Geometric Algebra for Physicists. Chris Doran and Anthony Lasenby .Cambridge University Press; 1 edition (December 10, 2007)
  http://geometry.mrao.cam.ac.uk/2017/10/geometric-algebra-in-haskell/
