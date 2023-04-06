function [] = BetweenNetEdgeW(mask,weight,out,net,netN,B)
Consensus = importdata(mask);
weigh = importdata(weight);
data = Consensus.*weigh;
network = importdata(net);
line = 1;
net_num = netN;
for i = 1:size(data,1)
    for j = 1:size(data,2)
        A(line,1) = i;
        A(line,2) = j;
        A(line,3) = data(i,j);
        line = line+1;
    end
end
A(find(A(:,3)==0),:) = [];

pos_edge = A(find(A(:,3)>0),:);
neg_edge = A(find(A(:,3)<0),:);

%%%%%%%%% for positive edges %%%%%%%%%
pos_netassign = zeros(size(pos_edge,1),size(pos_edge,2));
for i = 1:size(pos_edge,1)
    for j = 1:(size(pos_edge,2)-1)
        pos_netassign(i,j) = network{find(network{:,2}==pos_edge(i,j)),3};
    end
end
pos_netassign(:,3) = pos_edge(:,3);

   
%%%%%%%%% for negative edges %%%%%%%%%
neg_netassign = zeros(size(neg_edge,1),size(neg_edge,2));
for i = 1:size(neg_edge,1)
    for j = 1:(size(neg_edge,2)-1)
        neg_netassign(i,j) = network{find(network{:,2}==neg_edge(i,j)),3};
    end
end
neg_netassign(:,3) = neg_edge(:,3);

%%%%%%%%% positive sum %%%%%%%%%%%%%%%
line=1;
for m=1:net_num
    for n=m:net_num
  index1=find(pos_netassign(:,1)==m);
  data_matrix=pos_netassign(index1,:);
  index2=find(data_matrix(:,2)==n);
  posSum(line,1)=m;
  posSum(line,2)=n;
  posSum(line,3)=sum(data_matrix(index2,3));
  index3=find(pos_netassign(:,1)==n);
  data_matrix=pos_netassign(index3,:);
  index4=find(data_matrix(:,2)==m);
  posSum(line,3)= posSum(line,3)+sum(data_matrix(index4,3));
  line=line+1;
    end
end
for i=1:size(posSum,1)
    if posSum(i,1)==posSum(i,2)
        posSum(i,3)=posSum(i,3)/2;
    end
end
posSum(find(posSum(:,3)==0),:)=[];

%%%%%%%%% negative sum %%%%%%%%%%%%%%

line=1;
for m=1:net_num
    for n=m:net_num
  index1=find(neg_netassign(:,1)==m);
  data_matrix=neg_netassign(index1,:);
  index2=find(data_matrix(:,2)==n);
  negSum(line,1)=m;
  negSum(line,2)=n;
  negSum(line,3)=sum(data_matrix(index2,3));
  index3=find(neg_netassign(:,1)==n);
  data_matrix=neg_netassign(index3,:);
  index4=find(data_matrix(:,2)==m);
  negSum(line,3)= negSum(line,3)+sum(data_matrix(index4,3));
  line=line+1;
    end
end

for i=1:size(negSum,1)
    if negSum(i,1)==negSum(i,2)
        negSum(i,3)=negSum(i,3)/2;
    end
end
negSum(find(negSum(:,3)==0),:)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if B==0
    line = 1;
        for i =1:net_num
            for j=i:net_num
                networkEdge(line,1) = i;
                networkEdge(line,2) = j;
                select1 = posSum(find(posSum(:,1)==i),:);
                select2 = select1(find(select1(:,2)==j),:);
                select3 = negSum(find(negSum(:,1)==i),:);
                select4 = select3(find(select3(:,2)==j),:);
                if isempty(select2)
                    networkEdge(line,3) = 0;
                else
                    networkEdge(line,3) = sum(select2(:,3));
                end
                if isempty(select4)
                    networkEdge(line,3) = networkEdge(line,3)+0;
                else
                    networkEdge(line,3) = networkEdge(line,3)+abs(sum(select4(:,3)));
                end
                line = line + 1;
            end
        end
        networkEdge(find(networkEdge(:,3)==0),:) = [];
        xlswrite(out,networkEdge);
end

            
                
                