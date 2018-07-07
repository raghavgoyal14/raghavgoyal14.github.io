clear;
load('final_tag_uni.mat');
load('words_bi.mat');
load('tags_bi.mat');
load('tag_freq_bi.mat');
load('trans_tag_count.mat')
f = fopen('brown-test.txt');
line = fgets(f);
num_words = 0;
num_correct = 0;
num_correct_uni = 0;
confusion_matrix = zeros(size(tags,1),size(tags,1));

num_correct_unknown = 0;
num_unknown_words = 0;

total_diff = 0;
correct_diff = 0;

% for j=1:1
while ischar(line)
    A = textscan(line,'%s','delimiter',[' ' '\t'],'BufSize',8000);
    prev_tag = [];
    for i=2:size(A{1},1)
        flag_unknown = 0;
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
            num_words = num_words + 1;
            if(words.isKey(curr_word) == 1)
                ind = words(curr_word);
                %             tag_allot = final_tag{ind};
                tag_allot = give_tag(tag_freq_bi{ind}, prev_tag, tags);
                tag_allot_uni = final_tag{ind};
            else
                flag_unknown = 1;
                num_unknown_words = num_unknown_words + 1;
%                 tag_allot = 'N';
                tag_allot_uni = 'N';
                if(~isempty(prev_tag))
                   r = tags(prev_tag);
                   ind = find(trans_tag_count(r,:) == max(trans_tag_count(r,:)));
                   new_ind = find(cell2mat(values(tags))==ind);
                   k = keys(tags);
                   tag_allot = cell2mat(k(new_ind));
                else
                    tag_allot = 'N';
                end
                
            end
            
            if(~strcmp(tag_allot,tag_allot_uni))
                total_diff = total_diff + 1;
            end
            
            if(size(C1{1},1) == 2)
                if(strcmp(tag_allot_uni,curr_tag1) || strcmp(tag_allot_uni,curr_tag2))
                    num_correct_uni = num_correct_uni + 1;
                end
                if(strcmp(tag_allot,curr_tag1) || strcmp(tag_allot,curr_tag2))
                    num_correct = num_correct + 1;
                    if(flag_unknown == 1)
                        num_correct_unknown = num_correct_unknown + 1;
                    end
                    if((~strcmp(tag_allot_uni,curr_tag1)) && (~strcmp(tag_allot_uni,curr_tag2)))
                        correct_diff = correct_diff + 1;
                    end
                end
            else
                if(strcmp(tag_allot_uni,curr_tag1))
                    num_correct_uni = num_correct_uni + 1;
                end
                if(strcmp(tag_allot,curr_tag1))
                    num_correct = num_correct + 1;
                    if(flag_unknown == 1)
                        num_correct_unknown = num_correct_unknown + 1;
                    end
                    if(~strcmp(tag_allot_uni,curr_tag1))
                        correct_diff = correct_diff + 1;
                    end
                end
            end
            confusion_matrix(tags(curr_tag1),tags(tag_allot)) = confusion_matrix(tags(curr_tag1),tags(tag_allot)) + 1;
            if(size(C1{1},1) == 2)
                confusion_matrix(tags(curr_tag2),tags(tag_allot)) = confusion_matrix(tags(curr_tag2),tags(tag_allot)) + 1;
            end
            
        end
        prev_tag = tag_allot;
    end
    line = fgets(f);
end

save('confusion_matrix.mat','confusion_matrix');
total_diff
num_correct_uni/num_words
acc = (num_correct/num_words)*100;
fprintf('Accuracy is %g%%\n',acc);

print_confusion

