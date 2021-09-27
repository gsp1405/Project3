function CM = CenterOfMass(Im)
    %The following function takes an image and return a vector containing
    %coordinates of the center of mass of images
    ImDouble = Im;
    intensityVector = [0; 0];
    for i = 1:size(ImDouble, 1)
        for j = 1:size(ImDouble, 2)
            intensityVector = intensityVector + (ImDouble(i, j) * [i; j]);
        end
    end
    CM = round(intensityVector / sum(ImDouble, 'all'));
end