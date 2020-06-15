abstract type Joint{T,N} end

Base.show(io::IO, joint::Joint) = summary(io, joint)

getT(joint::Joint{T}) where T = T
getN(joint::Joint{T,N}) where {T,N} = N

@inline setForce!(joint::Joint) = return
@inline setForce!(joint::Joint, body1::AbstractBody, body2::AbstractBody, Fτ::SVector{0,T}) where T = setForce!(joint)

@inline minimalCoordinates(joint::Joint{T,N}) where {T,N} = szeros(T, 3 - N)
@inline g(joint::Joint{T,N}) where {T,N} = szeros(T, N)

@inline ∂g∂posa(joint::Joint{T,N}) where {T,N} = szeros(T, N, 6)
@inline ∂g∂posb(joint::Joint{T,N}) where {T,N} = szeros(T, N, 6)
@inline ∂g∂vela(joint::Joint{T,N}) where {T,N} = szeros(T, N, 6)
@inline ∂g∂velb(joint::Joint{T,N}) where {T,N} = szeros(T, N, 6)
@inline ∂g∂con(joint::Joint{T,N}) where {T,N} = szeros(T, N, 6)

@inline ∂Fτ∂ub(joint::Joint{T,N}) where {T,N} = szeros(T, 6, 3 - N)