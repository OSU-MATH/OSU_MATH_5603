
clear all;
Cox = [
	0.00  0.00  1.00
	0.00  0.50  0.00
	1.00  0.00  0.00
	0.00  0.75  0.75
	0.75  0.00  0.75
	0.75  0.75  0.00
	0.25  0.25  0.25
	0.75  0.25  0.25
	0.95  0.95  0.00
	0.25  0.25  0.75
	0.75  0.75  0.75
	0.00  1.00  0.00
	0.76  0.57  0.17
	0.54  0.63  0.22
	0.34  0.57  0.92
	1.00  0.10  0.60
	0.88  0.75  0.73
	0.10  0.49  0.47
	0.66  0.34  0.65
	0.99  0.41  0.23
];
for p=.05:.05:.5
    
    p_G1 = 0.1 + p;
    p_G2 = 0.25 + p;
    
    gaps = zeros(10,1);
    gcf = figure;  
    hold on;
    clusterSizeStart = 128;
    clusterSizeDelta = 64;
    clusterSizeMax = 512;
    legendCount =1;
    for ClusterSize=clusterSizeStart:clusterSizeDelta:clusterSizeMax        tic
        legendStrings{legendCount} = ['N = ',sprintf('%d',ClusterSize)];legendCount = legendCount+1;        
        K=20
        xVals=nan(K,1);        
        for i=1:K
            N=2*  ClusterSize;
            x = (1:N);%randperm(N);
            gs = N/2;
            G1 = x(1:gs);
            G2 = x(gs+1:2*gs);
            p_Inbetween = 0.000 + (i-1)/(10*K);
            xVals(i) = p_Inbetween;
            A(G1, G1) = rand(gs,gs) < p_G1;
            A(G2, G2) = rand(gs,gs) < p_G2;
            [n1,m1]=size( A(G1, G2));
            B_1=rand(gs, gs);
            A(G1, G2) = B_1 < p_Inbetween;
            A = triu(A,1);
            A = A + A';
            
            L2=laplacian(A);
            sigma=eig(L2);
            gap = sigma(2)-sigma(1);
            
            gaps(i)= gap;          
        end
        plot(xVals,gaps,'Color',[0+ .5*ClusterSize / clusterSizeMax ,0+ .5*ClusterSize / clusterSizeMax,0 + .5*ClusterSize / clusterSizeMax]);
        plot(xVals,gaps,'Color',Cox(legendCount,:));
        toc
    end
    legend(legendStrings,'Location','SE');
    title({['Spectral Gap For 2 Class Ensemble with increasing class crosstalk '];[' p(Class1)= ',sprintf('%f',p_G1),' p(Class2)= ',sprintf('%f',p_G2)]});
    xlabel('p(Class2  ~ Class1)');
    ylabel('\lambda_1 - \lambda_2');
    print(gcf,'-djpeg','-r600', ['./results/SpectralGap_P1_',sprintf('%f',p_G1),'P2_',sprintf('%f',p_G2),'.jpg'] );
    close gcf;    
end


clear all;
p=.05
p_G1 = 0.05 + p;
p_G2 = 0.15 + p;    
clusterSizeStart = 128;
clusterSizeDelta = 64;
clusterSizeMax = 512;%Calculate These
ClusterSize=clusterSizeStart
M=10;
xp1=nan(M,1);
xp2=nan(M,1);
xcrosstalk=nan(M,1);
xgap=nan(M,1);
xcond1=nan(M,1);
xcond2=nan(M,1);
xcond12=nan(M,1);


for i=1:M
    N=2*  ClusterSize;
    x = (1:N);%randperm(N);
    gs = N/2;
    G1 = x(1:gs);
    G2 = x(gs+1:2*gs);
    p_Inbetween = 0.000 + (i-1)/100;
    A(G1, G1) = rand(gs,gs) < p_G1;
    A(G2, G2) = rand(gs,gs) < p_G2;
    [n1,m1]=size( A(G1, G2));
    B_1=rand(gs, gs);
    A(G1, G2) = B_1 < p_Inbetween;
    A = triu(A,1);
    A = A + A';
    
    L2=laplacian(graph(A));
    L2s = laplacian_xrx(A);%same!
    
    sigma=eig(L2);
    gap = sigma(2)-sigma(1);
    spy(A);
    print('-djpeg','-r600', ['./results/Aspy_P1_',sprintf('%f',p_G1),'_P2_',sprintf('%f',p_G2),'_crosstalk_',sprintf('%f',p_Inbetween),'_gap_',sprintf('%f',gap),'.jpg'] );
    close gcf;

    XY_fr=fruchterman_reingold_force_directed_layout(sparse(A*1.0),'initial_temp',50);
    wgPlot(A,XY_fr); 
    print('-djpeg','-r600', ['./results/G_P1_',sprintf('%f',p_G1),'_P2_',sprintf('%f',p_G2),'_crosstalk_',sprintf('%f',p_Inbetween),'_gap_',sprintf('%f',gap),'.jpg'] );
    close gcf;
    
    L_G1 = laplacian(graph(A(1:gs, 1:gs)))
    L_G2=laplacian(graph(A(gs+1:2*gs, gs+1:2*gs)))
    sigmaG1 = eig(L_G1)
    sigmaG2 = eig(L_G2)            
    sigmaX = [sigmaG1;sigmaG2]
    close gcf;
    plot(sigma,"Marker","+")
    hold on;
    plot(sigmaX,"Color",'red','Marker','*')
    %Same as eig - safety check
    %sigmaSVD=sort(svd(L2),1,"ascend")
    %plot(sigmaSVD,"Color",'greep','Marker','square')
    print('-djpeg','-r600', ['./results/Spectrum_P1_',sprintf('%f',p_G1),'_P2_',sprintf('%f',p_G2),'_crosstalk_',sprintf('%f',p_Inbetween),'_gap_',sprintf('%f',gap),'.jpg'] );
    close gcf;
   
    xp1(i)=p_G1;
    xp2(i)=p_G2;
    xcrosstalk(i)=p_Inbetween;
    xgap(i)=gap;
    xcond1(i)=cond(laplacian(graph(A(1:gs, 1:gs))));
    xcond2(i)=cond(laplacian(graph(A(gs+1:2*gs, gs+1:2*gs))));
    xcond12(i)=cond(L2); 

end

dataTable = table(xp1,xp2,xcrosstalk,xgap,xcond1,xcond2,xcond12,'VariableNames',{'pClass1','pClass2','pClass12','EigenGap12','cond1','cond2','cond12'});
filename=['./results/DataTable_',sprintf('%f',p_G1),'_P2_',sprintf('%f',p_G2),'_crosstalk_',sprintf('%f',p_Inbetween),'_gap_',sprintf('%f',gap),'.csv']
writetable(dataTable,filename)
disp(dataTable)


