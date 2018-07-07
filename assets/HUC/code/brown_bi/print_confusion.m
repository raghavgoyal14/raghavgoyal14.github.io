load('confusion_matrix.mat')
load('tags_bi.mat')

% new_conf = zeros(size(tags,1)+1,size(tags,1)+1);

keys_tags = keys(tags);
values_tags = values(tags);

for i=1:size(tags,1)
    ind = find(cell2mat(values(tags))==i);
%     new_conf(1,i+1) = cell2mat(keys_tags(ind));
    fprintf('\t%s',cell2mat(keys_tags(ind)));
end
fprintf('\n');

for i=1:size(tags,1)
    ind = find(cell2mat(values(tags))==i);
%     new_conf(i+1,1) = cell2mat(keys_tags(ind));
    fprintf('%s\t',cell2mat(keys_tags(ind)));
    for j=1:size(tags,1)
%         new_conf(i+1,j+1) = confusion_matrix(i,j);
        fprintf('%d\t',confusion_matrix(i,j));
    end
    fprintf('\n');
end
