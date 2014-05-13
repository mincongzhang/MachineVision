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
question: Don't understand the orthogonal Procrustes problem(update: find solution at Page 336) 

    %Estimate first two columns of rotation matrix R from the first two columns of H using the SVD
    R = H(:,1:2);  
    [U,S,V] = svd(R);  
    R_hat = U*[1,0;0,1;0,0]*V';  

  


####Notes
syllabus:  
1.  ML,MAP,Bayesian approach   
2.  EM, hidden variable  
3.  Generative & Discriminative  
4.  Regression, Kernel Trick, Woodbury indentity(matrix inversion lemma)  
5.  Classification  
6.  Pinhole camera,calibrate,fundamental matrix, epipoles, rectification  
7.  Transformation, Homography, Cartesian/Homogeneous  
8.  Directed/Undirected graphical model, potential function  
9.  MRF,clique  
10. Dynamic programming  
11. SIFT, RANSAC, fundamental matrix, epipole  
12. Graphcut (max flow/min cut) / image segmentation/ Texture synthesis  
13. Geometric Invariants  
14. Snake/active contours, shape template, statistical shape model, landmarks  
15. Tracking, Kalman Filter, Particle Filter,Chapman-Kolmogorov relation  
16. Procrustes analysis(mentioned in homography and pinhole camera), Generalized Procrustes Analysis(Shape template, Page 398)   
17. factor analysis

Geometric invariant? P388 shape  
bug for 1st coursework: chol(mixGauss.cov(:,:,h),'lower'); 
