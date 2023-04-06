clear;
wkdir='/sharedata/zhouh/WM_Project_Hui/Resting_Prediction/process_Hui/Prediction/Prediction_SVM/Data_Share';
matrixdir=[wkdir,'/OBJECT'];
atlasdir='/sharedata/zhouh/Atlas/ShenXilin';
outdir=[wkdir,'/OBJECT_visualize'];
ConsensusMatrix([matrixdir,'/SelectFeature_5_Fold'],[outdir,'/Consensus_matrix_5']);
NodeDegree([outdir,'/Consensus_matrix_5.mat'],[outdir,'/NodeDegree.xlsx']);

Nnet=10;
%%%%%%%%%%%%%%% plot node degree %%%%%%%%%%%%%%
node=load([outdir,'/NodeDegree.csv']);
node(find(node(:,2)==0),:)=[];
ROIs=node(:,1)';    % get ROI index
unix(['3dCM -roi_vals ',num2str(ROIs),' -Icent ',[atlasdir,'/shen_1mm_268_parcellation.nii.gz'],'>',[outdir,'/CM.1D']]);
unix(['cat ',[outdir,'/CM.1D'],' | grep -v ''#'' > ',[outdir,'/CMxyz.1D']]);
xyz=load([outdir,'/CMxyz.1D']);
LPIxyz(:,1)=-xyz(:,1);
LPIxyz(:,2)=-xyz(:,2);
LPIxyz(:,3)=xyz(:,3);

network=importdata([atlasdir,'/network_Greene.mat']);
for i=1:size(ROIs,2)
    netAssin(i,1)=network{find(network{:,2}==ROIs(1,i)),3};
end

xjviewMatrix(:,1:3)=LPIxyz;
xjviewMatrix(:,4)=netAssin;
xjviewMatrix(:,5)=node(:,2);

fid=fopen([outdir,'/Degree.node'],'wt');
for i=1:size(xjviewMatrix,1)
    for j=1:size(xjviewMatrix,2)
        fprintf(fid,'%.2f ',xjviewMatrix(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);

%%%%%%%%%%%%%% radar plot %%%%%%%%%%%%%%%%%%%%%
BetweenNetEdgeW([outdir,'/Consensus_matrix_5.mat'],[matrixdir,'/WeightSelectFeature_5.mat'],[outdir,'/NetworkEdgeWeight.xlsx'],[atlasdir,'/network_Greene.mat'],10,0);
netEdge=load([outdir,'/NetworkEdgeWeight.csv']);
for i = 1:Nnet
    a=ones(size(find(netEdge(:,1)==i),1),1);
    b=ones(size(find(netEdge(:,2)==i),1),1);
    
    index = find(netEdge(:,2)==i);
    repeat = 0;
    NetDegree(i,1) = i;
    for j = 1:size(index,1)
        if netEdge(index(j),1)==netEdge(index(j),2)
            repeat = 1;
        end
    end
    NetDegree(i,2)=sum(a)+sum(b)-repeat;
end
NetDegree(:,3) = NetDegree(:,2)./sum(NetDegree(:,2));
xlswrite([outdir,'/Radar.xlsx'],NetDegree);





