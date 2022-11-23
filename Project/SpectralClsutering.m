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

X1=[mvnrnd(mu1,sigma1,1000)];
X2=[mvnrnd(mu2,sigma2,1000)];
X3=[mvnrnd(mu3,sigma3,1000)];
X4=[ mvnrnd(mu4,sigma4,1000)];
X=[X1;X2;X3;X4];

% - ------------------ Plot Data 
figure ;set(gcf,'color','w');
hold on;

scatter(X1(:,1),X1(:,2),'b','.');
scatter(X2(:,1),X2(:,2),'g','.');
scatter(X3(:,1),X3(:,2),'y','.');
scatter(X4(:,1),X4(:,2),'r','.');

gm = gmdistribution.fit(X1,1);
ezcontour(@(x,y)pdf(gm,[x y]),[-30 10],[-10 10],160);
covX1 = cov(X1);
quiver(mu1(1),mu1(2) ,covX1(1,1),covX1(2,1),'b');
quiver(mu1(1),mu1(2) ,covX1(1,2),covX1(2,2),'b');

gm = gmdistribution.fit(X2,1);
ezcontour(@(x,y)pdf(gm,[x y]),[-30 10],[-10 10],160);
covX2 = cov(X2);
quiver(mu2(1),mu2(2) ,covX2(1,1),covX2(2,1),'g');
quiver(mu2(1),mu2(2) ,covX2(1,2),covX2(2,2),'g');

gm = gmdistribution.fit(X3,1);
ezcontour(@(x,y)pdf(gm,[x y]),[-30 10],[-10 10],160);
covX3 = cov(X3);
quiver(mu3(1),mu3(2) ,covX3(1,1),covX3(2,1),'y');
quiver(mu3(1),mu3(2) ,covX3(1,2),covX3(2,2),'y');

gm = gmdistribution.fit(X4,1);
ezcontour(@(x,y)pdf(gm,[x y]),[-30 10],[-10 10],630);
covX4 = cov(X4);
quiver(mu4(1),mu4(2) ,covX4(1,1),covX4(2,1),'r');
quiver(mu4(1),mu4(2) ,covX4(1,2),covX4(2,2),'r');

print('-dpng','-r600', ['./results/4class.png'] );
close gcf;


G_knn = knngraph( X,8);
A_knn = adjacency(G_knn,'weighted');
figure;set(gcf,'color','w');
spy(A_knn)
print('-dpng','-r600', ['./results/SpyStructure.png'] );
close gcf;
% --------------------------------Rotate data and permute columns and rows

[Q,~]=qr(randn(2));

sz=size(X)

N=sz(1,1)
P_rows = eye(N);
P_rows = P_rows(randperm(N),:);

M=sz(1,2)
P_col = eye(M);
P_col = P_col(randperm(M),:);

%X is now rotated and permuted by both by cols and rows 
X =P_rows* ( X * Q ) *P_col'


figure;set(gcf,'color','w');
G_knn = knngraph( X,8);
A_knn = adjacency(G_knn,'weighted');
spy(A_knn)
print('-dpng','-r600', ['./results/RandomizedSpyStructure.png'] );
close gcf;


A_knn = full(A_knn);
L2=laplacian_xrx(A_knn);
s = condeig(L2);
plot(s)
title('Eigenvalue condition number')
print('-dpng','-r600', ['./results/ev_cond.png'] );
close gcf;

[V,D] = eigs(L2,4,'SA');
figure ; plot(sort(V(:,1)), 'c');hold on;
plot(sort(V(:,2)), 'b');
plot(sort(V(:,3)), 'r');
plot(sort(V(:,4)), 'g');ylim([-.1 .1])
title('First Four Eigenvectors of Graph Laplacian')
print('-dpng','-r600', ['./results/eigenvecs.png'] );
close gcf;

% [P,R,C] = equilibrate(A_knn)
% B = R*P*A*C;
% c2 = condest(B)

% Gram Kernel - this is a similarity matrix between all pairs 
A_gram = squareform(pdist(X, 'euclidean'));
sigma_wt = .001
A_gram = exp(-A_gram.^2 ./ sigma_wt);


%ZelnikManorPerona - local affinity Adjacency calculation
nrand = 1000;
minneighbors = 5;
nframes = size(X,1)
rr = floor(nframes*rand(nrand,1)) + 1;
mindists = zeros(nrand,1);
for k = 1:nrand
    kk = rr(k);
    qdist = sum((ones(nframes,1)*X(kk,:)-X).^2,2);
    qdists = sort(qdist);
    mindists(k) = qdists(minneighbors);
end

maxrad = median(mindists)
[Aloc ii jj maxrad] = makeAffinity_local_ZelnikManorPerona(X,minneighbors,maxrad);

Aloc = full(Aloc);
s = condeig(Aloc);
%Large condition numbers imply that A is near a matrix with multiple eigenvalues

cond(Aloc)

spy(Aloc);

L2=laplacian_xrx(Aloc);% A_knn

s = condeig(L2);
plot(s)
title('Eigenvalue condition number')
print('-dpng','-r600', ['./results/ev_cond.png'] );
close gcf;


[V,D] = eigs(L2,16,'SA');
figure ;;set(gcf,'color','w'); plot(sort(V(:,1)), 'c');hold on;
plot(sort(V(:,2)), 'b');
plot(sort(V(:,3)), 'r');
plot(sort(V(:,4)), 'g');
title('First Four Eigenvectors of Graph Laplacian')
legend('EV 0','EV1','EV 2','EV 3',Location='southeast');
print('-dpng','-r600', ['./results/eigenvecs.png'] );
close gcf;