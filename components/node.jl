abstract type Node{T,N} end

#TODO do id differently?
CURRENTID = 1
getGlobalID() = (global CURRENTID+=1;return CURRENTID-1)
# currentGlobalID() = (global CURRENTID; return CURRENTID-1)
resetGlobalID() = (global CURRENTID=1; nothing)

mutable struct NodeData{T,N}
    s0::SVector{N,T}
    s1::SVector{N,T}
    f::SVector{N,T}
    normf::T
    normΔs::T

    function NodeData{T,N}() where {T,N}
        s0 = @SVector zeros(T,N)
        s1 = @SVector zeros(T,N)
        f = @SVector zeros(T,N)
        normf = zero(T)
        normΔs = zero(T)
        
        new{T,N}(s0,s1,f,normf,normΔs)
    end
end

Base.show(io::IO, N::Node) = summary(io, N)
function Base.show(io::IO, mime::MIME{Symbol("text/plain")}, N::NodeData)
    summary(io, N); println(io)
    print(io, "\nD: ")
    show(io, mime, N.D)
    print(io, "\nDinv: ")
    show(io, mime, N.Dinv)
end


@inline Base.length(::Node{T,N}) where {T,N} = N
@inline Base.foreach(f,itr::Vector{<:Node},arg...) = (for x in itr; f(x,arg...); end; nothing)

@inline update!(node,diagonal) = (d = node.data; d.s1 = d.s0 - diagonal.ŝ; nothing)

# TODO understand why the + is necessary for zero alloc???
@inline s0tos1!(node) = (d = node.data; d.s1 = +d.s0; nothing)
@inline s1tos0!(node) = (d = node.data; d.s0 = +d.s1; nothing)

@inline function setNormΔs!(node)
    data = node.data
    diff = data.s1-data.s0
    data.normΔs= diff'*diff
    return nothing
end