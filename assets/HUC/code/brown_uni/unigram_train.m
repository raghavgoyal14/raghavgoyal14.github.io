clear;
f = fopen('brown-train.txt');
line = fgets(f);
words = containers.Map();
tags = containers.Map();
num_words = 1;
num_tags = 1;
max_words = 100000;
max_tags = 50;
tag_freq_uni = zeros(max_words,max_tags);
tag_count = zeros(max_tags,1);

% for j=1:15
while ischar(line)
    A = textscan(line,'%s','delimiter',[' ' '\t'],'BufSize',8000);
    for i=2:size(A{1},1)
        C = textscan(A{1}{i},'%s','delimiter','/','BufSize',8000);
        curr_tag2 = [];
        curr_word = C{1}{1};
        curr_tag = C{1}{2};
        if(size(C{1},1)>2)
            for k=2:size(C{1},1)-1
                curr_word = horzcat(curr_word,'/',C{1}{k});
            end
            curr_tag = C{1}{size(C{1},1)};
        end
        C1 = textscan(curr_tag,'%s','delimiter','+','BufSize',8000);
        curr_tag1 = C1{1}{1};
        if(size(C1{1},1) == 2)
            curr_tag2 = C1{1}{2};
        end
        
        if(min(isletter(curr_tag1)) == 1 || min(curr_tag1 == '*') == 1)
            if(words.isKey(curr_word) == 0)
                words(curr_word) = num_words;
                num_words = num_words + 1;
            end
            if(tags.isKey(curr_tag1) == 0)
                tags(curr_tag1) = num_tags;
                num_tags = num_tags + 1;
            end
        
            r = words(curr_word);
            c = tags(curr_tag1);
            tag_freq_uni(r,c) = tag_freq_uni(r,c) + 1;
            tag_count(c,1) = tag_count(c,1) + 1;
           
            if(size(C1{1},1) == 2)
                if(tags.isKey(curr_tag2) == 0)
                    tags(curr_tag2) = num_tags;
                    num_tags = num_tags + 1;
                end
                r = words(curr_word);
                c = tags(curr_tag2);
                tag_freq_uni(r,c) = tag_freq_uni(r,c) + 1;
                tag_count(c,1) = tag_count(c,1) + 1;
            end
        end
    end
    line = fgets(f);
end

fclose(f);

arr_sum = sum(tag_freq_uni,2);
I = find(arr_sum == 0);
tag_freq_uni(I,:) = [];

indices = size(tags,1):max_tags;

tag_freq_uni(:,indices) = [];

tag_index = zeros(size(tag_freq_uni,1),1);
for i=1:size(tag_freq_uni,1)
    row = tag_freq_uni(i,:);
    ind = find(row == max(row));
    tag_index(i,1) = ind(1);
end
keys_tag = keys(tags);
values_tag = cell2mat(values(tags));

final_tag = cell(size(tag_freq_uni,1),1);
for i=1:size(tag_index,1)
    ind = tag_index(i,1);
    value_ind = find(values_tag == ind);
    final_tag{i} = keys_tag{value_ind};
end

save('final_tag_uni.mat','final_tag');
save('tags_uni','tags');
save('words_uni','words');
save('tag_count.mat','tag_count');

