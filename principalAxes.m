function points = principalAxes(com, V, D)
    points = zeros(2, 5);
    points(:, 1) = com;
    points(:, 2) = com + round(sqrt(D(1,1)).* V(:,1));
    points(:, 3) = com - round(sqrt(D(1,1)).* V(:,1));
    points(:, 4) = com + round(sqrt(D(2,2)).* V(:,2));
    points(:, 5) = com - round(sqrt(D(2,2)).* V(:,2));
end