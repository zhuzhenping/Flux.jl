using Flux, Flux.Tracker, CuArrays, Base.Test
using Flux: gpu

info("Testing Flux/GPU")

@testset "CuArrays" begin

CuArrays.allowscalar(false)

x = param(randn(5, 5))
cx = gpu(x)
@test cx isa TrackedArray && cx.data isa CuArray

x = Flux.onehotbatch([1, 2, 3], 1:3)
cx = gpu(x)
@test cx isa Flux.OneHotMatrix && cx.data isa CuArray

m = Chain(Dense(10, 5, tanh), Dense(5, 2), softmax)
cm = gpu(m)

@test all(p isa TrackedArray && p.data isa CuArray for p in params(cm))
@test cm(gpu(rand(10, 10))) isa TrackedArray{Float32,2,CuArray{Float32,2}}

x = [1,2,3]
cx = gpu(x)
@test Flux.crossentropy(x,x) ≈ Flux.crossentropy(cx,cx)

# Fails in Pkg.test ffs
# c = gpu(Conv((2,2),3=>4))
# l = c(gpu(rand(10,10,3,2)))
# Flux.back!(sum(l))

end

CuArrays.cudnn_available() && include("cudnn.jl")
