"""
    Blade{T<:Number}
Type representing the exterior product of a set of orthogonal basis vectors, {eₖ}.
λ (e₁ ∧ e₂ ∧ ... ∧ eₙ)
Every multivector can be written as a linear combination of Blades, making this
type the building block for higher grade objects. The actual representation that
expresses the mathematical properties of the Blade is the rep::BitVector. This
representation contains 1's at the indices corresponding to the basis vectors.
eg. e1e2e3 = [1,1,1] e1e3 = [1,0,1], e3 = [0,0,1]
"""
struct Blade{T<:Number}
    val::T
    rep::BitVector
    Blade{T}() where {T} = new(undef,falses(0))
    Blade{T}(val::T,rep::BitVector) where {T<:Number}= new(val,rep)
end
Blade(v::T,rep::BitVector) where {T<:Number} = Blade{T}(v,rep)
Blade{T}(x::Number) where {T<:Number} = Blade{T}(x,falses(0))
Blade{T}(b::Blade) where {T<:Number} = Blade{T}(b.val,b.rep)

Blade(x::Number, label::Integer) = (rep=falses(label);rep[label]=1;Blade(x,rep))
#const I = Blade(true,trues()) #TODO:figure out implementation for unit pseudoscalar


Base.promote_rule(::Type{Blade{T}}, ::Type{S}) where {T<:Number,S<:Number} = Blade{promote_type(T,S)}
Base.promote_rule(::Type{Blade{T}}, ::Type{Blade{S}}) where {T<:Number,S<:Number} = Blade{promote_type(T,S)}
"""
    MultiVector <: AbstractSet{Blade}
Represents a MultiVector as a set of component Blades.
"""
struct MultiVector <: AbstractSet{Blade}
    dict::Dict{Blade,Nothing}
    MultiVector()= new(Dict{Blade,Nothing}())
end
MultiVector(itr) = union!(MultiVector(),itr)

Base.isempty(m::MultiVector) = isempty(m.dict)
Base.length(m::MultiVector) = length(m.dict)
Base.in(x::Blade, m::MultiVector) = haskey(m.dict,x)
Base.push!(m::MultiVector,x::Blade) = (m.dict[x]=nothing;m)

########################
###   Conversions   ####

Base.:(==)(q::Blade,r::Blade) = (q.val == r.val) & (q.rep == r.rep)
Base.:(==)(q::Blade,x::Real) = (q.val == x) & (isempty(q.rep))

################
#     Math     #
################
"""
    signature(x::Blade, y::Blade)
Determines the number of swaps that occur in a geometric product. Returns either 1 or -1.
An even number of swaps produces +1, and odd number results in -1. Captures the
antisymmetry under interchange of basis vectors. e1∧e2 = -e2∧e1
"""
function signature(x, y)
    xv = x >> -1
    yv = cumsum(y)
    return iseven(sum(xv .* yv)) ? 1.0 : -1.0
end
function padfalse!(x::BitVector,y::BitVector)
    if length(x) == length(y)
        return
    elseif length(x)>length(y)
        append!(y,falses(length(x)-length(y)))
    else
        append!(x,falses(length(y)-length(x)))
    end
end

# Blade product is binary XOR of the int representation.
function Base.:*(x::Blade, y::Blade)
    xp = x.rep
    yp = y.rep
    padfalse!(xp,yp)
    Blade(signature(xp,yp)*x.val*y.val, xor.(xp, yp))
end


Base.:*(x::Blade, y::Number) = Blade(x.val*y, x.rep)
Base.:*(x::Number, y::Blade) = Blade(x*y.val, y.rep)

@inline function Base.:+(b1::Blade,b2::Blade)
    if b1.rep == b2.rep
        return Blade(b1.val+b2.val, b1.rep)
    else
        return MultiVector([b1,b2])
    end
end
# Base.:+(x::Blade, y::Number) = Blade(x.val*y, x.rep)
# Base.:+(x::Number, y::Blade) = Blade(x*y.val, y.rep)

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
            $s = Blade(1.0, $i)
        end
        append!(ex.args,ex_aux.args)
    end
    return esc(ex)
end

################
#    Display   #
################
function Base.repr(bx::Blade)
    indices = findall(bx.rep)
    str = "e" # Using this for basis vectors for now.
    if isempty(indices)
        return repr(bx.val)
    else
        return "( "*string(bx.val)*" ) ⋅ "*str*join(string.(indices),"e")
    end
end

function Base.show(io::IO, bx::Blade)
    print(io, repr(bx))
end
