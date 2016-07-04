
path = '\TRAIN\';    


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
%---------------------------READ IMAGES------------------------------------
scaleX = {'16x16','32x32','64x64','96x96','128x128'};
tamJanela = [16,32,64,96,128];   
for j = 1 : 5 %number of scales
    scale = scaleX{j};
    tJanela = tamJanela(j);
    for ii = 1 : 852 %indice da ultima imagem de treino listada no arquivo gt.txt
        name = X{ii,1};
        img = imread(strcat(path,X{ii,1}));
        [r,c,z] = size(img);
        strDir = strcat(path,scale,'\',name(1:5));
        strDir1 = strcat(strDir,'\1\');

        if ~exist(strDir, 'dir')
            mkdir(strDir);
        end
        if ~exist(strDir1, 'dir')
            mkdir(strDir1);
        end
        contName1 = 0;
        imgAuxX = uint8(zeros(tJanela,tJanela,3));

        ladoEsq = str2num(X{ii,2});
        ladoSup = str2num(X{ii,3});
        ladoDir = str2num(X{ii,4}); 
        ladoInf = str2num(X{ii,5}); 
        areaAnotacao = (ladoInf - ladoSup)*(ladoDir-ladoEsq);
        areaKernel = tJanela*tJanela;
        disp([X{ii,1} num2str(ladoSup-ladoInf) 'x' num2str(ladoDir-ladoEsq)]);

        if (((areaKernel*0.25) > (areaAnotacao * 0.7)) && (areaKernel <= areaAnotacao)) || ((areaKernel >= areaAnotacao) && ((areaKernel) < (areaAnotacao * 4)))   
            for iii = ladoSup + round((ladoInf-ladoSup)*0.33) : 2 : ladoInf - round((ladoInf-ladoSup)*0.33)
                for jjj = ladoEsq + round((ladoDir-ladoEsq)*0.33): 2 : ladoDir - round((ladoDir-ladoEsq)*0.33)
                    if (ladoEsq-(tJanela/2) >= 0 && jjj + tJanela - 1  <= c)
                        if (ladoSup-(tJanela/2)>= 0 && iii + tJanela - 1 <= r)     
                            imgAuxX(:,:,:) = img(iii-(tJanela/2):iii+(tJanela/2)-1,jjj-(tJanela/2):jjj+(tJanela/2)-1,:);                                                                 
                            nomeImg = strcat(strDir1,num2str(contName1));
                            img32 = imresize(imgAuxX, [64 NaN]);
                            imwrite(img32,strcat(nomeImg,'.png'));    
                            contName1 = contName1 + 1;
                        end
                    end      
                end
            end
        end
    end
end