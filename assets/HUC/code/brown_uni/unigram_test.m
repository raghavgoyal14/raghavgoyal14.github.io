clear;
load('final_tag_uni.mat');
load('tags_uni.mat');
load('words_uni.mat');
f = fopen('brown-test.txt');
line = fgets(f);
num_words = 0;
num_correct = 0;
num_unknown_words = 0;
num_correct_unknown = 0;
tag_unknown_words = zeros(size(tags,1),1);
confusion_matrix = zeros(size(tags,1),size(tags,1));

% for j=1:50
while ischar(line)
    
    A = textscan(line,'%s','delimiter',[' ' '\t'],'BufSize',8000);
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
                tag_allot = final_tag{ind};
            else
                tag_allot = 'N';
                flag_unknown = 1;
                num_unknown_words = num_unknown_words + 1;
                
                c = tags(curr_tag1);
                tag_unknown_words(c,1) = tag_unknown_words(c,1) + 1;
                if(size(C1{1},1) == 2)
                    c = tags(curr_tag2);
                    tag_unknown_words(c,1) = tag_unknown_words(c,1) + 1;
                end
            end
            
            if(size(C1{1},1) == 2)
                if(strcmp(tag_allot,curr_tag1) || strcmp(tag_allot,curr_tag2))
                    num_correct = num_correct + 1;
                    if(flag_unknown == 1)
                        num_correct_unknown = num_correct_unknown + 1;
                    end
                end
            else
                if(strcmp(tag_allot,curr_tag1))
                    num_correct = num_correct + 1;
                    if(flag_unknown == 1)
                        num_correct_unknown = num_correct_unknown + 1;
                    end
                end
            end
            confusion_matrix(tags(curr_tag1),tags(tag_allot)) = confusion_matrix(tags(curr_tag1),tags(tag_allot)) + 1;
            if(size(C1{1},1) == 2)
                confusion_matrix(tags(curr_tag2),tags(tag_allot)) = confusion_matrix(tags(curr_tag2),tags(tag_allot)) + 1;
            end
            
        end
    end
    line = fgets(f);
end

num_unknown_words
num_correct_unknown
save('confusion_matrix.mat','confusion_matrix');

acc = (num_correct/num_words)*100;
fprintf('Accuracy is %g%%\n',acc);


