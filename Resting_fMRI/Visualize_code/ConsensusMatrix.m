function [] = ConsensusMatrix(prefix,out)
%%% calculate overlapped matrix for all iterations, input can be
%%% SelectFeature of Weighted feature; output is a matrix
files=dir([prefix,'_*']);
  for j=1:size(files,1)
    matrix(:,:,j)=importdata(fullfile(files(j).folder,files(j).name));
  end
 overmatrix=ones(size(matrix,1),size(matrix,2));
  for m=1:size(files,1)
    overmatrix=overmatrix.*matrix(:,:,m);
  end
 overmatrix(find(overmatrix~=0))=1;
 save(out,'overmatrix');