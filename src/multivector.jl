
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

function count_swaps(ma::Blade,mb::Blade)
    avec = reverse!([parse(UInt8,aa) for aa in bitstring(ma.bladeint)])[2:end]
    bvec = reverse!([parse(UInt8,bb) for bb in bitstring(mb.bladeint)])[2:end]
    bvec = cumsum(bvec)[1:end-1]
    avec = avec[2:end]
    sm = convert(Int,sum(bvec .* avec))
    if iseven(sm)
        return 1
    else
        return -1
    end
end
# Blade product is binary XOR of the int representation.
@inline Base.:*(x::Blade,y::Blade) = Blade(x.bladeint ⊻ y.bladeint, x.val * y.val * count_swaps(x,y))
@inline Base.:*(x::Number, y::Blade) = Blade(y.bladeint, y.val * x )
@inline Base.:*(x::Blade, y::Number) = Blade(x.bladeint, x.val * y )

################
#    Display   #
################
function Base.repr(bx::Blade)
    bs = bitstring(bx.bladeint)
    indices = findall(x->isone(parse(Int,x)),reverse(bs))
    str = "e" # Using this for basis vectors for now.
    return "( "*string(bx.val)*" ) ⋅ "*str*join(string.(indices.-1),"e")
end
