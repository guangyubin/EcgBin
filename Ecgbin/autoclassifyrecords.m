%%
path = 'D:\MGCDB\CAREB0\DataFromServer';

ddd = dir(fullfile(path));
m =  1; 
nn = 1;
for aa = 3:length(ddd)  
    
    filelist = dir(fullfile(path,ddd(aa).name,'*.dat'));
    for ii = 1:length(filelist)
        if filelist(ii).bytes > 50000
            try
                fname = fullfile(path,ddd(aa).name,filelist(ii).name);
%                 matmgc('creat_qrs',fname(1:end-4));
%                 matmgc('creat_xml',fname(1:end-4));
                m = m +1;
                
                report = loadmgcxml(fname(1:end-4));
                nerror = 1; 
                for kk = 1:length(report.AnnWarning.descript)
                    if strfind(report.AnnWarning.descript{kk},'房颤')
                        disp('房颤');
                        copyfile([fname(1:end-4) '.xml'], 'D:\MGCDB\CAREB0\ErrorAF');
                        copyfile([fname(1:end-4) '.dat'], 'D:\MGCDB\CAREB0\ErrorAF');
                        copyfile([fname(1:end-4) '.hea'], 'D:\MGCDB\CAREB0\ErrorAF');
                        copyfile([fname(1:end-4) '.qrs'], 'D:\MGCDB\CAREB0\ErrorAF');
                        nerror = nerror+1;
                    end
                    if strfind(report.AnnWarning.descript{kk},'室上性心动过速')
                        disp('室上性心动过速');
                        copyfile([fname(1:end-4) '.xml'], 'D:\MGCDB\CAREB0\ErrorSVT');
                        copyfile([fname(1:end-4) '.dat'], 'D:\MGCDB\CAREB0\ErrorSVT');
                        copyfile([fname(1:end-4) '.hea'], 'D:\MGCDB\CAREB0\ErrorSVT');
                        copyfile([fname(1:end-4) '.qrs'], 'D:\MGCDB\CAREB0\ErrorSVT');
                          nerror = nerror+1;
                    end
                    if strfind(report.AnnWarning.descript{kk},'室性三联律')
                        disp('室性三联律');
                        copyfile([fname(1:end-4) '.xml'], 'D:\MGCDB\CAREB0\ErrorVETrigeminy');
                        copyfile([fname(1:end-4) '.dat'], 'D:\MGCDB\CAREB0\ErrorVETrigeminy');
                        copyfile([fname(1:end-4) '.hea'], 'D:\MGCDB\CAREB0\ErrorVETrigeminy');
                        copyfile([fname(1:end-4) '.qrs'], 'D:\MGCDB\CAREB0\ErrorVETrigeminy');
                          nerror = nerror+1;
                    end
                    if strfind(report.AnnWarning.descript{kk},'室性二联律')
                        disp('室性二联律');
                        copyfile([fname(1:end-4) '.xml'], 'D:\MGCDB\CAREB0\ErrorVEBigeminy');
                        copyfile([fname(1:end-4) '.dat'], 'D:\MGCDB\CAREB0\ErrorVEBigeminy');
                        copyfile([fname(1:end-4) '.hea'], 'D:\MGCDB\CAREB0\ErrorVEBigeminy');
                        copyfile([fname(1:end-4) '.qrs'], 'D:\MGCDB\CAREB0\ErrorVEBigeminy');
                          nerror = nerror+1;
                    end
                    if strfind(report.AnnWarning.descript{kk},'室性心动过速')
                        disp('室性心动过速');
                        copyfile([fname(1:end-4) '.xml'], 'D:\MGCDB\CAREB0\ErrorVT');
                        copyfile([fname(1:end-4) '.dat'], 'D:\MGCDB\CAREB0\ErrorVT');
                        copyfile([fname(1:end-4) '.hea'], 'D:\MGCDB\CAREB0\ErrorVT');
                        copyfile([fname(1:end-4) '.qrs'], 'D:\MGCDB\CAREB0\ErrorVT');
                          nerror = nerror+1;
                    end
                    if strfind(report.AnnWarning.descript{kk},'停搏')
                        disp('停搏');
                        copyfile([fname(1:end-4) '.xml'], 'D:\MGCDB\CAREB0\ErrorPause');
                        copyfile([fname(1:end-4) '.dat'], 'D:\MGCDB\CAREB0\ErrorPause');
                        copyfile([fname(1:end-4) '.hea'], 'D:\MGCDB\CAREB0\ErrorPause');
                        copyfile([fname(1:end-4) '.qrs'], 'D:\MGCDB\CAREB0\ErrorPause');
                          nerror = nerror+1;
                    end
                end
                if   nerror ==1 
                    nn = nn +1;
                end
            catch
%                 disp(['error' filelist(ii).name]);
%                 copyfile([fname(1:end-4) '.xml'], 'D:\MGCDB\CAREB0\ErrorSystem');
%                 copyfile([fname(1:end-4) '.dat'], 'D:\MGCDB\CAREB0\ErrorSystem');
%                 copyfile([fname(1:end-4) '.hea'], 'D:\MGCDB\CAREB0\ErrorSystem');
%                 copyfile([fname(1:end-4) '.qrs'], 'D:\MGCDB\CAREB0\ErrorSystem');
            end
        end
    end
end