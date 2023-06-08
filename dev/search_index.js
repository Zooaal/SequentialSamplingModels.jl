var documenterSearchIndex = {"docs":
[{"location":"api/","page":"api","title":"api","text":"Modules = [SequentialSamplingModels]\nOrder   = [:type, :function]","category":"page"},{"location":"api/#SequentialSamplingModels.DDM","page":"api","title":"SequentialSamplingModels.DDM","text":"DDM\n\nModel object for the Drift Diffusion Model. \n\nFields\n\nν: drift rate\nη: across-trial drift rate standard deviation\nα: evidence threshold \nz: mean starting point\nsz: range of starting point variability\nτ: non-decision time \nst: range of non-decision time\nσ: diffusion noise \nΔt: time step \n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.DDM-Tuple{}","page":"api","title":"SequentialSamplingModels.DDM","text":"DDM(; ν = 0.50,     η = 0.10,     α = 0.08,     z = 0.04,     sz = 0.02,     τ = 0.30,     st = .02,     σ = 0.10,     Δt = 0.001)\n\nConstructor for Drift Diffusion Model model. \n\nKeywords\n\nν=.50: drift rates \nη=0.10: across-trial drift rate standard deviation\nα=0.08: evidence threshold \nz=0.04: mean starting point\nsz=0.02: range of starting point variability\nτ=0.3: non-decision time \nst=0.02: range of non-decision time\nσ=0.10: diffusion noise \nΔt=.001: time step \n\n\n\n\n\n","category":"method"},{"location":"api/#SequentialSamplingModels.DiffusionRace","page":"api","title":"SequentialSamplingModels.DiffusionRace","text":"DiffusionRace(;ν, k, A, θ)\n\nAn object for the racing diffusion model. \n\nFields\n\nν: a vector of drift rates\nk: k = b - A where b is the decision threshold, and A is the maximum starting point\nA: the maximum starting point diffusion process, sampled from Uniform distribution\nθ: a encoding-motor time offset\n\nExample\n\nusing SequentialSamplingModels\ndist = DiffusionRace(;ν=[1,2], k=.3, A=.7, θ=.2)\ndata = rand(dist, 10)\nlike = pdf.(dist, data)\nloglike = logpdf.(dist, data)\n\nReferences\n\nTillman, G., Van Zandt, T., & Logan, G. D. (2020). Sequential sampling models without random between-trial variability:  The racing diffusion model of speeded decision making. Psychonomic Bulletin & Review, 27, 911-936.\n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.LBA","page":"api","title":"SequentialSamplingModels.LBA","text":"LBA(;τ, A, k, ν, σ=1.0)\n\nA model object for the linear ballistic accumulator.\n\nFields\n\nν: a vector of drift rates\nA: max start point\nk: A + k = b, where b is the decision threshold\nσ=1: drift rate standard deviation\nτ: a encoding-response offset\n\nExample\n\nusing SequentialSamplingModels\ndist = LBA(ν=[3.0,2.0], A = .8, k = .2, τ = .3) \nchoice,rt = rand(dist, 10)\nlike = pdf.(dist, choice, rt)\nloglike = logpdf.(dist, choice, rt)\n\nReferences\n\nBrown, S. D., & Heathcote, A. (2008). The simplest complete model of choice response time: Linear ballistic accumulation. Cognitive psychology, 57(3), 153-178.\n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.LCA","page":"api","title":"SequentialSamplingModels.LCA","text":"LCA\n\nModel object for the Leaky Competing Accumulator. \n\nFields\n\nν: drift rates \nα: evidence threshold \nβ: lateral inhabition \nλ: leak rate\nτ: non-decision time \nσ: diffusion noise \nΔt: time step \n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.LCA-Tuple{}","page":"api","title":"SequentialSamplingModels.LCA","text":"LCA(;ν = [2.5,2.0], \n    α = 1.5, \n    β = .20, \n    λ = .10, \n    τ = .30, \n    σ = 1.0, \n    Δt = .001)\n\nConstructor for Leaky Competing Accumulator model. \n\nKeywords\n\nν = [2.5,2.0]: drift rates \nα = 1.5: evidence threshold \nβ = .20: lateral inhabition \nλ = .10: leak rate\nτ = .30: non-decision time \nσ = 1.0: diffusion noise \nΔt = .001: time step \n\n\n\n\n\n","category":"method"},{"location":"api/#SequentialSamplingModels.LNR","page":"api","title":"SequentialSamplingModels.LNR","text":"LNR(;μ, σ, ϕ)\n\nA lognormal race model object \n\nFields\n\nμ: a vector of means in log-space\nσ: a standard deviation parameter in log-space\nϕ: a encoding-response offset\n\nExample\n\nusing SequentialSamplingModels\ndist = LNR(μ=[-2,-3], σ=1.0, ϕ=.3)\ndata = rand(dist, 10)\nlike = pdf.(dist, data)\nloglike = logpdf.(dist, data)\n\nReferences\n\nRouder, J. N., Province, J. M., Morey, R. D., Gomez, P., & Heathcote, A. (2015).  The lognormal race: A cognitive-process model of choice and latency with desirable  psychometric properties. Psychometrika, 80(2), 491-513.\n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.Wald","page":"api","title":"SequentialSamplingModels.Wald","text":"Wald Constructor\n\nυ: drift rate\nα: decision threshold\nθ: a encoding-response offset\n\nUsage\n\nusing SequentialSamplingModels\ndist = Wald(υ=3.0, α=.5, θ=.130)\nrt = rand(dist, 10)\nlike = pdf.(dist, rt)\nloglike = logpdf.(dist, rt)\n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.WaldA","page":"api","title":"SequentialSamplingModels.WaldA","text":"WaldA(;ν, k, A, θ)\n\nConstructor for Wald distribution \n\nFields\n\nν: drift rate\nk: k = b - A where b is the decision threshold, and A is the maximum starting point\nA: the maximum starting point diffusion process, sampled from Uniform distribution\nθ: a encoding-motor time offset\n\nUsage\n\nusing SequentialSamplingModels\ndist = WaldA(ν=.5, σ=1.0, ϕ=.3)\ndata = rand(dist, 10)\nlike = pdf.(dist, data)\nloglike = logpdf.(dist, data)\n\nReferences\n\nTillman, G., Van Zandt, T., & Logan, G. D. (2020). Sequential sampling models without random between-trial variability:  The racing diffusion model of speeded decision making. Psychonomic Bulletin & Review, 27, 911-936.\n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.WaldMixture","page":"api","title":"SequentialSamplingModels.WaldMixture","text":"WaldMixture Constructor\n\nυ: drift rate\nσ: standard deviation of drift rate\nα: decision threshold\nθ: a encoding-response offset\n\nUsage\n\nusing SequentialSamplingModels\ndist = WaldMixture(υ=3.0, σ=.2, α=.5, θ=.130)\nrt = rand(dist, 10)\nlike = pdf.(dist, rt)\nloglike = logpdf.(dist, rt)\n\nReferences\n\nSteingroever, H., Wabersich, D., & Wagenmakers, E. J. (2020).  Modeling across-trial variability in the Wald drift rate parameter.  Behavior Research Methods, 1-17.\n\n\n\n\n\n","category":"type"},{"location":"api/#SequentialSamplingModels.aDDM-Tuple{}","page":"api","title":"SequentialSamplingModels.aDDM","text":"aDDM(;ν1=5.0, ν2=4.0, α=1.0, z=α*.5, θ=.3, σ=.02, Δ=.0004)\n\nConstructor for attentional diffusion model object. \n\nKeywords\n\nν1=5.0: relative decision value for alternative 1\nν2=4.0: relative decision value for alternative 2\nα=1.0: evidence threshold \nz=0.0: initial evidence \nθ=.3: bias towards attended alternative (lower indicates more bias)\nσ=.02: standard deviation of noise in evidence accumulation\nΔ=.0004: constant of evidence accumulation speed (evidence per ms)\n\nReferences\n\nKrajbich, I., Armel, C., & Rangel, A. (2010). Visual fixations and the computation and comparison of  value in simple choice. Nature neuroscience, 13(10), 1292-1298.\n\n\n\n\n\n","category":"method"},{"location":"api/#SequentialSamplingModels.maaDDM-Tuple{}","page":"api","title":"SequentialSamplingModels.maaDDM","text":"maaDDM(; ν₁₁ = 4.0, \n        ν₁₂ = 5.0, \n        ν₂₁ = 5.0, \n        ν₂₂ = 4.0, \n        α = 1.0, \n        z = 0.0, \n        θ = .3, \n        ϕ = .50, \n        ω = .70, \n        σ = .02, \n        Δ = .0004)\n\nConstructor for multialternative attentional diffusion model object. \n\nIn this version of the model, the non-attended attribute of the non-attended alternative is doubly discounted. For example, the mean drift rate for the attribute 1 of alternative 1 is given by:\n\n    Δ * (ω * (ν₁₁ - θ * ν₂₁) + (1 - ω) * ϕ * (ν₁₂ - θ * ν₂₂))\n\nKeywords\n\nν₁₁=5.0: relative decision value for alternative 1, attribute 1\nν₁₂=4.0: relative decision value for alternative 1, attribute 2\nν₂₁=5.0: relative decision value for alternative 2, attribute 1\nν₂₂=4.0:  relative decision value for alternative 2, attribute 2\nα=1.0: evidence threshold \nz=0.0: initial evidence \nθ=.3: bias away from unattended alternative (lower indicates more bias)\nϕ=.50: bias away from unattended attribute \nω=.70: attribute weight\nσ=.02: standard deviation of noise in evidence accumulation\nΔ=.0004: constant of evidence accumulation speed (evidence per ms)\n\nReferences\n\nYang, X., & Krajbich, I. (2023). A dynamic computational model of gaze and choice in multi-attribute decisions.  Psychological Review, 130(1), 52.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.rand-Tuple{AbstractaDDM, Any, Vararg{Any}}","page":"api","title":"Base.rand","text":"rand(dist::aDDM, fixation, args...; kwargs...)\n\nGenerate a single simulated trial from the attention diffusion model.\n\nArguments\n\ndist: an attentional diffusion model object\nfixation: a function of the visual fixation process which returns 1 for alternative    and 2 for alternative 2\nargs...: optional positional arguments for the fixation function\n\nKeywords\n\nkwargs...: optional keyword arguments for the fixation function\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.rand-Tuple{AbstractaDDM, Int64, Any, Vararg{Any}}","page":"api","title":"Base.rand","text":"rand(dist::aDDM, n_sim::Int, fixation, args...; kwargs...)\n\nGenerate n_sim simulated trials from the attention diffusion model.\n\nArguments\n\ndist: an attentional diffusion model object\nn_sim::Int: the number of simulated trials\nfixation: a function of the visual fixation process which returns 1 for alternative    and 2 for alternative 2\nargs...: optional positional arguments for the fixation function\n\nKeywords\n\nkwargs...: optional keyword arguments for the fixation function\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.rand-Tuple{DDM, Int64}","page":"api","title":"Base.rand","text":"rand(dist::DDM, n_sim::Int)\n\nGenerate n_sim random choice-rt pairs for the Drift Diffusion Model.\n\nArguments\n\ndist: model object for the Drift Diffusion Model.\nn_sim::Int: the number of simulated choice-rt pairs  \n\n\n\n\n\n","category":"method"},{"location":"api/#Base.rand-Tuple{DDM}","page":"api","title":"Base.rand","text":"rand(dist::DDM)\n\nGenerate a random choice-rt pair for the Drift Diffusion Model.\n\nArguments\n\ndist: model object for the Drift Diffusion Model. \n\n\n\n\n\n","category":"method"},{"location":"api/#Base.rand-Tuple{LCA, Int64}","page":"api","title":"Base.rand","text":"rand(dist::LCA, n_sim::Int)\n\nGenerate n_sim random choice-rt pairs for the Leaky Competing Accumulator.\n\nArguments\n\ndist: model object for the Leaky Competing Accumulator.\nn_sim::Int: the number of simulated choice-rt pairs  \n\n\n\n\n\n","category":"method"},{"location":"api/#Base.rand-Tuple{LCA}","page":"api","title":"Base.rand","text":"rand(dist::LCA)\n\nGenerate a random choice-rt pair for the Leaky Competing Accumulator.\n\nArguments\n\ndist: model object for the Leaky Competing Accumulator. \n\n\n\n\n\n","category":"method"},{"location":"api/#SequentialSamplingModels.update-Tuple{aDDM, Any}","page":"api","title":"SequentialSamplingModels.update","text":"update(dist::aDDM, location)\n\nReturns the change evidence for a single iteration. \n\nArguments\n\ndist::aDDM: a model object for the attentional drift diffusion model\nlocation: an index for fixation location \n\n\n\n\n\n","category":"method"},{"location":"api/#SequentialSamplingModels.update-Tuple{maaDDM, Any}","page":"api","title":"SequentialSamplingModels.update","text":"update(dist::maaDDM, location)\n\nReturns the change evidence for a single iteration. \n\nArguments\n\ndist::maaDDM: a model object for the multiattribute attentional drift diffusion model\nlocation: an index for fixation location \n\n\n\n\n\n","category":"method"},{"location":"aDDM/#Attentional-Drift-Diffusion-Model","page":"Attentional Diffusion","title":"Attentional Drift Diffusion Model","text":"","category":"section"},{"location":"aDDM/#Example","page":"Attentional Diffusion","title":"Example","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":"using SequentialSamplingModels\nusing StatsBase\nusing Plots\n\nmutable struct Transition\n    state::Int \n    n::Int\n    mat::Array{Float64,2} \n end\n\n function Transition(mat)\n    n = size(mat,1)\n    state = rand(1:n)\n    return Transition(state, n, mat)\n end\n \n function attend(transition)\n     (;mat,n,state) = transition\n     w = mat[state,:]\n     next_state = sample(1:n, Weights(w))\n     transition.state = next_state\n     return next_state\n end\n\n model = aDDM()\n \n tmat = Transition([.98 .015 .005;\n                    .015 .98 .005;\n                    .45 .45 .1])\n\n choices,rts = rand(model, 10_000, attend, tmat)\n\n# rts for option 1\nrts1 = rts[choices .== 1]\n# rts for option 2 \nrts2 = rts[choices .== 2]\n# probability of choosing 1\np1 = length(rts1) / length(rts)\n# histogram of retrieval times\nhist = histogram(layout=(2,1), leg=false, grid=false,\n     xlabel=\"Reaction Time\", ylabel=\"Density\")\nhistogram!(rts1, subplot=1, color=:grey, bins = 50, norm=true, title=\"Choice 1\")\nhistogram!(rts2, subplot=2, color=:grey, bins = 50, norm=true, title=\"Choice 2\")\n# weight histogram according to choice probability\nhist[1][1][:y] *= p1\nhist[2][1][:y] *= (1 - p1)\nhist","category":"page"},{"location":"aDDM/#Load-Packages","page":"Attentional Diffusion","title":"Load Packages","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":"using SequentialSamplingModels\nusing StatsBase","category":"page"},{"location":"aDDM/#Define-Transition-Type","page":"Attentional Diffusion","title":"Define Transition Type","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":"mutable struct Transition\n    state::Int \n    n::Int\n    mat::Array{Float64,2} \n end\n\nfunction Transition(mat)\n    n = size(mat,1)\n    state = rand(1:n)\n    return Transition(state, n, mat)\n end","category":"page"},{"location":"aDDM/#Define-Transition-Matrix","page":"Attentional Diffusion","title":"Define Transition Matrix","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":"tmat = Transition([.98 .015 .005;\n                    .015 .98 .005;\n                    .45 .45 .1])","category":"page"},{"location":"aDDM/#Create-Model-Object","page":"Attentional Diffusion","title":"Create Model Object","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":" model = aDDM()","category":"page"},{"location":"aDDM/#Simulate-Model","page":"Attentional Diffusion","title":"Simulate Model","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":" choices,rts = rand(model, 10_000, attend, tmat)","category":"page"},{"location":"aDDM/#Plot-Simulation","page":"Attentional Diffusion","title":"Plot Simulation","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":"# rts for option 1\nrts1 = rts[choices .== 1]\n# rts for option 2 \nrts2 = rts[choices .== 2]\n# probability of choosing 1\np1 = length(rts1) / length(rts)\n# histogram of retrieval times\nhist = histogram(layout=(2,1), leg=false, grid=false,\n     xlabel=\"Reaction Time\", ylabel=\"Density\")\nhistogram!(rts1, subplot=1, color=:grey, bins = 50, norm=true, title=\"Choice 1\")\nhistogram!(rts2, subplot=2, color=:grey, bins = 50, norm=true, title=\"Choice 2\")\n# weight histogram according to choice probability\nhist[1][1][:y] *= p1\nhist[2][1][:y] *= (1 - p1)\nhist","category":"page"},{"location":"aDDM/#References","page":"Attentional Diffusion","title":"References","text":"","category":"section"},{"location":"aDDM/","page":"Attentional Diffusion","title":"Attentional Diffusion","text":"Krajbich, I., Armel, C., & Rangel, A. (2010). Visual fixations and the computation and comparison of value in simple choice. Nature neuroscience, 13(10), 1292-1298.","category":"page"},{"location":"#SequentialSamplingModels.jl","page":"home","title":"SequentialSamplingModels.jl","text":"","category":"section"},{"location":"","page":"home","title":"home","text":"Documentation for SequentialSamplingModels.jl","category":"page"}]
}
