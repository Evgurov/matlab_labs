clc; clear;
%%%%%%Productivity%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'RUS_niot_nov16.xlsx';
[excel_A, excel_W] = get_excel_matrix(filename, 2001);
[reducted_excel_A, reducted_excel_W] = reduct_matrix(excel_A, excel_W);
[A, X, W] = get_IO_matrix(reducted_excel_A, reducted_excel_W);
disp('Input-Output matrix:');
disp(A);
disp('Vector of gross issues:');
disp(X');
disp('Vector of final consumption:');
disp(W');

D = eye(size(A)) - A;
disp(['Productivity: ', productivity(D)]);

%%%%%%Frobenius-Perron%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[lambda, x_a] = find_FP(A, 0.001);
disp('Frobenius-Perron eigenvalue:');
disp(lambda);
disp('Frobenius-Perron eigenvector:');
disp(x_a');

%%%%%%Agregate with removal%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete = [10, 20, 30];
[A_new, X_new, W_new] = remove_industries(A, W, delete);

disp('Matrix after industries removal:');
disp(A_new);
disp('Vector x after industries removal:');
disp(X_new');
disp('Vector w after industries removal:');
disp(W_new');

I = {[1:4], [5:9], [10:15], [16:max(size(A_new))]};
[A_agr, X_agr, W_agr] = agregate(A_new, X_new, W_new, I);

disp('Matrix after agregation:');
disp(A_agr);
disp('Vector x after agregation:');
disp(X_agr');
disp('Vector w after agregation:');
disp(W_agr');
disp('Check:');
disp(abs(sum(X) - sum(X_agr)));

%%%%%FP eigenvalues for A and A_agr%%%%%%%%%%%%%%%%%%%%%%%%%%%
FP_A = find_FP(A, 0.001);
FP_A_agr = find_FP(A_agr, 0.001);
disp('Frobenius-Perron eigenvector for original matrix:');
disp(FP_A');
disp('Frobenius-Perron eigenvector for agregated matrix:');
disp(FP_A_agr');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [excel_A, excel_W] = get_excel_matrix(filename, year)
    range_A = [3 + (year - 2000) * 120, 5, 3 + (year - 2000) * 120 + 55, 60];
    range_W = [3 + (year - 2000) * 120, 61, 3 + (year - 2000) * 120 + 55, 65];
    excel_A = readmatrix(filename, 'Sheet', 'National IO-tables', 'Range', range_A);
    excel_W = readmatrix(filename, 'Sheet', 'National IO-tables', 'Range', range_W);
end

function [A, X, W] = get_IO_matrix(excel_A, excel_W)
    A = zeros(size(excel_A));
    X = zeros(size(excel_W, 1), 1);
    W = zeros(size(excel_W, 1), 1);
    for i = 1 : size(excel_A, 1)
        for j = 1 : size(excel_A, 2)
            A(i,j) = excel_A(i,j) / (sum(excel_A(j,:)) + sum(excel_W(j,:)));
        end
        W(i) = sum(excel_W(i,:));
        X(i) = sum(excel_A(i,:)) + W(i);
    end
end

function [reducted_A, reducted_B] = reduct_matrix(A, B)
    Mat = cat(2, A, B);
    rows_sum = sum(Mat, 2);
    reducted_A = A(rows_sum > 0, rows_sum > 0);
    reducted_B = B(rows_sum > 0, :);
end

function res = productivity(Mat)
    for i = 1 : size(Mat,1)
        if det(Mat(1:i,1:i)) <= 0
            res = 'no';
            return
        end
    end
    res = 'yes';
end

function [lambda, x_a] = find_FP(A, eps)
    x_last = ones(size(A,1), 1);
    lambda_last = 1;
    x_next = A * x_last;
    lambda_next = sum(x_next ./ x_last, 1) / size(A, 1);
    while (abs(lambda_next - lambda_last) >= eps)
        x_next = A*x_last;
        lambda_next = sum(x_next./x_last,1)/size(A,1);
        
        x_last = x_next/max(max(x_next));
        lambda_last = lambda_next;
    end
    lambda = lambda_last;
    x_a = x_last;
end

function [A_new, X_new, W_new] = remove_industries(A, W, delete)
    needed = 1 : size(A, 1);
    needed(delete) = [];

    A11 = A(needed, needed);
    A12 = A(needed, delete);
    A21 = A(delete, needed);
    A22 = A(delete, delete);
    A_new = A11 + A12 * inv(eye(size(A22)) - A22) * A21;

    W_new = W(needed);
    X_new = inv(eye(size(A_new)) - A_new) * W_new;
end

function [A_agr, X_agr, W_agr] = agregate(A, X, W, I)
    A_agr = zeros(max(size(I)));

    for i = 1:max(size(I))
        for j = 1:max(size(I))
            A_agr(i, j) = sum( A(I{i}, I{j}) * X(I{j}) ) / sum( X(I{j}) );
        end
        X_agr(i,1) = sum(X(I{i}),1);
        W_agr(i,1) = sum(W(I{i}),1);
    end
end