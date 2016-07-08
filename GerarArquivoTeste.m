
clear;
clc;

path2 = '/dados/traffic-signs';
path = 'C:\Users\LucasVital\Documents\Mestrado\Cognicao\Trabalho\FullIJCNN2013\TEST';

%-----------------------OPEN LABELS`S FILE---------------------------------
filename = 'gt.txt';
f = fopen(filename,'rt');               % 'rt' means read text
if (f < 0)
     error('could not open file');      % just abort if error
end;

% find length of longest line
nCols=6;                                
nRows=0;                                
s = fgetl(f);                           % get a line
while (ischar(s))                       
     nRows = nRows+1;
     s = fgetl(f);                      % get next line
end;

frewind(f);                             % rewind the file to the beginning
X = cell(nRows,nCols);                  % create an empty matrix of appropriate size
k = 1;
while ~feof(f)
    l = fgetl(f);
    cols = strsplit(l,';');
    for j=1:nCols
		X(k,j) = cols(j);
    end
    k = k + 1;
end
fclose(f);
%--------------------------------------------------------------------------
cont1 = 0;
cont0 = 0;
fileID = fopen('ImagesList_TESTE.txt','w');
for i = 853 : 1213 %index images test in gt.txt
    for k = 0 : 1
        name = X{i,1};
        if (i > 1) 
            nameAnt = X{i-1,1};
        else
            nameAnt = 'xxxxx.ppm';
        end

        if (nameAnt == name)
            continue;
        else
            contName = 0;
            strDir = strcat(path,'\',name(1:5),'\',num2str(k),'\',num2str(contName),'.png');

            while exist(strDir, 'file')
                pathImg = strcat(path2,'/',name(1:5),'/',num2str(k),'/',num2str(contName),'.png');
                if (k == 0)
                    fprintf(fileID,'%s %d \n',pathImg,k);
                    cont0 = cont0 + 1;
                else
                    fprintf(fileID,'%s %d \n',pathImg,k);
                    cont1 = cont1 + 1;
                end
                contName = contName + 1;
                strDir = strcat(path,'\',name(1:5),'\',num2str(k),'\',num2str(contName),'.png');
            end
        end
    end
end

disp(cont0);
disp(cont1);

fclose(fileID);
