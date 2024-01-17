from time import time

import hypernetx as h
import hypernetx.algorithms.hypergraph_modularity as hmod

from IRMM_auxiliary import *
from sklearn.metrics import adjusted_rand_score

from igraph import Graph # needed to compute graph modularity
import numpy as np
import argparse


######
def parse_commandline():
    s = argparse.ArgumentParser()

    s.add_argument('-m', type=str, required=True, help='model')
    s.add_argument('-s', type=str, required=True, help='scenario')
    s.add_argument('-n', type=int, default=0, help='nb of repetitions (default 0)')

    s.usage = "python IRMM_script.py -m mod -s scen -n N"
    args = s.parse_args()

    return args
######

# exemple of a command
# python IRMM_script.py -m "HyperSBM/" -s "scenA1/" -n 25



def main():

    parsed_args = parse_commandline()

    model = parsed_args.m
    scenario = parsed_args.s
    nreps = parsed_args.n

    ###### INITIALIZATIONS OF VARIABLES ######
    ari = [0]*nreps
    runtimes = [0]*nreps
    Q = [0]*nreps
    Q_true = [0]*nreps
    K_true = [0]*nreps
    K_hat = [0]*nreps


    for i in range(1,nreps+1):
        print(f'\n Number of iteration: {i}')
        
        # read true label vector
        Z_true =[]
        with open(f'{model}{scenario}' + "rep" + f'{i}' + "_assign.txt") as f:
            lines= f.readlines()
            for line in lines:
                Z_true.append(int(line.strip()))
        K_true[i-1] = len(np.unique(Z_true)) # true number of clusters
        L_true = clust2partition(Z_true)
        
        tic = time()
        # read data and construct hypergraph
        dict_from_csv = read_data(f'{model}{scenario}' + "rep" + f'{i}' + "_he.txt")
        H = h.Hypergraph(dict_from_csv)
        HG = hmod.precompute_attributes(H)

        K = hmod.kumar(HG) # IRMM
        
        n=len(Z_true)
        Z_hat = partition2clust(K,n)
        K_hat[i-1] = len(np.unique(Z_hat)) # estimated number of clusters
        
        # performance measures
        runtimes[i-1] = time() - tic
        G= hmod.two_section(HG)
        Q[i-1] = G.modularity(Z_hat,directed=False)
        Q_true[i-1] = G.modularity(Z_true,directed=False)
        ari[i-1] = adjusted_rand_score(Z_true, Z_hat)
        
        # save partial results
        filename= model + scenario + "IRMM_results_partial.txt"
        with open (filename, 'w') as file:
            file.write(f"ARI = {str(ari)}" + "\n" + f"CPU time = {runtimes}" + "\n" + f"Modularity = {Q}" + "\n" + f"GT_Mod = {Q_true}"+ "\n" + f"K_hat = {K_hat}"+ "\n" + f"K_true = {K_true}")
        


    ##### OUTPUT FILES ######

    filename= model + scenario + "IRMM_results.txt"
    with open (filename, 'w') as file:
        file.write(f"ARI = {str(ari)}" + "\n" + f"CPU time = {runtimes}" + "\n" + f"Modularity = {Q}" + "\n" + f"GT_Mod = {Q_true}"+ "\n" + f"K_hat = {K_hat}"+ "\n" + f"K_true = {K_true}")

##################
##################
main()

