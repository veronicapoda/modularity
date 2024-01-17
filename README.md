<h1 align="center">Modularity-based approaches for nodes clustering in hypergraphs</h1>
<p align="center"> <span style="font-size: 14px;"><em><strong>Veronica Poda &middot; Catherine Matias</strong></em></span> </p>
<br>


Contains the scripts to perform the experiments from [1] on testing and comparing modularity-based approaches for nodes clustering in hypergraphs.


## Methods
Our scripts use the following methods: 
 * AON-HMLL: This is the method from [2], whose implementation can be found at the project [Hypermodularity](https://github.com/nveldt/HyperModularity.jl)
 * CNM-like: This is the method from [3], whose implementation can be found at the project [CNM-like](https://gist.github.com/pszufe)
 * IRMM: This is the method from [4], whose implementation can be found at the [HyperNetx project](https://pnnl.github.io/HyperNetX/index.html)
 * LSR: This is the method from [5], whose implementation can also be found at the [HyperNetx project](https://pnnl.github.io/HyperNetX/index.html)

## Synthetic models for modular hypergraphs
We generated modular hypergraphs where ground truth clusters are known through the 3 following models:
  * HSBM: this model proposed in [6] relies on R package [hyperSBM](https://github.com/LB1304/HyperSBM) 
  * DCHSBM-like: this model proposed in [2] relies on the project [Hypermodularity](https://github.com/nveldt/HyperModularity.jl)
  * h-ABCD: this model proposed in [7] relies on [ABCDHypergraphGenerator](https://github.com/bkamins/ABCDHypergraphGenerator.jl) 

Parameter choices for the various scenarios
  * 




## References: 

  [1] Poda, V. and Matias, C. (2024). Comparison of modularity-based approaches for nodes clustering in hypergraphs. [ArXiV preprint](https://arxiv.org/abs/XXXXXX)
  [2] Chodrow, P. S., N. Veldt, and A. R. Benson (2021). Generative hypergraph clustering: From blockmodels to modularity. Science Advances 7(28), eabh1303 [Journal link](https://www.science.org/doi/10.1126/sciadv.abh1303)
  [3] Kamiński, B., V. Poulin, P. Prałat, P. Szufel, and F. Théberge (2019a). Clustering via hypergraph modularity. PLoS ONE 14(11), e0224307. [Journal link](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0224307).
  [4] Kumar, T., S. Vaidyanathan, H. Ananthapadmanabhan, S. Parthasarathy, and B. Ravindran (2020). Hypergraph clustering by iteratively reweighted modularity maximization. Appl. Netw. Sci. 5(1), 52. [Journal link](https://appliednetsci.springeropen.com/articles/10.1007/s41109-020-00300-3)
  [5] Kamiński, B., P. Prałat, and F. Théberge (2021). Community detection algorithm using hypergraph modularity. In R. M. Benito, C. Cherifi, H. Cherifi, E. Moro, L. M. Rocha, and M. Sales-Pardo (Eds.), Complex Networks & Their Applications IX, pp. 152–163. [Manuscript link](https://link.springer.com/chapter/10.1007/978-3-030-65347-7_13)
  [6] Brusa, L. and C. Matias (2022). Model-based clustering in simple hypergraphs through a stochastic blockmodel. [ArXiV preprint](https://arxiv.org/abs/2210.05983).
  [7] Kamiński, B., P. Prałat, and F. Théberge (2023). Hypergraph artificial benchmark for community detection (h-abcd). [ArXiV preprint](https://arxiv.org/abs/2210.15009).
  


  
  
