################
#     Math     #
################
# Blade product is binary XOR of the int representation.
@inline Base.:*(x::Blade,y::Blade) = Blade(x.bladeint ⊻ y.bladeint, (x.val * y.val )* count_swaps(x,y))
@inline Base.:*(x::Number, y::Blade) = Blade(y.bladeint, y.val * x )
@inline Base.:*(x::Blade, y::Number) = Blade(x.bladeint, x.val * y )
issame(x::Blade,y::Blade) = x.bladeint == y.bladeint

################
#  Multivector #
################
@inline function Base.:+(b1::Blade,b2::Blade)
    sum = b1.val::Number + b2.val::Number
    if b1.bladeint == b2.bladeint
        return Blade(b1.bladeint, sum)
    else
        return Blade[b1,b2]
    end
end
