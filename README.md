MachineVision
=============

Need further review

####lab2 (Mixture of Gaussian):
c.EM algorithm finish

####lab5 (Dynamic Programming):  
a. Dynamic progamming along scanlines  
b. Apply dynamic programming in Dense Stereo Vision

####lab6 (Markov Random Fields):   
a. 5-node grid example in Markov random fields (12.1.1 in the book, page 229)  
b. Sampling from probability distributions using MCMC methods (get get gaussMeanXGivenY by conditional distributions)  
c. MAP inference for binary pairwise MRFs (Gibbs sampling)(new method with much less complexity added)

####lab7 (Models for transformations):  
practical1a. Calculate the homography that maps two sets of points to one another  
practical1b. Visual panoramas/image mosaicing  
practical2a. Learning intrinsic parameters in pinhole camera  
practical2b. Application (Augmented Reality)  
![lab7](https://github.com/mincongzhang/MachineVision/raw/master/labs/lab7/part2/result.jpg)
question: Don't understand the orthogonal Procrustes problem

    %Estimate first two columns of rotation matrix R from the first two columns of H using the SVD
    R = H(:,1:2);  
    [U,S,V] = svd(R);  
    R_hat = U*[1,0;0,1;0,0]*V';  

  


####Notes
Need to be reviewed:  
1.  ML,MAP,Bayesian approach   
2.  EM, hidden variable  
3.  generative & discriminative  
4.  Pinhole camera,calibrate,rectification  
5.  Transformation, Homography, Cartesian/Homogeneous  
6.  Directed/Undirected graphical model, potential function
7.  MRF,clique  
8.  Dynamic programming  
9.  SIFT, RANSAC, fundamental matrix, epipole  
10.  Graphcut (max flow/min cut) / image segmentation/ Texture synthesis  
11.  Geometric Invariants  
12. Snake/active contours  
13. Regression, Kernel Trick, Woodbury indentity  
14. Kalman Filter, Particle Filter,Tracking   
15. Procrustes analysis(mentioned in homography and pinhole camera), factor analysis

RANSAC  
MoG  
epipoles  
foundamentaial matrix  
Geometric invariant? P388 shape  
bug for 1st coursework: chol(mixGauss.cov(:,:,h),'lower'); 
