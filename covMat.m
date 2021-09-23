function CM = covMat(Im, com)
    ImDouble = Im;
    matrix = [0 0; 0 0];
    for i = 1:size(ImDouble, 1)
        for j = 1:size(ImDouble, 2)
            matrix = matrix + ImDouble(i, j) * ([i; j] - com) * ([i; j] - com)';
        end
    end
    CM = matrix / sum(ImDouble, 'all');
end