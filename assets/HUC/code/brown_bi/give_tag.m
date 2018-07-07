function [ tag ] = give_tag( row, prev_tag, tags )
m = size(tags,1);
cond_tag = zeros(m,m);
pure_tag = zeros(m,1);

A = textscan(row,'%s','delimiter',' ','BufSize',8000);
for i=1:size(A{1},1)
%     A{1}{i}
    C = textscan(A{1}{i},'%s','delimiter','/');
    if(size(C{1},1) == 2)
        ind = tags(C{1}{1});
        pure_tag(ind,1) = pure_tag(ind,1) + str2double(C{1}{2});
    else
        ind1 = tags(C{1}{1});
        ind2 = tags(C{1}{2});
        cond_tag(ind1,ind2) = cond_tag(ind1,ind2) + str2double(C{1}{3});
    end
end
% cond_tag
% pure_tag
if(isempty(prev_tag))
    sum_tag = sum(cond_tag,2);
    sum_tag = sum_tag + pure_tag;
    ind = find(sum_tag == max(sum_tag));
    ind = ind(randsample(size(ind,1),1));
else
    prev_ind = tags(prev_tag);
    if(max(cond_tag(:,prev_ind)) == 0)
        sum_tag = sum(cond_tag,2);
        sum_tag = sum_tag + pure_tag;
        ind = find(sum_tag == max(sum_tag));
        ind = ind(randsample(size(ind,1),1));
    else
%         prev_ind
%         cond_tag(:,prev_ind)
        ind1 = find(cond_tag(:,prev_ind) == max(cond_tag(:,prev_ind)));
        ind = ind1(randsample(size(ind1,1),1));
    end
end
% ind
keys_tag = keys(tags);
values_tag = cell2mat(values(tags));
value_ind = find(values_tag == ind);
tag = keys_tag{value_ind};
return;    
end

