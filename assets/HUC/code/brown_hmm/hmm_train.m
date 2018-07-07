clear;
f = fopen('brown-train.txt');
% f = fopen('newdummtext.txt');
line = fgets(f);
words = containers.Map();
tags = containers.Map();
num_words = 1;
num_tags = 1;
max_words = 100000;
max_tags = 50;
word_tag_count = zeros(max_words,max_tags);
trans_tag_count = zeros(max_tags,max_tags);
tag_count = zeros(max_tags,1);


% for j=1:15
while ischar(line)

    A = textscan(line,'%s','delimiter',[' ' '\t'],'BufSize',8000);
    prev_tag1 = [];
    prev_tag2 = [];
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
        C1 = textscan(curr_tag,'%s','delimiter','+');
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
            
            word_tag_count(r,c) = word_tag_count(r,c) + 1;
            tag_count(c,1) = tag_count(c,1) + 1;
            

            if(~isempty(prev_tag1))
                trans_tag_count(tags(prev_tag1), c) = trans_tag_count(tags(prev_tag1), c) + 1;
%                 tag_freq_bi{r} = add_tag(tag_freq_bi{r},curr_tag1,prev_tag1);
            end
            
            if(size(C1{1},1) == 2)
                if(tags.isKey(curr_tag2) == 0)
                    tags(curr_tag2) = num_tags;
                    num_tags = num_tags + 1;
                end
                c2 = tags(curr_tag2);
                word_tag_count(r,c2) = word_tag_count(r,c2) + 1;
                tag_count(c2,1) = tag_count(c2,1) + 1;
                
                if(~isempty(prev_tag1))
                    trans_tag_count(tags(prev_tag1), c2) = trans_tag_count(tags(prev_tag1), c2) + 1;
                end
            end
            
            if(~isempty(prev_tag2))
                trans_tag_count(tags(prev_tag2), c) = trans_tag_count(tags(prev_tag2), c) + 1;
%                 tag_freq_bi{r} = add_tag(tag_freq_bi{r},curr_tag1,prev_tag2);
                if(size(C1{1},1) == 2)
                    trans_tag_count(tags(prev_tag2), c2) = trans_tag_count(tags(prev_tag2), c2) + 1;
%                     tag_freq_bi{r} = add_tag(tag_freq_bi{r},curr_tag2,prev_tag2);
                end
            end
            
            if(size(C1{1},1) == 2)
                prev_tag1 = curr_tag1;
                prev_tag2 = curr_tag2;
            else
                prev_tag1 = curr_tag1;
                prev_tag2 = [];
            end
        end
    end
    line = fgets(f);
end

fclose(f);

ind = size(tags,1)+1:max_tags;

arr_sum = sum(word_tag_count,2);
I = find(arr_sum == 0);
word_tag_count(I,:) = [];

word_tag_count(:,ind) = [];

trans_tag_count(ind,:) = [];
trans_tag_count(:,ind) = [];

tag_count(ind,:) = [];

save('tag_count.mat','tag_count');
save('word_tag_count.mat','word_tag_count');
save('trans_tag_count.mat','trans_tag_count');
save('tags.mat','tags');
save('words.mat','words');