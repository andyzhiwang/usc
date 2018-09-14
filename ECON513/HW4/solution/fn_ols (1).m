% Arturo Aguilar
% Probelm set 4
% Econ 1126

% Ths file specifies the OLS function.


function [beta se]=fn_ols(Y,X)
[n,k]=size(X);

beta=inv((X'*X))*(X'*Y);

%Define the residuals and sigma-squared
res=Y-X*beta;
sigma2=res'*res/(n-k);

%Define the variance covariance matrix
Covar=inv(X'*X)*sigma2;

l=length(Covar);
std_err=zeros(l,1);
for j=1 :l;
    std_err(j,1)=sqrt(Covar(j,j));
end
se=std_err;