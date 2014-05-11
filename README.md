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
1.  Pinhole camera  
2.  Transformation, Homography, Cartesian/Homogeneous  
3.  MRF,clique  
4.  SIFT, RANSAC, fundamental matrix, epipole  
5.  generative & discriminative  
6.  Graphcut (max flow/min cut) / image segmentation  
7.  EM, hidden variable  
8.  Geometric Invariants  
9.  texture synthesis  
10. ML,MAP,Bayesian approach 
11. Snake/active contours  
12. Regression, Kernel Trick, Woodbury indentity  
13. Kalman Filter, Particle Filter,Tracking   

RANSAC  
MoG  
epipoles  
foundamentaial matrix  
Geometric invariant? P388 shape  
bug for 1st coursework: chol(mixGauss.cov(:,:,h),'lower'); 
