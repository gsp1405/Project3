function avg_pt = average_point ( landmark_set )
    % In p dimensions , landmark_set should be a p x N matrix
    [p, N] = size ( landmark_set );

    avg_pt = zeros (p ,1) ;

    for i = 1 : N
        avg_pt = avg_pt + landmark_set (:,i);
    end
    avg_pt = avg_pt / N;
end