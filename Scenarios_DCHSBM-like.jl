using HyperModularity, StatsBase, SparseArrays
using DelimitedFiles
import Random
Random.seed!(1234)

include("DCHSBM-like_aux.jl")

model = "DCHSBM/"

##### COMMON SETTINGS #####
# Clusters
K=3      # nb clusters
cluster_sizes=ones(K) # Uniform clusters proportions

# Hyperedges sizes
rmax = 4  # max size of hyperedge + 1
rmin = 2

nreps = 25 # nb of replicates

##### CHOOSE INPUT VALUES #####
### Select appropriate scenarios below
######

### relative proportion of hyperedges of each size from r_min to r_max
r_sizes = [0.7, 0.3] # Scenarios A, B, G and H
r_sizes = [0.3, 0.7] # Scenario D


### Number of nodes and hyperedges
## Choices for scenarios A, D, G and H
scenario = "scenA1/"
scenario = "scenD1/"
scenario = "scenG1/"
scenario = "scenH1/"
n = 50   # nodes
m = 283  # nb hyperedges

scenario = "scenA2/"
#scenario = "scenD2/"
scenario = "scenG2/"
scenario = "scenH2/"
n = 100   # nodes
m = 575  # nb hyperedges

scenario = "scenA3/"
#scenario = "scenD3/"
scenario = "scenG3/"
scenario = "scenH3/"
n = 150   # nodes
m = 867  # nb hyperedges

scenario = "scenA4/"
#scenario = "scenD4/"
scenario = "scenG4/"
scenario = "scenH4/"
n = 200   # nodes
m = 1149  # nb hyperedges

scenario = "scenA5/"
#scenario = "scenD5/"
scenario = "scenG5/"
scenario = "scenH5/"
n = 500   # nodes
m = 2875  # nb hyperedges

scenario = "scenA6/"
#scenario = "scenD6/"
scenario = "scenG6/"
scenario = "scenH6/"
n = 1000   # nodes
m = 5750  # nb hyperedges


### Choices for scenarios B
scenario = "scenB1/"
n = 50   # nodes
m = 800  # nb hyperedges

scenario = "scenB2/"
n = 100   # nodes
m = 1600  # nb hyperedges

scenario = "scenB3/"
n = 150   # nodes
m = 2400  # nb hyperedges

scenario = "scenB4/"
n = 200   # nodes
m = 3200  # nb hyperedges

scenario = "scenB5/"
n = 500   # nodes
m = 8000  # nb hyperedges

scenario = "scenB6/"
n = 1000   # nodes
m = 16000  # nb hyperedges

##############

### within-cluster over between-cluter hyperedge ratio
rho = [1.7, 1.7] # scenarios A, B and D
rho = [2, 2] # scenario G
rho = [1.4, 1.4] # scenario H


##### COMMON SETTINGS #####
Ed = floor(Int,n/K)
correc = K .* [coefficient_binomial(Ed,2), coefficient_binomial(Ed,3)] ./ [coefficient_binomial(n,2), coefficient_binomial(n,3)]
pvals= (rho .* (1 .- correc) .- correc) ./ (1 .+ rho) ./ (1 .- correc) # vector of prob for each size of he to be in the same cluster
cluster_prefs = ones(K)    # relative proportions of within-cluster hyperedges from each cluster



dirname= string(model,scenario)
if !isdir(dirname)
    mkpath(dirname)
end


#####################################################

##### Generate hyperedges + true label vectors ######

for i in 1:nreps      
    He2n, EdgeList, E_lengths, deg, ground_truth = SimpleSyntheticHypergraph(n,m,K,pvals,rmin,rmax,cluster_sizes,r_sizes,cluster_prefs)
    
    ##### Edgelist #####
    filename = string(model,scenario,"rep",i,"_he.txt")
    io=open(filename,"w") do io
    writedlm(io,EdgeList, ',')
    end

    ##### True label vector ######
    filename = string(model,scenario,"rep",i,"_assign.txt")
    io=open(filename,"w") do io
    writedlm(io,ground_truth, ',')
    end
    

end
