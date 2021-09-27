%Load dataset for CT scan of frozen cadaver and MRI scan
data = load("visiblehuman.mat");
dataCT = data.head_frozen;
dataMRI = data.head_mri;

%Visualize the images
figure();
subplot(1, 2, 1);
imshow(dataCT), title("Frozen cadaver CT scan");
subplot(1, 2, 2);
imshow(dataMRI), title("MRI scan");

%Compute the center of mass for the 2 images using the implemented function
%CenterOfMass
CTDouble = im2double(dataCT);
MRIDouble = im2double(dataMRI);
comCT = CenterOfMass(CTDouble)
comMRI = CenterOfMass(MRIDouble)


% coompute the covariance matrix for two images using implemented function 
% covMat
covCT = covMat(CTDouble, comCT)
covMRI = covMat(MRIDouble, comMRI)
%Obtain eigenvalues and eigenvectors
[Vct,Dct] = eig(covCT)
[Vmri,Dmri] = eig(covMRI)
%Compute the 5 points in order to perform principal axes transform
pointCT = principalAxes(comCT, Vct, Dct)
pointMRI = principalAxes(comMRI, Vmri, Dmri)

%Visualize the points on the images
figure();
subplot(1, 2, 1);
imshow(dataCT), title("CT scan");
hold on;
plot(pointCT(2, 2:3), pointCT(1, 2:3), 'g', "LineWidth", 2)
plot(pointCT(2, 4:5), pointCT(1, 4:5), 'r', "LineWidth", 2)
plot(pointCT(2, :), pointCT(1, :), 'y.', "MarkerSize", 10)
hold off;
subplot(1, 2, 2);
imshow(dataMRI), title("MRI scan");
hold on;
plot(pointMRI(2, 2:3), pointMRI(1, 2:3), 'g', "LineWidth", 2)
plot(pointMRI(2, 4:5), pointMRI(1, 4:5), 'r', "LineWidth", 2)
plot(pointMRI(2, :), pointMRI(1, :), 'y.', "MarkerSize", 10)
hold off;

%Register MRI to CT using principal axes transform
[s_hat, R_hat, t_hat] = Similarity_Transf (pointCT, pointMRI);
X = (1:size(dataCT, 1))';
Y = (1:size(dataCT, 2))';
[xGrid, yGrid] = meshgrid(X, Y);
template = [xGrid(:), yGrid(:)]';
changedCoor = newCoor(template, R_hat, s_hat, t_hat);
reshapedX = reshape(changedCoor(2,:), size(yGrid));
reshapedY = reshape(changedCoor(1,:), size(xGrid));
MRI_to_CT = interp2(MRIDouble, reshapedX, reshapedY, 'spline');
image = twoChanIm(MRI_to_CT', CTDouble);
figure()
imshow(image ,[])

%Compute mutual information between the transformed images
im1 = dataCT;
im2 = MRI_to_CT';
MI = zeros(80);
for i = 1:size(MI, 1)
    for j = 1:size(MI, 1)
        changedCoor = newCoor(template, R_hat, s_hat, t_hat - [i-40 j-40]');
        reshapedX = reshape(changedCoor(2,:), size(yGrid));
        reshapedY = reshape(changedCoor(1,:), size(xGrid));
        MRI_to_CT = interp2(MRIDouble, reshapedX, reshapedY, 'spline');
        im2 = MRI_to_CT';
        jointHistogram = histogram2(double(im1(:)'), double(im2(:)'));
        jointPdf = jointHistogram / sum(jointHistogram(:));
        firstMarginalPdf = sum(jointPdf, 1);
        secondMarginalPdf = sum(jointPdf, 2);
        MI(i,j) = log(jointPdf(:) + eps )' * jointPdf(:) - ...
            log(firstMarginalPdf(:) + eps )' * firstMarginalPdf(:) - ...
            log(secondMarginalPdf(:) + eps )' * secondMarginalPdf(:);
    end
end

%Visualize the MI values
figure()
colormap('turbo')
imagesc(MI)
colorbar

%Identify the location of the maximum MI
[M, I] = max(max(MI, [], 1))
[M1, I1] = max(max(MI, [], 2))
%Visualize translated image
changedCoor = newCoor(template, R_hat, s_hat, t_hat - [I1-40 I-40]');
reshapedX = reshape(changedCoor(2,:), size(yGrid));
reshapedY = reshape(changedCoor(1,:), size(xGrid));
MRI_to_CT = interp2(MRIDouble, reshapedX, reshapedY, 'spline');
image = twoChanIm(MRI_to_CT', CTDouble);
figure()
imshow(image ,[])
