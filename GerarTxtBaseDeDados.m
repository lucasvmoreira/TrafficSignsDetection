clear;
clc;

path2 = '/dados/traffic-signs';
path = 'C:\Users\LucasVital\Documents\Mestrado\Cognicao\Trabalho\FullIJCNN2013\TRAIN\';

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
scaleX = {'16x16','32x32','64x64','96x96','128x128'};
fileID = fopen('ImagesList.txt','w');
for j = 1 : 5 %number of scales
    scale = scaleX{j};
    for i = 1 : 852 %index of the last image of type train in gt.txt
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
                strDir = strcat(path,scale,'\',name(1:5),'\',num2str(k),'\',num2str(contName),'.png');
                
                while exist(strDir, 'file')
                    pathImg = strcat(path2,'/',scale,'/',name(1:5),'/',num2str(k),'/',num2str(contName),'.png');
                    if (k == 0)
                        fprintf(fileID,'%s %d \n',pathImg,k);
                    else
                        fprintf(fileID,'%s %d \n',pathImg,k);
                    end
                    contName = contName + 1;
                    strDir = strcat(path,scale,'\',name(1:5),'\',num2str(k),'\',num2str(contName),'.png');
                end
            end
        end
    end
end

fclose(fileID);


%-----------------------OPEN LABELS`S FILE---------------------------------
filename = 'ImagesList.txt';
f = fopen(filename,'rt');               % 'rt' means read text
if (f < 0)
     error('could not open file');      % just abort if error
end;

% find length of longest line
nCols=2;                                
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
    cols = strsplit(l,' ');
    for j=1:nCols
		X(k,j) = cols(j);
    end
    k = k + 1;
end
fclose(f);
%--------------------------------------------------------------------------

fileID0 = fopen('ImagesList0.txt','w');
cont1 = 0;
cont0 = 0;
for i = 1 : nRows 
    tipoImg = X{i,2};
    tipoImg = str2num(tipoImg);
    
    if (tipoImg == 1) 

        cont1 = cont1 + 1;
    else
        fprintf(fileID0,'%s %s \n',X{i,1},X{i,2});
        cont0 = cont0 + 1;
    end
end
fclose(fileID0);

%-----------------------OPEN LABELS`S FILE---------------------------------
filename = 'ImagesList0.txt';
f = fopen(filename,'rt');               % 'rt' means read text
if (f < 0)
     error('could not open file');      % just abort if error
end;

% find length of longest line
nCols=2;                                
nRows=0;                                
s = fgetl(f);                           % get a line
while (ischar(s))                       
     nRows = nRows+1;
     s = fgetl(f);                      % get next line
end;

frewind(f);                             % rewind the file to the beginning
Y = cell(nRows,nCols);                  % create an empty matrix of appropriate size
k = 1;
while ~feof(f)
    l = fgetl(f);
    cols = strsplit(l,' ');
    for j=1:nCols
		Y(k,j) = cols(j);
    end
    k = k + 1;
end
fclose(f);
%--------------------------------------------------------------------------

%-----------------------OPEN LABELS`S FILE---------------------------------
filename = 'ImagesList1.txt';
f = fopen(filename,'rt');               % 'rt' means read text
if (f < 0)
     error('could not open file');      % just abort if error
end;

% find length of longest line
nCols=2;                                
nRows=0;                                
s = fgetl(f);                           % get a line
while (ischar(s))                       
     nRows = nRows+1;
     s = fgetl(f);                      % get next line
end;

frewind(f);                             % rewind the file to the beginning
Z = cell(nRows,nCols);                  % create an empty matrix of appropriate size
k = 1;
while ~feof(f)
    l = fgetl(f);
    cols = strsplit(l,' ');
    for j=1:nCols
		Z(k,j) = cols(j);
    end
    k = k + 1;
end
fclose(f);
%--------------------------------------------------------------------------

Y = Y(randperm(cont0),:);%shuffle matrix
Z = Z(randperm(cont1),:);%shuffle matrix

fileIDTrain0 = fopen('ImagesList0Train.txt','w');
fileIDTrain1 = fopen('ImagesList1Train.txt','w');
fileIDTest0 = fopen('ImagesList0Test.txt','w');
fileIDTest1 = fopen('ImagesList1Test.txt','w');

cont1_70perc = round(0.7 * cont1);
cont0_70perc = round(0.35 * cont0);

for i = 1 : cont1_70perc
    fprintf(fileIDTrain1,'%s %s \n',Z{i,1},Z{i,2});
end
for i = 1 : cont0_70perc
    fprintf(fileIDTrain0,'%s %s \n',Y{i,1},Y{i,2});
end

for i = cont1_70perc + 1 : (cont1)
    fprintf(fileIDTest1,'%s %s \n',Z{i,1},Z{i,2});
end
for i = cont0_70perc + 1 : (cont0_70perc + 25000)
    fprintf(fileIDTest0,'%s %s \n',Y{i,1},Y{i,2});
end
fclose(fileIDTrain0);
fclose(fileIDTrain1);
fclose(fileIDTest0);
fclose(fileIDTest1);