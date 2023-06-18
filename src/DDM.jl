"""
    DDM 

    Model object for the Standard Diffusion Decision Model.

# Fields
    - `ν`: drift rate. Average slope of the information accumulation process. The drift gives information about the speed and direction of the accumulation of information. Typical range: -5 < ν < 5
    - `α`: boundary threshold separation. The amount of information that is considered for a decision. Typical range: 0.5 < α < 2
    - `τ`: non-decision time. The duration for a non-decisional processes (encoding and response execution). Typical range: 0.1 < τ < 0.5 
    - `z`: starting point. Indicator of an an initial bias towards a decision. The z parameter is relative to a (i.e. it ranges from 0 to 1).

# Example 

```julia
using SequentialSamplingModels
dist = DDM(ν = 1.0, α = 0.8, τ = 0.3 z = 0.25) 
choice,rt = rand(dist, 10)
like = pdf.(dist, choice, rt)
loglike = logpdf.(dist, choice, rt)
```

# References
    
Ratcliff, R., & McKoon, G. (2008). The Diffusion Decision Model: Theory and Data for Two-Choice Decision Tasks. Neural Computation, 20(4), 873–922.

"""
@concrete mutable struct DDM{T1,T2,T3,T4} <: SequentialSamplingModel
    ν::T1
    α::T2
    τ::T3
    z::T4
end

Base.broadcastable(x::DDM) = Ref(x)

function params(d::DDM)
    (d.ν, d.α, d.τ, d.z)    
end

loglikelihood(d::DDM, data) = sum(logpdf.(d, data...))

"""
DDM(; ν = 1.0,
    α = 0.8,
    τ = 0.3
    z = 0.25
    )

Constructor for Diffusion Decision Model. 
    
# Keywords 
    - `ν`: drift rate. Average slope of the information accumulation process. The drift gives information about the speed and direction of the accumulation of information. Typical range: -5 < ν < 5
    - `α`: boundary threshold separation. The amount of information that is considered for a decision. Typical range: 0.5 < α < 2
    - `τ`: non-decision time. The duration for a non-decisional processes (encoding and response execution). Typical range: 0.1 < τ < 0.5 
    - `z`: starting point. Indicator of an an initial bias towards a decision. The z parameter is relative to a (i.e. it ranges from 0 to 1).

# Example 

```julia
using SequentialSamplingModels
dist = DDM(ν = 1.0, α = 0.8, τ = 0.3 z = 0.25) 
```
"""
function DDM(; ν = 1.00,
    α = 0.80,
    τ = 0.30,
    z = 0.25
    )
    return DDM(ν, α, τ, z)
end

################################################################################
#  Converted from WienerDiffusionModel.jl repository orginally by Tobias Alfers#
#  See https://github.com/t-alfers/WienerDiffusionModel.jl                     #
################################################################################

#####################################
# Probability density function      #
# Navarro & Fuss (2009)             #
# Wabersich & Vandekerckhove (2014) #
#####################################

function pdf(d::DDM, choice, rt; ϵ::Real = 1.0e-12)
    if choice == 1
        (ν, α, τ, z) = params(d)
        return pdf(DDM(-ν, α, τ, 1-z), rt; ϵ=ϵ)
    end
    return pdf(d, rt; ϵ=ϵ)
end

