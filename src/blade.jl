
struct Blade
    rep::BitVector
    val::Real
end

########################
###   Constructors   ###
########################
Blade




Base.:*(x::Blade, y::Blade) = Blade(xor.(x.rep, y.rep), signature(x,y)* x.val * y.val)

function signature(x::Blade, y::Blade)
    xv = convert.(Int8, x.rep >> -1)
    yv = convert.(Int8, y.rep)
    cumsum!(yv, yv)
    return iseven(sum(xv .* yv)) ? 1.0 : -1.0
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
        basebits = falses(length(x))
        setindex!(basebits, true, i)
        ex_aux = quote
            $s = Blade($basebits, 1.0)
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
        return "( "*string(bx.val)*" )"
    else
        return "( "*string(bx.val)*" ) ⋅ "*str*join(string.(indices.-1),"e")
    end
end

function Base.show(io::IO, bx::Blade)
    print(io,repr(bx))
end
