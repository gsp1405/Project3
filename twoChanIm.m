function image = twoChanIm(red, green)
%Initialize the RGB image and visualization:
if size(red) == size(green)
    fprintf('size of images are not the same')
end
image = zeros ( size (red, 1) , size (red, 2) , 3 );
image (: ,: ,1) = red; % Red Channel
image (: ,: ,2) = green; %green channel
end