# probability density function over the lower boundary
function pdf(d::DDM{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    (ν, α, τ, z) = params(d)
    if τ ≥ t
        return T(NaN)
    end
    u = (t - τ) / α^2 #use normalized time

    K_s = 2.0
    K_l = 1 / (π * sqrt(u))
    # number of terms needed for large-time expansion
    if (π*u*ϵ) < 1
        K_l = max(sqrt((-2*log(π*u*ϵ)) / (π^2 * u)), K_l)
    end
    # number of terms needed for small-time expansion
    if (2*sqrt(2*π*u)*ϵ) < 1
        K_s = max(2 + sqrt(-2u * log(2ϵ*sqrt(2*π*u))), sqrt(u)+1)
    end

    p = exp((-α*z*ν) - (0.5*(ν^2)*(t-τ))) / (α^2)

    # decision rule for infinite sum algorithm
    if K_s < K_l
        return p * _small_time_pdf(u, z, ceil(Int, K_s))
    end
    
    return p * _large_time_pdf(u, z, ceil(Int, K_l))
end

# small-time expansion
function _small_time_pdf(u::T, z::T, K::Int) where {T<:Real}
    inf_sum = zero(T)

    k_series = -floor(Int, 0.5*(K-1)):ceil(Int, 0.5*(K-1))
    for k in k_series
        inf_sum += ((2k + z) * exp(-((2k + z)^2 / (2u))))
    end

    return inf_sum / sqrt(2π*u^3)
end

# large-time expansion
function _large_time_pdf(u::T, z::T, K::Int) where {T<:Real}
    inf_sum = zero(T)

    for k in 1:K 
        inf_sum += (k * exp(-0.5*(k^2*π^2*u)) * sin(k*π*z)) 
    end

    return π * inf_sum
end

logpdf(d::DDM, choice, rt; ϵ::Real = 1.0e-12) = log(pdf(d, choice, rt; ϵ=ϵ))
#logpdf(d::DDM, t::Real; ϵ::Real = 1.0e-12) = log(pdf(d, t; ϵ=ϵ))

function logpdf(d::DDM, data::T) where {T<:NamedTuple}
    return sum(logpdf.(d, data...))
end

function logpdf(dist::DDM, data::Array{<:Tuple,1})
    LL = 0.0
    for d in data
        LL += logpdf(dist, d...)
    end
    return LL
end

logpdf(d::DDM, data::Tuple) = logpdf(d, data...)

#########################################
# Cumulative density function           #
# Blurton, Kesselmeier, & Gondan (2012) #
#########################################
 
function cdf(d::DDM, choice, rt; ϵ::Real = 1.0e-12)
    if choice == 1
        (ν, α, τ, z) = params(d)
        return cdf(DDM(-ν, α, τ, 1-z), rt; ϵ=ϵ)
    end

    return cdf(d, rt; ϵ=ϵ)
end

# cumulative density function over the lower boundary
function cdf(d::DDM{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    if d.τ ≥ t
        return T(NaN)
    end

    K_s = _K_small(d, t; ϵ=ϵ)
    K_l = _K_large(d, t; ϵ=ϵ)

    if K_l < 10*K_s
        return _Fl_lower(d, K_l, t)
    end

    return _Fs_lower(d, K_s, t)
end

function _Fl_lower(d::DDM{T}, K::Int, t::Real) where {T<:Real}
    (ν, α, τ, z) = params(d)
    F = zero(T)
    K_series = K:-1:1
    for k in K_series
        F -= (k/(ν^2 + k^2*π^2/(α^2)) * 
            exp(-ν*α*z - 0.5*ν^2*(t-τ) - 0.5*k^2*π^2/(α^2)*(t-τ)) *
            sin(π * k * z))
    end
    return _P_upper(ν, α, z) + 2*π/(α^2) * F
end

function _Fs_lower(d::DDM{T}, K::Int, t::Real) where {T<:Real}
    (ν, α, τ, z) = params(d)
    if abs(ν) < sqrt(eps(T))
        return _Fs0_lower(d, K, t)
    end

    sqt = sqrt(t-τ)

    S1 = zero(T)
    S2 = zero(T)
    K_series = K:-1:1
    for k in K_series
        S1 += (_exp_pnorm(2*ν*α*k, -sign(ν)*(2*α*k+α*z+ν*(t-τ))/sqt) -
            _exp_pnorm(-2*ν*α*k-2*ν*α*z, sign(ν)*(2*α*k+α*z-ν*(t-τ))/sqt))
        S2 += (_exp_pnorm(-2*ν*α*k, sign(ν)*(2*α*k-α*z-ν*(t-τ))/sqt) - 
            _exp_pnorm(-2*ν*α*k-2*ν*α*z, -sign(ν)*(2*α*k-α*z-ν*(t-τ))/sqt))
    end

    return _P_upper(ν, α, z) + sign(ν) * (
        (cdf(Normal(), -sign(ν) * (α*z+ν*(t-τ))/sqt) - _exp_pnorm(-2*ν*α*z, sign(ν) * (α*z-ν*(t-τ)) / sqt))
    ) + S1 + S2
end

function _Fs0_lower(d::DDM{T}, K::Int, t::Real) where {T<:Real}
    (_, α, τ, z) = params(d)
    F = zero(T)
    K_series = K:-1:0
    for k in K_series
        F -= (cdf(Normal(), (-2*k - 2+z) * α / sqrt(t-τ)) + cdf(Normal(), (-2*k -z) * α / sqrt(t-τ)))
    end
    return 2*F
end

function _K_large(d::DDM{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    (ν, α, τ, z) = params(d)
    return ceil(Int, max(sqrt(1/(t-τ)) * α/π, sqrt(max(1, -2/(t-τ)*α^2/(π^2) * (log(ϵ*π*(t-τ)/2 * (ν^2 + π^2/(α^2)))) + ν*α*z + ν^2*(t-τ)/2))))
end

function _K_small(d::DDM{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    (ν, α, τ, z) = params(d)
    if abs(ν) < sqrt(eps(T))
        return ceil(Int, max(0, z/2 - sqrt(t-τ)/(2*α) * quantile(Normal(), max(0, min(1, ϵ/(2-2*z))))))
    end
    if ν > 0
        return _K_small(DDM(-ν, α, τ, z), t; ϵ = exp(-2*α*z*ν)*ϵ)
    end
    S2 = z - 1 + 1/(2*ν*α) * log(ϵ/2 * (1-exp(2*ν*α)))
    S3 = (0.535 * sqrt(2*(t-τ)) + ν*(t-τ) + α*z)/(2*α)
    S4 = z/2 - sqrt(t-τ)/(2*α) * quantile(Normal(), max(0, min(1, ϵ*α/(0.3 * sqrt(2*π*(t-τ))) * exp(ν^2*(t-τ)/2 + ν*α*z) ))) 
    return ceil(Int, max(0, S2, S3, S4))
end

function _P_upper(ν::T, α::T, z::T) where {T<:Real}
    e = exp(-2 * ν * α * (1-z))
    if isinf(e)
        return 1
    end
    if abs(e-1) < sqrt(eps(T))
        return 1-z
    end
    return (1-e)/(exp(2*ν*α*z) - e)
end

# Approximation by Kiani et al. (2008)
function _exp_pnorm(a::T, b::T) where {T<:Real}
    r = exp(a) * cdf(Normal(), b)
    if isnan(r) && b < -5.5
        r = (1/sqrt(2)) * exp(a - b^2/2) * (0.5641882/(b^3) - 1/(b * sqrt(π))) 
    end
    return r
end

"""
    rand(dist::DDM)

Generate a random rt for the Diffusion Decision Model (negative coding)

# Arguments
- `dist`: model object for the Diffusion Decision Model. 
"""
function rand(rng::AbstractRNG, d::DDM)
    return _rand_rejection(rng, d)
end

# Rejection-based Method for the Symmetric Wiener Process(Tuerlinckx et al., 2001 based on Lichters et al., 1995)
# adapted from the RWiener R package, note, here σ = 0.1
function _rand_rejection(rng::AbstractRNG, d::DDM)
    (ν, α, τ, z) = params(d)
    
    ϵ = 1.0e-15

    D = .005 # = 2*σ^2 => 1/200
    zn = (z*α) / 10 # absolute bias!
    αn = α / 10
    νn = ν / 10

    total_time = 0.0
    start_pos = 0.0
    Aupper = αn - zn
    Alower = -zn
    radius = min(abs(Aupper), abs(Alower))
    λ = 0.0
    F = 0.0
    prob = 0.0

    while true
        if νn == 0
            λ = (0.25D*π^2) / (radius^2)
            F = 1.0
            prob = .5            
        else
            λ = ((0.25*νn^2)/D) + ((0.25*D*π^2) / (radius^2))
            F = (D*π) / (radius*νn)
            F = F^2 / (1+F^2)
            prob = exp((radius*νn)/D)
            prob = prob / (1+prob)
        end

        r = rand(rng)
        dir = r < prob ? 1 : -1
        l = -1.0
        s1 = 0.0
        s2 = 0.0

        # Tuerlinckx et al. (2001; eq. 16)  
        while s2 > l
            s1 = rand(rng)
            s2 = rand(rng)
            tnew = 0.0
            tδ = 0.0
            uu = zero(Int)

            while (abs(tδ) > ϵ) || (uu == 0)
                uu += 1
                tt = 2*uu + 1
                tδ = tt * (uu % 2 == 0 ? 1 : -1) * (s1 ^ (F * tt^2))
                tnew += tδ                              
            end

            l = 1 + (s1^(-F)) * tnew 
        end

        total_time += abs(log(s1)) / λ
        dir = start_pos + dir * radius

        if (dir + ϵ) > Aupper
            rt = total_time + τ
            choice = 1
            return choice,rt
        elseif (dir - ϵ) < Alower
            rt = total_time + τ
            choice = 2
            return choice,rt
        else
            start_pos = dir
            radius = min(abs(Aupper - start_pos), (abs(Alower - start_pos)))
        end
    end
end

"""
    rand(dist::DDM, n_sim::Int)

Generate `n_sim` random choice-rt pairs for the Diffusion Decision Model.

# Arguments
- `dist`: model object for the Drift Diffusion Model.
- `n_sim::Int`: the number of simulated rts  
"""

function rand(rng::AbstractRNG, d::DDM, n_sim::Int)
    choice = fill(0, n_sim)
    rt = fill(0.0, n_sim)
    for i in 1:n_sim
        choice[i],rt[i] = rand(d)
    end
    return (choice=choice,rt=rt)
end

sampler(rng::AbstractRNG, d::DDM) = rand(rng::AbstractRNG, d::DDM)

# """
#     RatcliffDDM 

#     Model object for the Ratcliff Diffusion Decision Model.

# # Fields
#     - `ν`: drift rate
#     - `α`: evidence threshold 
#     - `z`: mean starting point
#     - `τ`: non-decision time 
#     - `σ`: diffusion noise 
#     - `η`: across-trial drift rate standard deviation
#     - `sz`: range of starting point variability
#     - `st`: range of non-decision time
#     - `Δt`: time step 
# """
# @concrete mutable struct RatcliffDDM <: SequentialSamplingModel
#     ν
#     α
#     z
#     τ
#     σ
#     η
#     sz
#     st
#     Δt
# end

# """
# RatcliffDDM(; ν = 0.50,
#     η = 0.10,
#     α = 0.08,
#     z = 0.04,
#     sz = 0.02,
#     τ = 0.30,
#     st = .02,
#     σ = 0.10,
#     Δt = 0.001)

# Constructor for the Ratcliff Diffusion Decision Model. 
    
# # Keywords 
# - `ν=.50`: drift rates 
# - `α=0.08`: evidence threshold 
# - `z=0.04`: mean starting point
# - `τ=0.3`: non-decision time 
# - `σ=0.10`: diffusion noise 
# - `η=0.10`: across-trial drift rate standard deviation
# - `sz=0.02`: range of starting point variability
# - `st=0.02`: range of non-decision time
# - `Δt=.001`: time step 
# """
# function RatcliffDDM(; ν = 0.50,
#     η = 0.10,
#     α = 0.08,
#     z = 0.04,
#     sz = 0.02,
#     τ = 0.30,
#     st = .02,
#     σ = 0.10,
#     Δt = 0.001)
#     return RatcliffDDM(ν, η, α, z, sz, τ, st, σ, Δt)
# end

# function params(d::RatcliffDDM)
#     (d.ν, d.η, d.α, d.z, d.sz, d.τ, d.st, d.σ, d.Δt)    
# end