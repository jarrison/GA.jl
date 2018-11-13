struct Blade{T<:Integer,N<:Number}
    bladeint::T
    val::N
    grade::Integer
end
Blade(x::T,y::N) where {T<:Integer,N<:Number} = Blade(x::T, y::N, count_ones(x))
Blade(x::T) where {T<:Integer} = Blade(x::T, 1, count_ones(x))

@inline function count_swaps(ma::Blade, mb::Blade)
    pad = (64-min(leading_zeros(ma.bladeint), leading_zeros(mb.bladeint)))
    aa = digits(ma.bladeint>>1,base=2,pad=pad)
    bb = digits(mb.bladeint,base=2,pad=pad)
    cumsum!(bb,bb)
    cc = sum(aa .* bb)
    if iseven(cc)
        return 1
    else
        return -1
    end
end
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

################
#  Multivector #
################

const Multivector = Vector{Blade}

function Base.:+(mA::Multivector, mB::Multivector)
    return sort([mA;mB],by=x->x.bladeint)
end

function Base.:+(mA::Multivector, mB::Blade)
    return sort([mA;mB],by=x->x.bladeint)
end
function Base.:+(mB::Blade,mA::Multivector)
    return sort([mA;mB],by=x->x.bladeint)
end

function Base.:-(mA::Multivector, mB::Multivector)
    return sort([mA;-1*mB], by=x->x.bladeint)
end

###################
# Representations #
###################
""" Parse an expression as a string of basis vectors, create blades of those
vectors"""
macro basis(x...)
    ex = Expr(:block)
    if length(x)==1 && isa(x[1],Expr)
        @assert x[1].head === :tuple "expected list of vectors."
        x = x[1].args
    end
    for (i,s) in enumerate(x)
        ex_aux = quote
            $s = Blade(2^($i-1))
        end
        append!(ex.args,ex_aux.args)
    end
    return esc(ex)
end

################
#    Display   #
################
function Base.repr(bx::Blade)
    bs = bitstring(bx.bladeint)
    indices = findall(x->isone(parse(Int,x)),reverse(bs))
    str = "e" # Using this for basis vectors for now.
    if bx.bladeint == 0
        return "( "*string(bx.val)*" )"
    else
        return "( "*string(bx.val)*" ) ⋅ "*str*join(string.(indices.-1),"e")
    end
end

function Base.show(io::IO, bx::Blade)
    print(io,repr(bx))
end
