rgbimage=imread('input1.jpeg');
figure;
imshow(rgbimage);
title('Input Image in RGB');
image=rgb2gray(rgbimage);
figure;
imshow(image);
title('Input Image in Grayscale');
imwrite(image,'Input Image in Grayscale.jpg');


standard_deviation = input('Enter the value of sigma: ');

noise_image=imnoise(image,'Gaussian',0.04,0.003);
figure;
imshow(noise_image);
title('Noisy Image');
imwrite(noise_image,'Noisy Image.jpg');

double_noisy_image= im2double(noise_image);
[rows, cols]= size(double_noisy_image);

kernel_size= 11;    % 35 mod 4 = 3-->11x11 kernel
start_kernel= -(floor(kernel_size / 2));
gauss_filter_x=zeros(kernel_size,kernel_size);
gauss_filter_y=zeros(kernel_size,kernel_size);

current_x=start_kernel;
for i=1:11
    gauss_filter_x(:,i)=current_x;
    current_x=current_x+1;
end

current_y=start_kernel;
for i=1:11
    gauss_filter_y(i,:)=current_y;
    current_y=current_y+1;
end

boundary=zeros(rows+10, cols+10);
[rows_b, cols_b]= size(boundary);
boundary(6:rows_b-5,6:cols_b-5)=double_noisy_image(:,:);
filter=gaussian_filter(gauss_filter_x,gauss_filter_y,standard_deviation);

output=ones(size(double_noisy_image));

filtered=zeros(size(double_noisy_image));
for i=6:6+rows-1
     for j=6:6+cols-1
         data=boundary(i-5:i+5,j-5:j+5).*filter;
         data=sum(data(:));
         output(i,j)=data;
     end
end

 figure;
 imshow(output);
 title('Filtered Output Image');
 imwrite(output,'Filtered Output Image.jpg');

 function filterf=gaussian_filter(gauss_filter_x, gauss_filter_y,sigma)
    filterf=-(((gauss_filter_x.*gauss_filter_x)+(gauss_filter_y.*gauss_filter_y))/(2*(sigma^2)));
    filterf=exp(filterf);
    filterf=(1/(2*pi*(sigma^2))).*filterf;
end



