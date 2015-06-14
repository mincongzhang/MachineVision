MachineVision
=============


##lab2 (Mixture of Gaussian):
c.EM algorithm

EM algorithm v.s. K-means  
http://www.cs.colorado.edu/~grudic/teaching/CSCI4202/EM_algorithm.pdf  
<!-- ![EM](https://github.com/mincongzhang/MachineVision/raw/master/EMvsKMEANS.jpg) -->

<img src="https://github.com/mincongzhang/MachineVision/raw/master/EMvsKMEANS.jpg" alt="EM" title="EM" height="400"/>

##lab5 (Dynamic Programming):  
a. Dynamic progamming along scanlines  
b. Apply dynamic programming in Dense Stereo Vision
(still many noises, need further improvement, see P219 results)


##lab6 (Markov Random Fields):   
a. 5-node grid example in Markov random fields (12.1.1 in the book, page 229)  
b. Sampling from probability distributions using MCMC methods (get get gaussMeanXGivenY by conditional distributions)  
c. MAP inference for binary pairwise MRFs (Gibbs sampling)(new method with much less complexity added)

##lab7 (Models for transformations):  
practical1a. Calculate the homography that maps two sets of points to one another  
practical1b. Visual panoramas/image mosaicing(A much faster way for mapping is created)
practical2a. Learning intrinsic parameters in pinhole camera  
practical2b. Application (Augmented Reality)  
<img src="https://github.com/mincongzhang/MachineVision/raw/master/panorama.jpg" alt="panorama" title="panorama" height="250"/>
<img src="https://github.com/mincongzhang/MachineVision/raw/master/augmented_reality.jpg" alt="augmented_reality" title="augmented_reality" width="500"/>
<!-- ![lab7](https://github.com/mincongzhang/MachineVision/raw/master/panorama.jpg)
![lab7](https://github.com/mincongzhang/MachineVision/raw/master/augmented_reality.jpg)  
-->
Question: Don't understand the orthogonal Procrustes problem(update: find solution at Page 336) 

    %Estimate first two columns of rotation matrix R from the first two columns of H using the SVD
    R = H(:,1:2);  
    [U,S,V] = svd(R);  
    R_hat = U*[1,0;0,1;0,0]*V';  

##lab9 (Condensation filter):  

<img src="https://github.com/mincongzhang/MachineVision/raw/master/condensation.jpg" alt="condensation" title="condensation" width="500"/>  
<img src="https://github.com/mincongzhang/MachineVision/raw/master/condensation2.jpg" alt="condensation2" title="condensation2" width="500"/>

  
##coursework 1:  
1. Apple detection (MoG model & EM algorithm)  

<img src="https://github.com/mincongzhang/MachineVision/raw/master/apple.jpg" alt="apple" title="apple" width="500"/>  
<img src="https://github.com/mincongzhang/MachineVision/raw/master/apple2.jpg" alt="apple2" title="apple2" width="500"/>


*bug fixed for 1st coursework: 

    chol(mixGauss.cov(:,:,h),'lower'); 

##coursework 2 (Augmented reality tracking):

<img src="https://github.com/mincongzhang/MachineVision/raw/master/augmented_reality.jpg" alt="augmented_reality" title="augmented_reality" width="500"/>


Review is still needed (Dense Stereo Vision noises, regression and classification).

##Syllabus for revision
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
16. Procrustes analysis(mentioned in homography/pinhole camera), Generalized Procrustes Analysis(Shape template, Page 398)  
17. factor analysis
