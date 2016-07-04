clear;
clc;

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

for j =1 : 5 %number of scales
    scale = scaleX{j};
    tJanela = tamJanela(j); 
    i = 1;
	while (i <= 852) %nRows
		name = X{i,1};
		nameAux = X{i,1};
		img = imread(strcat(path,X{i,1}));
		disp(X{i,1});
		
		strDir = strcat(path,scale,'\',name(1:5));
        strDir0 = strcat(strDir,'\0\');
	   
		if ~exist(strDir, 'dir')
			mkdir(strDir);
		end
		if ~exist(strDir0, 'dir')
			mkdir(strDir0);
        end
		[r,c,z] = size(img);  
		imgAux = uint8(zeros(800,c));
		while(name == nameAux)
		  ladoEsq = str2num(X{i,2});
		  ladoSup = str2num(X{i,3});
		  ladoDir = str2num(X{i,4}); 
		  ladoInf = str2num(X{i,5}); 
		  for ii = ladoSup : ladoInf
			for jj = ladoEsq : ladoDir
				imgAux(ii,jj) = 255;
			end
		  end
		  nameAux = X{i + 1,1};
		  i = i + 1;
		end
	   
		%-------------Janela 16x16 de captura---------------
		contName1 = 0;
		contName0 = 0;
		ii = 1;
		jj = 1;
		contBranco = 0;
		imgAuxX = uint8(zeros(tJanela,tJanela,3));
		

		while (ii + (tJanela - 1) < r)
			jj = 1;
			while (jj + (tJanela - 1) < c)           
				contBranco = nnz(imgAux(ii:ii+tJanela-1, jj:jj+tJanela-1));
				imgAuxX(:,:,:) = img(ii:ii+tJanela-1,jj:jj+tJanela-1,:);                       
				if (contBranco == 0)
					nomeImg = strcat(strDir0,num2str(contName0));
					img64 = imresize(imgAuxX, [64 NaN]);
					imwrite(img64,strcat(nomeImg,'.png'));    
					contName0 = contName0 + 1;   
				end        
				jj  = jj + (tJanela*4);
			end
			ii = ii + (tJanela*4);
		end
    end
end
%--------------------------------------------------------------------------