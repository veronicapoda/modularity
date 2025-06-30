# create HyperSBM dataset 
require(HyperSBM)

######
# Scenario A
######

n0 <- 50
n_sizes <- c(n0, 2*n0, 3*n0, 4*n0,10*n0) # nb nodes 
M = c(2, 3) # hyperedge sizes
Q = 3 # nb clusters
gp_prop = rep(1/Q,Q) # cluster proportions

rho <- 1.7 # ratio of within-group /between-groups hyperedges - value is >1 so that the hypergraph is modular 
alpha0 <- 0.3
beta0 <- alpha0*sum(gp_prop^2)/(1-sum(gp_prop^2))/rho
c <- sum(gp_prop^2)/sum(gp_prop^3) *(1-sum(gp_prop^3))/(1-sum(gp_prop^2))

alpha2 <- c(alpha0,alpha0/2 ,alpha0/3, alpha0/4,alpha0/10)
beta2 <-  c(beta0, beta0/2,beta0/3 ,beta0/4,beta0/10)

# select i from 1 to 5 here
i=5
n <- n_sizes[i]
scenario = paste0("scenA",i,"/")
alpha = c(alpha2[i], c*alpha2[i]/n_sizes[i]) 
beta = c(beta2[i], beta2[i]/n_sizes[i])

nreps=25
#set.seed(1234)

for (r in 1:nreps){
  filename = paste0("HyperSBM/",scenario,"rep",r,"_he")
  myhyper=HyperSBM::sample_Hypergraph(n = n, M = M, Q = Q, pi = gp_prop, alpha = alpha, beta = beta, file_name = filename)
  load(paste0(filename, "_info.RData"))
  write.table(nodes_in_blocks, file = paste0("HyperSBM/",scenario,"rep",r, "_assign.txt"), row.names = FALSE, col.names = FALSE)
}  

######
# Scenario C - varying cluster sizes 
######

n0 <- 50
n_sizes <- c(n0, 2*n0, 3*n0, 4*n0,10*n0) # nb nodes 
M = c(2, 3) # hyperedge sizes
Q = 3 # nb clusters
gp_prop = c(1/(2*Q),1/Q,3/(2*Q)) # cluster proportions

rho <- 1.7 # ratio of within-group /between-groups hyperedges - value is >1 so that the hypergraph is modular 
alpha0 <- 0.3
beta0 <- alpha0*sum(gp_prop^2)/(1-sum(gp_prop^2))/rho
c <- sum(gp_prop^2)/sum(gp_prop^3) *(1-sum(gp_prop^3))/(1-sum(gp_prop^2))

alpha2 <- c(alpha0,alpha0/2 ,alpha0/3, alpha0/4,alpha0/10)
beta2 <-  c(beta0, beta0/2,beta0/3 ,beta0/4,beta0/10)

# select i from 1 to 5 here
i=5
n <- n_sizes[i]
scenario = paste0("scenC",i,"/")
alpha = c(alpha2[i], c*alpha2[i]/n_sizes[i]) 
beta = c(beta2[i], beta2[i]/n_sizes[i])

nreps=25
#set.seed(1234)

for (r in 1:nreps){
  filename = paste0("HyperSBM/",scenario,"rep",r,"_he")
  myhyper=HyperSBM::sample_Hypergraph(n = n, M = M, Q = Q, pi = gp_prop, alpha = alpha, beta = beta, file_name = filename)
  load(paste0(filename, "_info.RData"))
  write.table(nodes_in_blocks, file = paste0("HyperSBM/",scenario,"rep",r, "_assign.txt"), row.names = FALSE, col.names = FALSE)
}  



