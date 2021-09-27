function [s_hat , R_hat , t_hat ] = Similarity_Transf(template_set, reference_set)
    % Note : reference_set and template_set should be a p x N matrix ,
    % where N = No. landmark points and p = dimension of the points
    [p,N] = size(reference_set);
    avg_x = average_point(template_set);
    avg_y = average_point(reference_set);
    H = zeros(p,p);
    % For each Landmark pair :
    for i = 1 : N
        xi = template_set(:,i) ; 
        centered_xi = xi - avg_x ;
        yi = reference_set(:,i); 
        centered_yi = yi - avg_y ;
        H = H + centered_xi * ( centered_yi');
    end
    % Note : [U,D,V] = svd (H) performs a singular value decomposition of matrix H, such that H = U*D*V'
    % Left singular vectors , returned as the columns of the matrix U
    % Singular values , returned as the diagonal of the matrix D
    % Right singular vectors , returned as the columns of the matrix V
    [U,D,V] = svd(H);

    R_hat = V * diag([ones(1, p-1), det(V*U)]) * U';
    s_hat_num = 0; s_hat_denom = 0;
    for i = 1 : N
        xi = template_set (:,i) ; 
        centered_xi = xi - avg_x ;
        yi = reference_set (:,i); 
        centered_yi = yi - avg_y ;
        s_hat_num = s_hat_num + centered_xi' * R_hat' * centered_yi ;
        s_hat_denom = s_hat_denom + centered_xi' * centered_xi ;
    end
    
    s_hat = s_hat_num / s_hat_denom ;
    t_hat = avg_y - s_hat * R_hat * avg_x ;
end