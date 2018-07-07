clear;
f = fopen('brown-test.txt');
line = fgets(f);
load('word_tag_count.mat');
load('trans_tag_count.mat');
load('tag_count.mat');
load('tags.mat');
load('words.mat');

test_words = 1;
num_words = size(word_tag_count,1);
num_tags = size(tags,1);
trans_mat = zeros(num_tags,num_tags);
total_words = 0;
num_correct = 0;
num_correct_viterbi = 0;
skip_words = 0;
num_unknown = 0;
num_correct_unknown = 0;
flag_unknown = 0;
confusion_matrix = zeros(30,30);


for i=1:num_tags
    c = tag_count(i,1);
    for j=1:num_tags
        %         trans_mat(i,j) = (trans_tag_count(i,j) + 1)/(c + num_tags);
        trans_mat(i,j) = (trans_tag_count(i,j))/(c);
    end
end

keys_tag = keys(tags);
values_tag = cell2mat(values(tags));

p = (tag_count/sum(tag_count))';
TRANS_HAT = [0 p; zeros(size(trans_mat,1),1) trans_mat];

while ischar(line)
%         for j=1:1
    tags_orig1 = [];
    tags_orig2 = [];
    emiss = [];
    
    A = textscan(line,'%s','delimiter',[' ' '\t'],'BufSize',8000);
    unknown_array = [];
    
    for i=2:size(A{1},1)
        likelihood_word = zeros(num_tags,1);
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
        if(min(isletter(curr_tag1)) == 1 || min(curr_tag1 == '*') == 1)
            if(words.isKey(curr_word) == 1)
                unknown_array = [unknown_array 0];
            else
                unknown_array = [unknown_array 1];
            end
            
            tags_orig1 = [tags_orig1 tags(curr_tag1)];
            if(size(C1{1},1) == 2)
                curr_tag2 = C1{1}{2};
                tags_orig2 = [tags_orig2 tags(curr_tag2)];
            else
                tags_orig2 = [tags_orig2 0];
            end
            
            for k=1:num_tags
                c = tag_count(k,1);
                %                 if(words.isKey(curr_word) == 1)
                %                     likelihood_word(k,1) = (word_tag_count(words(curr_word),k)+1)/(c+num_words);
                %                 else
                %                     likelihood_word(k,1) = 1/(c+num_words);
                %                 end
                if(words.isKey(curr_word) == 1)
                    likelihood_word(k,1) = (word_tag_count(words(curr_word),k))/(c);
                else
                    likelihood_word(k,1) = 1/(c+num_words);
                end
                
            end
            emiss = [emiss likelihood_word];
        end
    end
    num_unknown = num_unknown + sum(unknown_array);
    if(~isempty(emiss))
        EMIS_HAT = [zeros(1,size(emiss,2)); emiss];
        seq = [1:size(emiss,2)]';
        likelystates = hmmviterbi(seq, TRANS_HAT, EMIS_HAT);
        states = likelystates - 1;
        for l=1:size(states,2)
            total_words = total_words + 1;
            confusion_matrix(tags_orig1(l),states(l)) = confusion_matrix(tags_orig1(l),states(l)) + 1;
            if(tags_orig2(l) ~=0)
                confusion_matrix(tags_orig2(l),states(l)) = confusion_matrix(tags_orig2(l),states(l)) + 1;
            end
            
            if(states(l) == tags_orig1(l))
                num_correct = num_correct + 1;
                if(unknown_array(l) == 1)
                    num_correct_unknown = num_correct_unknown + 1;
                end
            elseif(states(l) == tags_orig2(l))
                num_correct = num_correct + 1;
                if(unknown_array(l) == 1)
                    num_correct_unknown = num_correct_unknown + 1;
                end
            end
        end
        
%         %%
%         T = size(emiss,2);
%         viterbi = zeros(num_tags+1,T+1);
%         viterbi(1,1) = 1;
%         for t=2:T+1
%             for s=2:num_tags+1
%                 m = zeros(num_tags,1);
%                 
%                 for s_prev=2:num_tags+1
%                     if(t==2)
%                         m(s_prev-1,1) = viterbi(1,1)*p(s-1)*emiss(s-1,t-1);
%                     else
%                         m(s_prev-1,1) = viterbi(s_prev-1,t-1)*trans_mat(s_prev-1,s-1)*emiss(s-1,t-1);
%                     end
%                 end
%                 viterbi(s,t) = max(m);
%             end
%         end
%         if(max(sum(viterbi) == 0) == 0)
%             path_states = zeros(T,1);
%             path_states(T,1) = find(viterbi(:,T+1) == max(viterbi(:,T+1)));
%             for path=T:-1:2
%                 m = zeros(num_tags,1);
%                 for s=2:num_tags+1
%                     m(s-1,1) = viterbi(s,path)*trans_mat(s-1,path_states(path,1)-1);
%                 end
%                 path_states(path-1,1) = find(m == max(m)) + 1;
%             end
%             path_states = path_states' - 1;
%             for l=1:size(path_states,2)
%                 if(path_states(l) == tags_orig1(l))
%                     num_correct_viterbi = num_correct_viterbi + 1;
%                 elseif(states(l) == tags_orig2(l))
%                     num_correct_viterbi = num_correct_viterbi + 1;
%                 end
%             end
%         else
%             skip_words = skip_words + T;
%         end
   
        
    end
    line = fgets(f);
end
total_words
num_correct
% num_correct_viterbi

(num_correct/total_words)*100
num_unknown
num_correct_unknown
save('confusion_matrix.mat','confusion_matrix');
print_confusion
% num_correct_viterbi/total_words





