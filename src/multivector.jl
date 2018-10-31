struct Blade{T,N}
    bladeint::T
    val::N
end

function tovectors(xs::String)
    r = eachmatch(r"([a-z][0-9])",xs)
    vectors = [i.match for i in r]
    return vectors
end

function getbladerep(xs::String)
    vectors = tovectors(xs)
    labels = [parse(Int,match(r"([0-9])",v).match) for v in vectors]
    intrep = 2 .^ labels
    return sum(&,intrep)
end

function toblade(xs::String,val=1)
    bint = getbladerep(xs)
    return Blade(bint, val)
end

# Blade product is binary XOR of the int representation.
@inline Base.:*(x::Blade,y::Blade) = Blade(x.bladeint ⊻ y.bladeint,1)
@inline Base.:*(x::Number, y::Blade) = Blade(y.bladeint, y.val * x )

################
#    Display   #
################

function Base.repr(bx::Blade)
    bs = bitstring(bx.bladeint)
    indices = findall(x->isone(parse(Int,x)),reverse(bs))
    str = "e" # Using this for basis vectors for now.
    return "( "*string(bx.val)*" )⋅"*str*join(string.(indices.-1),"e")
end
