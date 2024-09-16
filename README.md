# r_pca

The following code has been programmed in R in order to perform image analysis using Pricipal Components Analysis.

## 1. Reading and visualizing the images:

Step 1: Create the initial parameters, some may be used later-on. Create the image visualization function, it will be used to visualize any image of our image set.
Step 2: Install the required packages, in this case, OpenImageR and ramify.
Step 3: Import those libraries to be able to use them.
Step 4: Create the image_directory variable, it will store the path to our image set.

![R Project setup](https://example.com/image.png)

Step 5: Read the images from the directory, save them in a list and combine them into a 3D array.
Step 6: Reshape data. The vector will be used for calculations and the matrix to paint the images.
Step 7: Visualize the assigned image (I).

![R Project image visualization](https://example.com/image.png)

The face will show under "Plots" in RStudio:
![R Project assigned face](https://example.com/image.png)

Step 8: Calculate the mean and standard-deviation faces. The calculation of the mean and standard deviation of the faces allows us to normalize each element so that we obtain the centered matrix, although in this case we are not going to perform the calculation manually since we have the scale function that does it automatically.

![R Project mean standard deviation face calculation](https://example.com/image.png)

The mean face:
![R Project mean face](https://example.com/image.png)

The standard deviation face:
![R Project standard deviation face](https://example.com/image.png)

The following steps, from 9 to 11, are mandatory in order to be able to perform the Principal Component Analysis (PCA) afterwards.

Step 9: Normalize data (Xs variable). Calculate and write down the mean of the normalized image.
As mentioned above, we normalize the data using the scale function since this function has the parameters center and scale, which contain the arithmetic mean and standard deviation respectively. If we wanted to do it by hand, we would have to perform the following operation:
        > The value of the element minus the mean, divided by the standard deviation.

Step 10: Calculate the mean of the assigned person, normalized.

![R Project data normalization](https://example.com/image.png)

Step 11: Calculate the covariance matrix of the normalized data. The covariance matrix is symmetric and measures the degree of linear relationship of the data set between each of the pairs of variables. In this case I use the cov() function for the calculation of this matrix, as it is much simpler.

The main diagonal terms correspond to the variance of each of the variables, although as we are passing normalized data, the diagonal is 1. The rest of the data, which is not in the main diagonal, corresponds to the covariances between pairs of data.

![R Project covariance matrix](https://example.com/image.png)

Step 12: We start with the Principal Component Analysis: we are going to use the covariance matrix and perform the calculations with the eigen function
This algorithm provides us with the eigenvalues and eigenvectors. We know from theory that these data constitute the principal components and, due to the characteristics of the covariance matrix (symmetric and positive), all eigenvalues are positive.

Step 13: Calculate and write the VAP (eigenvalue, eigenvalue) associated with the principal component P. The principal components are shown in descending order, from highest to lowest, representing the weight of each of them in the total composition (100%), i.e., the eigenvalues, added together, always give 100.

![R Project eigenvalues](https://example.com/image.png)

Step 14: Draw and attach the distribution of the cumulative variance (Y-axis) for each principal component (X-axis) with respect to the total variance of the data. principal component (X-axis) with respect to the total variance of the data. We store eigenvectors in their own variable.

Step 15: We perform a loop to calculate the cumulative variance. In the case of the eigenvalues, they represent the variance, so we add up the eigenvalues at each iteration to get the cumulative variance. We have to let it run through the 2576 eigenvalues, which takes a while. 

![R Project eigenvectors](https://example.com/image.png)

Step 16: Once the accumulated variance has been stored in the Y_P-axis variable, we proceed to make a graph. We see in it that the first 35 principal components absorb the most variance, while the rest are almost irrelevant. the rest are almost irrelevant.

![R Project cumulative variance](https://example.com/image.png)
![R Project cumulative variance plot](https://example.com/image.png)

Step 17: Display and attach the eigenface P (the eigenvalue associated with the principal component P). The objective of the PCA is to find a linear transformation (a linear application) such that the original data (X_vector) is transformed or projected into a new space by means of the product T = XP such that the covariance matrix Cx of the new data is diagonal. The first thing we do is to associate to the variable P the matrix of eigenvectors, because this matrix constitutes our P or linear application. And then we calculate the coordinates of the original data in the vector space generated.

![14 R Project eigenface associated to P](https://example.com/image.png)

Step 18: Visualize the eigenface P by means of the eigenvectors associated with the eigenvalue of P.

![15 R Project eigenface associated to P](https://example.com/image.png)

Step 19: Calculate and write the sum of all the coefficients of the eigenface P.

Step 20: How many principal components or “eigenfaces” (L) are needed, at least, to explain E% of the total variance of the data? 

What we are being asked here is to start reducing the dimensionality, since that is the main objective of the PCA. Therefore, we are going to consider an L, smaller than the m eigenvalues, that can give us a good enough approximation to the initial image quality with a much smaller weight. That is, we only select the largest L vectors. We are left with E% of the total variance of the data (60%), we look for the first value that immediately exceeds this 60% (L = eigenfaces). In this case it looks like we need to consider the first 7 Principal Components.

![15 R Project eigenfaces needed to explain variance](https://example.com/image.png)

Step 21: Calculate reconstruction error for each person X_err = Xs-Xs_rec. Once found, find the R2 coefficient that determines the quality of the reconstruction.

We take the L that we got in the previous section and select the eigenvectors indicated by that value (the first 7). Recall that the eigenvectors come from the covariance matrix, and that the eigenmatrix works as a linear application. Next, we calculate the reduced matrix T_reduc.

Having reduced the dimensionality, the P_reduc matrix is no longer invertible. That is to say, the original data contained in X cannot be completely recovered by the T_reduc matrix, and if we still perform the inversion, as is the case in this exercise, we must know that we will have a loss of information. This loss of information is called residual error.

![15 R Project reconstruction error residual error](https://example.com/image.png)

Step 22: Calculate the residual error. The R2 coefficient determines the quality of the reconstruction.

Step 23: Find which person obtains a higher and lower R2. Identify each person with the corresponding face number between [1, 40].  Visualize and attach the face of the people identified in the previous point. Discuss whether the people with the highest error have any particular facial features that might explain why they are facial traits that might explain why a higher error is obtained.

![15 R Project worst best reconstruction](https://example.com/image.png)

Best face reconstruction:

![15 R Project best reconstruction](https://example.com/image.png)

Worst face reconstruction:

![15 R Project worst reconstruction](https://example.com/image.png)
