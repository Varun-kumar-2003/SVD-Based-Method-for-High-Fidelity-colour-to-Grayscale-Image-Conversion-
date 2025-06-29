clc
clear all
close all

% Load an input color image
inputImage = imread('pic.jpg'); 

% Convert to grayscale using a weighted average
grayscaleImage = 0.2989 * inputImage(:,:,1) + ... % Red channel
                 0.5870 * inputImage(:,:,2) + ... % Green channel
                 0.1140 * inputImage(:,:,3);     % Blue channel

% Convert to double for proper display and quality evaluation
grayscaleImage = double(grayscaleImage);

% Calculate NIQE and PIQE scores for the enhanced image
niqeScore = niqe(grayscaleImage);
piqeScore = piqe(grayscaleImage);

% Display the scores
fprintf('Enhanced NIQE Score: %.2f\n', niqeScore);
fprintf('Enhanced PIQE Score: %.2f\n', piqeScore);



%Gooch 
% Load color image
image = im2double(imread('pic.jpg')); 

% Convert to CIE L*a*b* color space
cform = makecform('srgb2lab');
lab_image = applycform(image, cform);
L = lab_image(:,:,1); % Luminance channel
A = lab_image(:,:,2); % a* (green-red) chrominance channel
B = lab_image(:,:,3); % b* (blue-yellow) chrominance channel

% Parameters
theta = 45; % Chrominance mapping angle in degrees
alpha = 10; % Chrominance contribution scaling
[rows, cols] = size(L);

% Precompute chrominance differences
theta_rad = deg2rad(theta); 
v_theta = [cos(theta_rad), sin(theta_rad)]; 

% Chrominance plane vector
chrominance_diff = alpha * (cos(theta_rad) * A + sin(theta_rad) * B);

% Adjust luminance based on chrominance differences
adjusted_L = L + chrominance_diff;

% Ensure adjusted luminance remains within valid bounds
adjusted_L = max(min(adjusted_L, 100), 0);

% Convert back to grayscale image
gray_image = adjusted_L / 100; % Normalize L channel for display

% Calculate NIQE and PIQE
niqe_score = niqe(gray_image);
piqe_score = piqe(gray_image);

% Display NIQE and PIQE Scores
fprintf('NIQE Score: %.2f\n', niqe_score);
fprintf('PIQE Score: %.2f\n', piqe_score);



%proposed method

% Load the color image
colorImage = imread('pic.jpg'); 
colorImage = im2double(colorImage); 

% Extract the R, G, and B channels
R = colorImage(:, :, 1);
G = colorImage(:, :, 2);
B = colorImage(:, :, 3);

% Compute basic grayscale using the ITU-R BT.601 standard
basicGrayscale = 0.2989 * R + 0.5870 * G + 0.1140 * B;

% Perform Singular Value Decomposition (SVD) on the grayscale
[U, S, V] = svd(basicGrayscale);

% Reconstruct the grayscale image with more singular values
maxSingularValues = min(size(S, 1), size(S, 2));

% Retain up to 600 singular values or fewer
k = min(600, maxSingularValues); 
svdGrayscale = U(:, 1:k) * S(1:k, 1:k) * V(:, 1:k)';

% Normalize the reconstructed image to range [0, 1] using norm
normValue = norm(diag(S));
svdGrayscale = mat2gray(svdGrayscale / normValue);

% Calculate NIQE and PIQE scores
niqeScore = niqe(svdGrayscale);
piqeScore = piqe(svdGrayscale);

% Display the original and processed grayscale images
figure;
subplot(1, 3, 1);
imshow(colorImage);
title('Original Color Image');

subplot(1, 3, 2);
imshow(basicGrayscale, []);
title('Basic Grayscale (Luminance)');

subplot(1, 3, 3);
imshow(svdGrayscale, []);
title(['Enhanced SVD-Based Grayscale']);

% Display NIQE and PIQE scores
fprintf('NIQE Score: %.2f\n', niqeScore);
fprintf('PIQE Score: %.2f\n', piqeScore);

% Save the final grayscale image
imwrite(svdGrayscale, 'svd_grayscale_image_enhanced.jpg');