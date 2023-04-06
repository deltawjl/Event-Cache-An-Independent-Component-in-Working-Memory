function [] = NodeDegree(matrix,outname)
%%% the input is an uppertriangular matrix, without diagonal line
data = importdata(matrix);
for i=1:size(data,1)%%% calculate node degree for each node A(:,1): ROI index in matrix; A(:,2):degree
    weig1=find(data(i,:)~=0);
    weig2=find(data(:,i)~=0);
    line1=size(weig1,2);
    line2=size(weig2,1);
    A(i,1)=i;
    A(i,2)=line1+line2;
end
 [A_order,ROI]=sort(A(:,2),'descend');%%% sort in descending order
 B(:,1)=ROI;
 B(:,2)=A_order;
 xlswrite(outname,B);
end
