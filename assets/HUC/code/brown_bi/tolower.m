clear;
f = fopen('brown.txt');
line = fgets(f);
fid_w = fopen('brown_lower.txt','w');

% for j=1:15
while ischar(line)
    A = textscan(line,'%s','delimiter',[' ' '\t'],'BufSize',8000);
    str = horzcat(A{1}{1},9);
    for i = 2:size(A{1},1)
        C = textscan(A{1}{i},'%s','delimiter','/','BufSize',8000);
        if(size(C{1},1) == 2)
            str = horzcat(str,lower(C{1}{1}),'/',C{1}{2},32);
        else
            m = size(C{1},1);
            first_str = C{1}{1};
            for k = 2:m-1
                first_str = strcat(first_str,'/',C{1}{k});
            end
            str = horzcat(str,lower(first_str),'/',C{1}{m},32);
        end
    end
    fprintf(fid_w,'%s',str);
    fprintf(fid_w,'\n');
    
    line = fgets(f);
end

fclose(f);
fclose(fid_w);