% MAIN
warning('off');
Initialization = [1 1 4];
addpath '/home/ankush/Folder/Tracking/nl_mugII_s5';
aviobj = avifile('nl_mugII_s5LK.avi','compression','None');

[a]=textread('nl_mugII_s5.txt','%s');
[M,N]=size(a);
Initiate = imread(a{1,1});
Initiate = im2double(rgb2gray(Initiate));
[X_im, Y_im] = size(Initiate);
imshow(Initiate)
rect = getrect;
iter = 10;
x_min = rect(1);
y_min = rect(2);
width = rect(3);
height = rect(4);
blockSize = [width,height];
x_max = x_min + width-1;
y_max = y_min + height-1;
Templt = im2double(Initiate(y_min:y_max, x_min:x_max));
SSD1= [];
for i = 2:M-1
Im1 = imread(a{i,1}); Im2 = imread(a{i+1,1});
Im1 = im2double(rgb2gray(Im1)); Im2 = im2double(rgb2gray(Im2));
temp_dt = Im2 - Im1;
temp_dt= temp_dt(y_min:y_max, x_min:x_max);
[img_mono_dx,img_mono_dy] = gradient(Im1);
temp_dx = img_mono_dx(y_min:y_max, x_min:x_max);
temp_dy = img_mono_dy(y_min:y_max, x_min:x_max);
temp_dt1 = -temp_dt(:);
temp_dx1 = temp_dx(:);
temp_dy1 = temp_dy(:);
temp = [temp_dx1,temp_dy1] \ temp_dt1;
delta_x = temp(1);
delta_y = temp(2);
x_min = round(x_min + delta_x);
x_max = x_min + width-1;
y_min = round(y_min + delta_y);
y_max = y_min + height-1;
    % Use Lucas Kanade method to modify the translation
    % Some of this part refers to codes by Iain Matthews, etc
    % Compute image gradients

     [img_totrk_dx, img_totrk_dy]= gradient(Im2);
   % Evaluate Jacobian
    jac_one = ones(height,width);
    jac_zero = zeros(height,width);
    dw_dt = [jac_one,jac_zero;jac_zero,jac_one];
    IWarp = Im2(y_min:y_max, x_min:x_max);
    % Compute error image
    img_error = Templt - IWarp;
    SD = img_error.^2;
    SSD = sum(SD(:));
    SSD= cat(1,SSD1,SSD);
    for j = 1:iter
        % Compute the warp image
        
        % Warp gradient images
        Warped_dx = temp_dx;
        Warped_dy = temp_dy;
        % Compute Steepest Descent images
        SD_img = zeros(height,width*2);
                SD_img(:,1:width) = Warped_dx .* dw_dt(1:height,1:width) + Warped_dy .* dw_dt(height+1:end,1:width);
        SD_img(:,width+1:end) = Warped_dx .* dw_dt(1:height,width+1:end) + Warped_dy .* dw_dt(height+1:end,width+1:end);
        % Compute Hessian and inverse
        H = zeros(2,2);
        for k = 1:2
            h1 = SD_img(:,((k-1)*width+1):((k-1)*width)+width);
            for l = 1:2
                h2 = SD_img(:,((l-1)*width+1):((l-1)*width+width));
                H(l,k) = sum(sum(h1.*h2));
            end
        end
        H_inv = inv(H);
        % Compute steepest descent parameter updates
        sd_pu = zeros(2,1);
        for k = 1:2
            sd_pu(k) = sum(sum(SD_img(:,((k-1)*width+1):((k-1)*width+width)) .* img_error));
        end
        % Compute delta p
        delta_p = H_inv * sd_pu;
        % update position
        x_min = round(x_min + delta_p(1));
        x_max = x_min + width - 1;
        y_min = round(y_min + delta_p(2));
        y_max = y_min + height - 1;    
    
    end
    pos_xy = [x_min,y_min];
    
 % Drow the picture or store the values
 % Here I just store the values
    
    fig = figure;
    imshow((Im2));
    rectangle('position',[pos_xy(1,1), pos_xy(1,2), width, height],'EdgeColor','r','LineWidth',3);
    F = getframe(fig);
    close all;
    aviobj = addframe(aviobj,F);
end
    aviobj = close(aviobj);
