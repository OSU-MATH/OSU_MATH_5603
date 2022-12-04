clear all;

% - ------------------ Create Synthetic Data 
mu1 = [-20 0];
sigma1 = [3 .4; .4 3];

mu2 = [-15 0];
sigma2 = [3 0; 0 3];

mu3 = [-4 0];
sigma3 = [3 0; 0 1.5];

mu4 = [4 0];
sigma4 = [2 0; 0 1];

X1=[mvnrnd(mu1,sigma1,200)];
X2=[mvnrnd(mu2,sigma2,200)];
X3=[mvnrnd(mu3,sigma3,200)];
X4=[ mvnrnd(mu4,sigma4,200)];
X=[X1;X2;X3;X4];


G_knn = knngraph( X,8);
A_knn = adjacency(G_knn,'weighted');
G = graph(A_knn,'upper')

%XY_ga = gursoy_atun_layout(sparse(A_knn*1.0),'topology','circle');
XY_kk = kamada_kawai_spring_layout(sparse(A_knn*1.0));
%XY_fr=fruchterman_reingold_force_directed_layout(sparse(A*1.0));

% XB = gursoy_atun_layout(AB,'topology','heart');gplot(AB,X,'.-');

wgplot(A_knn,XY_kk);
