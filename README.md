[![DOI](https://zenodo.org/badge/744470608.svg)](https://zenodo.org/doi/10.5281/zenodo.10816978)

<h1 align="center">Modularity-based approaches for nodes clustering in hypergraphs</h1>
<p align="center"> <span style="font-size: 14px;"><em><strong>Veronica Poda &middot; Catherine Matias</strong></em></span> </p>
<br>


Contains the scripts to perform the experiments from [1] on testing and comparing modularity-based approaches for nodes clustering in hypergraphs.

## Requirements 
To run those scripts and perform our experiments, you will need 
 * R and the package [`hyperSBM`](https://github.com/LB1304/HyperSBM)
 * Python and the libraries  [`hypernetx`](https://pnnl.github.io/HyperNetX/index.html), [`igraph`](https://igraph.org/python/tutorial/0.9.8/install.html)
 * Julia and the libraries [`Clustering`](https://juliastats.org/Clustering.jl/stable/), [`SimpleHypergraphs`](https://github.com/pszufe/SimpleHypergraphs.jl), [`ABCDHypergraphGenerator`](https://github.com/bkamins/ABCDHypergraphGenerator.jl)    


## Synthetic models for modular hypergraphs
We generated modular hypergraphs where ground truth clusters are known through the 3 following models:
  * HSBM: this model proposed in [6] relies on R package [hyperSBM](https://github.com/LB1304/HyperSBM). Under this model, we generated scenarios A and C (see file Scenarios_HyperSBM.R)  
  * DCHSBM-like: this model proposed in [2] relies on the project [Hypermodularity](https://github.com/nveldt/HyperModularity.jl). Under this model, we generated scenarios A, B, D, E and F (see Scenarios_DCHSBM-like.jl file) 
  * h-ABCD: this model proposed in [7] relies on [ABCDHypergraphGenerator](https://github.com/bkamins/ABCDHypergraphGenerator.jl). After installing this library, go to the directory `ABCDHypergraphGenerator.jl-main/utils` to run the commands below. Under this model, we generated scenarios A and Z as follows:
      - Scenarios A use the following command (changing the value of sample size n, the folder name scenA1, repetition number rep1 and the file same_size_50.txt	that contains the sizes of the cluster depending on the total sample size n)
```
julia --project abcdh.jl -n 50 -d 2.07,1,32 -c same_size_50.txt	-x 0.37 -q 0.0,0.66,0.34 -w :strict -o "hABCD/scenA1/rep1"
```
   * and
      - Scenarios Z use the following command (changing the value of sample size n, the folder name scenZ1 and repetition number rep1)
```
julia --project abcdh.jl -n 50 -d 2.5,1,10 -c 1.5,10,80	-x 0.5 -q 0.0,0.6,0.4 -w :linear -o "hABCD/scenZ1/rep1"
```
 
All the generated datasets are stored in directories of the form `model/scenAi/` where model= HyperSBM or DCHSBM or hABCD and scenarios take different values (see [1] for the scenario's description).    

## Methods
Our scripts use the following methods: 
 * AON-HMLL: This is the method from [2], whose implementation can be found at the project [Hypermodularity](https://github.com/nveldt/HyperModularity.jl). To run the script, simply use a command like
```
julia AON_HMLL_script.jl -m "HyperSBM/" -s "scenA1/" -n 25
```

 * CNM-like: This is the method from [3], whose implementation can be found at the project [SimpleHypergraphs](https://gist.github.com/pszufe). To run the script, simply use a command like
```
julia CNM_like_script.jl -m "DCHSBM/" -s "scenA1/" -n 25
```

 * IRMM: This is the method from [4], whose implementation can be found at the [HyperNetx project](https://pnnl.github.io/HyperNetX/index.html). To run the script, simply use a command like
```
python IRMM_script.py -m "HyperSBM/" -s "scenA2/" -n 25
```
 * LSR: This is the method from [5], whose implementation can also be found at the [HyperNetx project](https://pnnl.github.io/HyperNetX/index.html). To run the script, simply use a command like
```
python LSR_script.py -m "HyperSBM/" -s "scenA5/" -n 25
```




## References: 
 1. Poda, V. and Matias, C. (2024). Comparison of modularity-based approaches for nodes clustering in hypergraphs. Submitted. [Preprint](https://hal.science/hal-04414337)
 2. Chodrow, P. S., N. Veldt, and A. R. Benson (2021). Generative hypergraph clustering: From blockmodels to modularity. Science Advances 7(28), eabh1303 [Journal link](https://www.science.org/doi/10.1126/sciadv.abh1303)
 3. Kamiński, B., V. Poulin, P. Prałat, P. Szufel, and F. Théberge (2019a). Clustering via hypergraph modularity. PLoS ONE 14(11), e0224307. [Journal link](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0224307).
 4. Kumar, T., S. Vaidyanathan, H. Ananthapadmanabhan, S. Parthasarathy, and B. Ravindran (2020). Hypergraph clustering by iteratively reweighted modularity maximization. Appl. Netw. Sci. 5(1), 52. [Journal link](https://appliednetsci.springeropen.com/articles/10.1007/s41109-020-00300-3)
 5. Kamiński, B., P. Prałat, and F. Théberge (2021). Community detection algorithm using hypergraph modularity. In R. M. Benito, C. Cherifi, H. Cherifi, E. Moro, L. M. Rocha, and M. Sales-Pardo (Eds.), Complex Networks & Their Applications IX, pp. 152–163. [Manuscript link](https://link.springer.com/chapter/10.1007/978-3-030-65347-7_13)
 6. Brusa, L. and C. Matias (2022). Model-based clustering in simple hypergraphs through a stochastic blockmodel. [ArXiV preprint](https://arxiv.org/abs/2210.05983).
 7. Kamiński, B., P. Prałat, and F. Théberge (2023). Hypergraph artificial benchmark for community detection (h-abcd). [ArXiV preprint](https://arxiv.org/abs/2210.15009).
  


  
  
