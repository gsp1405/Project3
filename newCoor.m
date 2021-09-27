function coor = newCoor(template, R, s, t)
coor = zeros(size(template));
    for i = 1 : size (template, 2)
        coor(:,i) = s * R * template (:,i) + t;
    end
end