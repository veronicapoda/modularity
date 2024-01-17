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



############
### Function from Chodrow et al. to read data
### (slightly modified to accept more general forms of dataname)
############


function read_hypergraph_edges(dataname::String, maxsize::Int64=25, minsize::Int64=2)
    E = Dict{Integer, Dict}()
    open(string(dataname,"_he.txt")) do f
        for line in eachline(f)
            edge = [parse(Int64, v) for v in split(line, ',')]
            sort!(edge)
            if minsize <= length(edge) <= maxsize
                sz = length(edge)
                if !haskey(E, sz)
                    E[sz] = Dict{}()
                end
                E[sz][edge] = 1
            end
        end
    end
    return E
end



