############
### Quality of clustering
############

using Clustering

# Adjusted Rand Index
function ari(x,y)
    evaluations = randindex(x, y)
    ari = evaluations[1]
    return ari
end



####### CNM-like AUXILIARY ########
## Functions from the page https://gist.github.com/pszufe/02666497d2c138d1b2de5b7f67784d2b

using SimpleHypergraphs


# Function to read data and construct Hypergraph object
function do_file(name::String)
    f = open(name)
    line = readline(f) # here we read the first line of the file - should be 1,2,...,n
    h = SimpleHypergraphs.Hypergraph{Bool,Int}(0,0) # create empty hypergraph

    for v_meta in parse.(Int,(split(line,",")))
        add_vertex!(h,v_meta=v_meta)  # add vertices from first line in h
    end
    
    for line in eachline(f) # then continue reading the lines, but starting from the second one !
        x = parse.(Int,(split(line,",")))
        inds = x
        add_hyperedge!(h;vertices=Dict(inds .=> true))
    end
    close(f)
    return h
end



function find_first(c::Array{Set{Int}}, vals)
    for i in 1:length(c)
        for v in vals
            v in c[i] && return i
        end
    end
end



function find_comms(h, nreps::Int=1000; ha = SimpleHypergraphs.HypergraphAggs(h))
    # Initialize modularity
    best_modularity = 0
    # Initialize partition with all vertices in its own part
    comms = [Set(i) for i in 1:nhv(h)]  # return the list of vertices in the hypergraph h
    mod_history = Vector{Float64}(undef, nreps)
    
    
    for rep in 1:nreps
        
        # Randomly select an hyperedge (using simplified stochastic algorithm version)
        he = rand(1:nhe(h))
        vers = collect(keys(getvertices(h, he))) #Get corresponding vertices
        c = deepcopy(comms)   #copy mutuable object
        
        # Compute partition obtained when merging all parts in 'c' touched by 'he'
        i0 = find_first(c, vers)        
        max_i = length(c)
        i_cur = i0
        #print(i_cur)
        #print(max_i)
        while i_cur < max_i
            i_cur += 1
            if length(intersect(c[i_cur],vers)) > 0
                union!(c[i0], c[i_cur])
                c[i_cur]=c[max_i]
                max_i += -1
            end
        end
        resize!(c,max_i)
        
        # Compute modularity
        m = SimpleHypergraphs.modularity(h, c, ha)
        if m > best_modularity
            best_modularity = m
            
            # update partition
            comms = c
        end    
                
        mod_history[rep] = best_modularity
    end
    return (bm=best_modularity, bp=comms, mod_history=mod_history)
end


# Transforms the output bp (bestpartition) of find_comms into a clustering vector
# P is the best partition
# n is the number of nodes (needed because there maight be nodes which are not clustered in P)

function partition2clust(P, n, singletons = "Single extra cluster")
    if singletons == "Single extra cluster"
        Z = fill(-1, n)
    end
    
    for clust in 1:length(P)
        for node in 1:n
            if node in P[clust]
                Z[node] = clust
            end
        end
    end
    
    if singletons == "Singleton clusters"
        Z = fill(0, n)
        
        for clust in 1:length(P)
            for node in 1:n
                if node in P[clust]
                    Z[node] = clust
                end
            end
        end
        
        # nodes which are no in the partition are put in separate individual clusters
        k = 0
        for node in 1:n
            if Z[node] == 0
                k += 1
                Z[node] = length(P) + k
            end
        end
    end
    
    return Z
end


#######
# Transform a vector of node's clusters sets of n nodes into a vector of length n with the value of each node's cluster
#######
## Z is a vector of length n indicating the node cluster



function clust2partition(Z)
    C = maximum(Z)  # Maximal number of clusters
    P = Vector{Set{Int}}(undef, C)
    
    for clust in 1:C
        indices = findall(x -> x == clust, Z)  # Find indices corresponding to clust
        P[clust] = Set(indices)  # Create a partition based on those indices
    end
    
    return P
end
