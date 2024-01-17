####### HyperNetX AUXILIARY ######

######
# Read a file whose rows contain the list of nodes forming a hyperedge and create dictionnary of the list of hyperedges
######
import csv

def read_data(data):
    dico = {}
    l = 0
    
    with open(data, mode='r') as csvfile:
        reader = csv.reader(csvfile)
        for rows in reader:
            r=[]
            for i in rows:
                r+=i.split(",")
            dico[l] = r
            l += 1
    return dico


#######
# Transform a partition (ie a list of sets of n nodes) into a vector of length n with the value of each node's cluster
#######
## L is a list giving a partition of nodes. Singletons are not in the list
## n is the total number of nodes (including singletons)
## option singletons has 2 values : "Single extra cluster" puts all non clustered nodes into a single cluster (labeled -1); option "Singleton clusters" puts all non clustered nodes into individual clusters


def partition2clust(L, n, singletons = "Single extra cluster"):
    # initialize L_hat
    if singletons == "Single extra cluster":
        L_hat = [-1]*n
    # associate nodes to clusters
    for clust in range(1,len(L)+1):
        for node in range(1,n+1):
            if str(node) in L[clust-1]:
                L_hat[node-1]=clust

    if singletons == "Singleton clusters":
        L_hat = [0]*n
        # associate nodes to clusters
        for clust in range(1,len(L)+1):
            for node in range(1,n+1):
                if str(node) in L[clust-1]:
                    L_hat[node-1]=clust
        k=0
        # add singleton clusters to nodes that are not in the partition L
        for node in range(0,n+1):
            if L_hat[node]==0:
                k += 1
                L_hat[node]=len(L)+k
    return L_hat


#######
# Transform a vector of node's clusters sets of n nodes into a vector of length n with the value of each node's cluster
#######
## Z is a vector of length n indicating the node cluster

def clust2partition(Z):
    L = {}
    for index, clust in enumerate(Z):
        if clust not in L:
            L[clust] = set([str(index + 1)])  # +1 pour les indices commençant à 1
        else:
            L[clust].add(str(index + 1))
    return [set(v) for v in L.values()]


