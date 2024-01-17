###### Install packages if needed
#using Pkg
#Pkg.add("SimpleHypergraphs")
#Pkg.add("DelimitedFiles")

using DelimitedFiles
using ArgParse
include("CNM_like_auxiliary.jl")

# NB the results are random so we take a seed
import Random

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
    s.usage = "julia CNM_like_script.jl -m mod -s scen -n N"

    return ArgParse.parse_args(s)
end
######


# exemple of a command
# julia CNM_like_script.jl -m "HyperSBM/" -s "scenA1/" -n 25
# julia CNM_like_script.jl -m "DCHSBM/" -s "scenA6/" -n 25


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

    Random.seed!(27)


    ###### LOOP OVER DATASETS #####
    for i in 1:nreps
        print("\n Number of iteration: $i")
        
        # read true label vector
        global filename = string(model,scenario,"rep",i,"_assign.txt")
        global Z_true = vec(readdlm(filename, Int))
        global c_true = clust2partition(Z_true)
        K_true[i] = length(unique(c_true)) # true number of clusters
        
        runtimes[i] = @elapsed begin
            # Put data into appropriate format
            # extract the set of nodes for obtaining number of nodes
            global nodes = Vector{Int}()
            global filename = string(model,scenario,"rep",i, "_he.txt")
            open(filename,"r") do f
                for line in eachline(f)
                    append!(nodes, parse.(Int, split(line, ",")))
                end
            end
            global nodes= Set(nodes) # select unique nodes
            global n = maximum(nodes) # extract the number of nodes in the dataset
            
            # Insert a first row containing the list of nodes 1, ..., n
            global t = join(string.(1:n), ", ")
            global addfile = string(model,scenario,"rep",i, "_he_add.txt")
            write(addfile, t*"\n")
            # Concatenate the two .txt files
            open(addfile, "a") do f
                write(f, read(filename))
            end
        
            # Construct hypergraph
            global h = do_file(addfile)
            
            ########### Stochastic version of CNM-like algorithm ############
            global niter = max(size(h)[2]*3,1000)    # nb of iterations over hyperedges is max between default and 3*tot nb hyperedges
            global ha = SimpleHypergraphs.HypergraphAggs(h) # pre-compute arguments
            global res = find_comms(h,niter;ha)
            
        end
        
        # performance measures
        global Z_hat = partition2clust(res.bp,n)
        K_hat[i]= length(unique(Z_hat)) # estimated number of clusters
        
        # performance measures
        Q[i] = res.bm
        Q_true[i] = SimpleHypergraphs.modularity(h, c_true, ha)
        Ari[i] = ari(Z_hat,Z_true)
        
        # save partial results
        filename= string(model,scenario,"CNM_results_partial.txt")
        open(filename, "w") do f
            write(f, "ARI=$(string(Ari))"*"\n"*"CPU time = $runtimes"*"\n"*"Modularity = $Q"*"\n"*"GT_Mod = $Q_true"*"\n"*"K_hat = $K_hat"*"\n"*"K_true = $K_true")
        end
    end
    
    ##########
    # Correct the first computing time
    i=1
    runtimes[i] = @elapsed begin
        # Put data into appropriate format
        # extract the set of nodes for obtaining number of nodes
        global nodes = Vector{Int}()
        global filename = string(model,scenario,"rep",i, "_he.txt")
        open(filename,"r") do f
            for line in eachline(f)
                append!(nodes, parse.(Int, split(line, ",")))
            end
        end
        global nodes= Set(nodes) # select unique nodes
        global n = maximum(nodes) # extract the number of nodes in the dataset
        
        # Insert a first row containing the list of nodes 1, ..., n
        global t = join(string.(1:n), ", ")
        global addfile = string(model,scenario,"rep",i, "_he_add.txt")
        write(addfile, t*"\n")
        # Concatenate the two .txt files
        open(addfile, "a") do f
            write(f, read(filename))
        end
    
        # Construct hypergraph
        global h = do_file(addfile)
        
        ########### Stochastic version of CNM-like algorithm ############
        global niter = max(size(h)[2]*3,1000)    # nb of iterations over hyperedges is max between default and 3*tot nb hyperedges
        global ha = SimpleHypergraphs.HypergraphAggs(h) # pre-compute arguments
        global res = find_comms(h,niter;ha)
    end
    ##########

    ###### OUTPUT FILES #######
    filename= string(model,scenario,"CNM_results.txt")
    open(filename, "w") do f
        write(f, "ARI=$(string(Ari))"*"\n"*"CPU time = $runtimes"*"\n"*"Modularity = $Q"*"\n"*"GT_Mod = $Q_true"*"\n"*"K_hat = $K_hat"*"\n"*"K_true = $K_true")
    end

end


##################
##################
main()

