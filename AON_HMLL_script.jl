###### Install packages if needed
#using Pkg
#Pkg.add("HyperModularity")
#Pkg.add("SimpleHypergraphs")

using HyperModularity
using SimpleHypergraphs 
using DelimitedFiles
using ArgParse


include("AON_HMLL_auxiliary.jl")

######
function parse_commandline()
    s = ArgParse.ArgParseSettings()

    ArgParse.@add_arg_table! s begin
        "-m"
            arg_type = String
            required = true
            help = "generating model"
        "-s"
            arg_type = String
            required = true
            help = "scenario (parameter choice)"
        "-n"
            arg_type = Int64
            default = 0
            help  = "nb of repetitions"
    end
    s.usage = "julia AON_HMLL_script.jl -m mod -s scen -n N"

    return ArgParse.parse_args(s)
end
######

# exemple of a command
# julia AON_HMLL_script.jl -m "HyperSBM/" -s "scenA1/" -n 25
# julia AON_HMLL_script.jl -m "DCHSBM/" -s "scenA1/" -n 25



#######################
#######################
function main()
    parsed_args = parse_commandline()
    
    model = parsed_args["m"]
    scenario = parsed_args["s"]
    nreps =  parsed_args["n"]

    
    ###### INITIALIZATIONS OF VARIABLES ######
    Ari = zeros(Float64, nreps)
    runtimes = zeros(Float64, nreps)
    Q = zeros(Float64, nreps)
    Q_true = zeros(Float64, nreps)
    K_true = zeros(Int64, nreps)
    K_hat = zeros(Int64, nreps)
    

    ###### LOOP OVER DATASETS ######
    for i in 1:nreps
        print("\n Number of iteration: $i")
        
        # read true label vector
        filename = string(model,scenario,"rep",i,"_assign.txt")
        Z_true = vec(readdlm(filename, Int))
        K_true[i] = length(unique(Z_true)) # true number of clusters
        
        runtimes[i] = @elapsed begin
            # read data
            filename = string(model,scenario,"rep",i)
            E = read_hypergraph_edges(filename) # possible to add min and max hyperedge size
            n = maximum([maximum(e) for k in keys(E) for e in keys(E[k])])
            D = zeros(Int64, n)
            for (sz, edges) in E
                for (e, _) in edges
                    D[e] .+= 1
                end
            end
            maxedges = maximum(keys(E))
            for k in 1:maxedges
                if !haskey(E, k)
                    E[k] = Dict{}()
                end
            end
            # construct hypergraph
            N = 1:n
            H = hypergraph(N, E, D)
            
            ############ AON HMLL ################
            Z_hat = Simple_AON_Louvain(H, startclusters = "cliquelouvain") # By default randflag::Bool=false - the result is non random
        end

        # performance measures
        K_hat[i]= length(unique(Z_hat)) # estimated number of clusters
        
        ######## Extract omega parameters to compute modularity ######
        # compute initialisation corresponding to startclusters = "cliquelouvain"
        Z0 = HyperModularity.CliqueExpansionModularity(H,1.0) # default value gamma=1.0
        He2n, weights = HyperModularity.hypergraph2incidence(H)
        e2n = incidence2elist(He2n)
        d = 1.0*H.D # degree vector - coercion to float for compatibility with AON_louvain
        β, γ,omega = learn_omega_aon(e2n,weights,Z0,maxedges,d,n)
        
        Q[i] = modularity_aon(H,Z_hat,omega)
        Q_true[i] = modularity_aon(H,Z_true,omega)
       
        ######### Compute ARI #######
        Ari[i] = ari(Z_hat,Z_true)
        
        # save partial results
        filename= string(model,scenario,"AON_HMLL_results_partial.txt")
        open(filename, "w") do f
            write(f, "ARI=$(string(Ari))"*"\n"*"CPU time = $runtimes"*"\n"*"Modularity = $Q"*"\n"*"GT_Mod = $Q_true"*"\n"*"K_hat = $K_hat"*"\n"*"K_true = $K_true")
        end
    end
    
    ##########
    # Correct the first computing time
    i=1
    runtimes[i] = @elapsed begin
        # read data
        filename = string(model,scenario,"rep",i)
        E = read_hypergraph_edges(filename) # possible to add min and max hyperedge size
        n = maximum([maximum(e) for k in keys(E) for e in keys(E[k])])
        D = zeros(Int64, n)
        for (sz, edges) in E
            for (e, _) in edges
                D[e] .+= 1
            end
        end
        maxedges = maximum(keys(E))
        for k in 1:maxedges
            if !haskey(E, k)
                E[k] = Dict{}()
            end
        end
        # construct hypergraph
        N = 1:n
        H = hypergraph(N, E, D)
        
        ############ AON HMLL ################
        Z_hat = Simple_AON_Louvain(H, startclusters = "cliquelouvain") # By default randflag::Bool=false - the result is non random
    end
    #########
    

    ###### OUTPUT FILES #######
    filename= string(model,scenario,"AON_HMLL_results.txt")
    open(filename, "w") do f
        write(f, "ARI=$(string(Ari))"*"\n"*"CPU time = $runtimes"*"\n"*"Modularity = $Q"*"\n"*"GT_Mod = $Q_true"*"\n"*"K_hat = $K_hat"*"\n"*"K_true = $K_true")
    end

end


##################
##################
main()
