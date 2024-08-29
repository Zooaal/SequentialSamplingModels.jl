"""
    LNR{T<:Real} <: AbstractLNR

# Parameters 

- `ν`: a vector of means in log-space
- `σ`: a scalar or vector of standard deviation parameter in log-space
- `τ`: a encoding-response offset

# Constructors

Two constructors are defined below. The first constructor uses positional arguments, and is therefore order dependent:

    LNR(ν, σ, τ)
    
The second constructor uses keywords with default values, and is not order dependent: 

    LNR(; ν = [-1, -2], σ = 1, τ = 0.20)

# Example

```julia
using SequentialSamplingModels
dist = LNR(ν = [-2,-3], σ = 1, τ = .3)
choice,rt = rand(dist, 10)
like = pdf.(dist, choice, rt)
loglike = logpdf.(dist, choice, rt)
```
# References

Rouder, J. N., Province, J. M., Morey, R. D., Gomez, P., & Heathcote, A. (2015). 
The lognormal race: A cognitive-process model of choice and latency with desirable 
psychometric properties. Psychometrika, 80(2), 491-513.
"""
struct LNR{T <: Real, T1 <: Union{<:T, Vector{<:T}}} <: AbstractLNR{T, T1}
    ν::Vector{T}
    σ::T1
    τ::T
end

function LNR(ν, σ, τ::T) where {T}
    _, _, τ = promote(ν[1], σ[1], τ)
    ν = convert(Vector{T}, ν)
    σ = isa(σ, Vector) ? convert(Vector{T}, σ) : convert(T, σ)
    return LNR(ν, σ, τ)
end

function params(d::AbstractLNR)
    return (d.ν, d.σ, d.τ)
end

LNR(; ν = [-1, -2], σ = 1, τ = 0.20) = LNR(ν, σ, τ)

function rand(rng::AbstractRNG, dist::AbstractLNR)
    (; ν, σ, τ) = dist
    x = @. rand(rng, LogNormal(ν, σ)) + τ
    rt, choice = findmin(x)
    return (; choice, rt)
end

function logpdf(d::AbstractLNR{T, T1}, r::Int, t::Float64) where {T, T1 <: Vector{<:Real}}
    (; ν, σ, τ) = d
    LL = 0.0
    for i ∈ 1:length(ν)
        if i == r
            LL += logpdf(LogNormal(ν[i], σ[i]), t - τ)
        else
            LL += logccdf(LogNormal(ν[i], σ[i]), t - τ)
        end
    end
    return LL
end

function logpdf(d::AbstractLNR{T, T1}, r::Int, t::Float64) where {T, T1 <: Real}
    (; ν, σ, τ) = d
    LL = 0.0
    for i ∈ 1:length(ν)
        if i == r
            LL += logpdf(LogNormal(ν[i], σ), t - τ)
        else
            LL += logccdf(LogNormal(ν[i], σ), t - τ)
        end
    end
    return LL
end

function pdf(d::AbstractLNR{T, T1}, r::Int, t::Float64) where {T, T1 <: Vector{<:Real}}
    (; ν, σ, τ) = d
    density = 1.0
    for i ∈ 1:length(ν)
        if i == r
            density *= pdf(LogNormal(ν[i], σ[i]), t - τ)
        else
            density *= (1 - cdf(LogNormal(ν[i], σ[i]), t - τ))
        end
    end
    return density
end

function pdf(d::AbstractLNR{T, T1}, r::Int, t::Float64) where {T, T1 <: Real}
    (; ν, σ, τ) = d
    density = 1.0
    for i ∈ 1:length(ν)
        if i == r
            density *= pdf(LogNormal(ν[i], σ), t - τ)
        else
            density *= (1 - cdf(LogNormal(ν[i], σ), t - τ))
        end
    end
    return density
end
