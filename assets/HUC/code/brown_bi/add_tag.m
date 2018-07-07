function [ str ] = add_tag(row, curr_tag, prev_tag)

if(isempty(row))
    if(~isempty(prev_tag))
        new_str = horzcat(curr_tag,'/',prev_tag,'/1');
    else
        new_str = horzcat(curr_tag,'/1');
    end
    str = new_str;
    return;
end

A = textscan(row,'%s','delimiter',' ','BufSize',8000);

found = 0;

for i=1:size(A{1},1)
    C = textscan(A{1}{i},'%s','delimiter','/');
    if(strcmp(curr_tag,C{1}{1}))
        if(isempty(prev_tag) && size(C{1},1) == 2)
            found = 1;
            count = str2double(C{1}{2}) + 1;
            C{1}{2} = num2str(count);
        end
        if(~isempty(prev_tag) && size(C{1},1) == 3 )
            if(strcmp(prev_tag,C{1}{2}))
                found = 1;
                count = str2double(C{1}{3}) + 1;
                C{1}{3} = num2str(count);
            end
        end
    end
    if(found == 1)
        new_str = C{1}{1};
        for j=2:size(C{1},1)
            new_str = horzcat(new_str,'/',C{1}{j});
        end
        A{1}{i} = new_str;
        break;
    end
end

if(found == 0)
    if(~isempty(prev_tag))
        new_str = horzcat(curr_tag,'/',prev_tag,'/1');
    else
        new_str = horzcat(curr_tag,'/1');
    end
    if(size(A{1},1) == 1)
        temp = A{1}{1};
        r = 'asd dd';
        A = textscan(r,'%s','delimiter',' ');
        A{1}{1} = temp;
        A{1}{2} = new_str;
    else
        A{1}{size(A{1},1)+1} = new_str;
    end
end
% A
% size(A{1},1)
str = A{1}{1};
for i=2:size(A{1},1)
    str = horzcat(str,' ',A{1}{i});
end
% str
return;

end

