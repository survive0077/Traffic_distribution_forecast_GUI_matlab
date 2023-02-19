function write(hObject, handles, fid, OD_now, F_O, F_D)
%日志文件写入每轮迭代结果
fprintf(fid,['Round ', int2str(handles.number),':\n']);
fprintf(fid,['OD_now :\n', mat2str(OD_now), '\n']);
fprintf(fid,['F_O :\n', mat2str(F_O), '\n']);
fprintf(fid,['F_D :\n', mat2str(F_D), '\n']);
fprintf(fid,'\n');
end