module Optimise

export train!,
  SGD, ADAM, AdaMax, Momentum, Nesterov,
  RMSProp, ADAGrad, ADADelta, AMSGrad, NADAM

struct Param{T}
  x::T
  Δ::T
end

Base.convert(::Type{Param}, x::AbstractArray) = Param(x, zeros(x))

include("optimisers.jl")
include("interface.jl")
include("train.jl")

using Flux.Tracker: TrackedArray

Base.convert(::Type{Param}, x::TrackedArray) = Param(x.data, x.grad)

end
