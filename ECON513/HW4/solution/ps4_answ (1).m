% TF. Arturo Aguilar
% Problem set 4
% Ec 1126

clear all;
clc;

cd 'Y:\TF\Econ1126\PS4'

diary answers_pset4

load cardkrug2.mat
 
%Qa
n=length(empl0);
demp=empl1-empl0;
Drest=dummyvar(chain);
bk=Drest(:,1);
kfc=Drest(:,2);
roys=Drest(:,3);
wendys=Drest(:,4);

d=state;

%Determine the variables for the OLS

x0=ones(n,1);
Y=demp;
X=[d bk kfc roys wendys];
[b se]=fn_ols(Y,X)
[n k]=size(X);
%Qb

%Number of observations per cluster and mean
pa=ones(n,1)-d;
z1=pa.*bk;
z2=pa.*kfc;
z3=pa.*roys;
z4=pa.*wendys;
z5=d.*bk;
z6=d.*kfc;
z7=d.*roys;
z8=d.*wendys;
Z=[z1 z2 z3 z4 z5 z6 z7 z8];
nZ=sum(Z)
avgN=mean(nZ) %or just n/8

X1=[zeros(4,1) eye(4); ones(4,1) eye(4)];
X2=Z*X1;
[b2 se2]=fn_ols(Y,X2)
[n k]=size(X2);
M=eye(n)-X2*inv(X2'*X2)*X2';
err=M*Y;


%Use the formula from pp.19 in lecture notes
Mp=eye(n)-(Z*inv(Z'*Z)*Z');
err_p=Mp*err;
sigma2_eps=err_p'*err_p/(n-8)
sigma2=err'*err/(n-k)
sigma2_eta=sigma2-sigma2_eps
rho=sigma2_eta/sigma2

S2=zeros(8,1);
for i=1:8
    err_i=err.*Z(:,i);
    merr_i=mean(err_i);
    derr_i=err_i-ones(n,1)*merr_i;
    derr_i2=derr_i'*derr_i;
    S2(i,1)=derr_i2/(nZ(i)-1);
end

sigma2_epsilon=sum(S2)/8

S2_eta=zeros(8,1);

for i=1:8
    err_i=err.*Z(:,i);
    S2_eta(i,1)=sum(err_i)/nZ(i);
end

sigma2_etap=S2_eta'*S2_eta/8

%Qc
CF=(avgN*rho)+(1-rho)
se_CF=se*sqrt(CF)

%Qd
Covar=inv(X2'*X2)*X2'*((sigma2_eps*eye(n))+(sigma2_eta*Z*Z'))*X2*inv(X2'*X2)
se_correct=sqrt(diag(Covar))

H=zeros(k,k,8);
G=zeros(k,k,8);
for i=1:8
    H(:,:,i)=nZ(i)*X1(i,:)'*X1(i,:);
    G(:,:,i)=(nZ(i)^2)*(sigma2_eta+(sigma2_eps/nZ(i)))*X1(i,:)'*X1(i,:);
end
Hs=sum(H,3);
Gs=sum(G,3);

Covar2=inv(Hs)*Gs*inv(Hs)
se_correct2=sqrt(diag(Covar2))
    

%Qe
dbk=z5;
dkfc=z6;
droys=z7;
dwendys=z8;

X3=[d bk kfc roys wendys dbk dkfc droys];
[b3 se3]=fn_ols(Y,X3)

%Qf
boot=10000;

betas=[];

for j=1:boot
    rs=unidrnd(n,n,1);
    Yboot=[];
    Xboot=[];
    for k=1:n
        Xboot(k,:)=X(rs(k),:);
        Yboot(k,1)=Y(rs(k));
    end
    [bj sej]=fn_ols(Yboot,Xboot);
    betas=[betas; bj'];
end

beta_boot=mean(betas)
se_boot=std(betas)



diary off
