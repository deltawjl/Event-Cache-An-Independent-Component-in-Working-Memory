clear;
wkdir='/sharedata/zhouh/WM_Project_Hui/Resting_Prediction/process_Hui/Prediction/Prediction_SVM/Data_Share';
matrixdir=[wkdir,'/OBJECT_visualize'];
outdir=matrixdir;
nodedegree=load([matrixdir,'/NodeDegree.csv']);
atlasdir='/sharedata/zhouh/Atlas/ShenXilin';
network=importdata([atlasdir,'/network_Greene.mat']);
Im_net=[10];

for i=1:size(nodedegree,1)
    node(i,1)=nodedegree(i,1);
    node(i,2)=network{find(network{:,2}==node(i,1)),3};
    node(i,3)=nodedegree(i,2);
end
node(find(node(:,3)==0),:)=[];

node_sort=sortrows(node,2);
xlswrite([outdir,'/NodeDegree_net.xlsx'],node_sort);


