function OD_final = do(hObject, handles, F_O, F_D, OD_now, stop, total_every_O_now, total_every_D_now)
log_name = 'result.log';
full_path = [pwd, '\', log_name];
fid=fopen(full_path, 'a+');
fprintf(fid, ['*******************************', '\n', datestr(now,0), '\n', 'Method : ', handles.method, '\n']);
fprintf(fid, ['*******************************', '\n\n']);
while ~stop %迭代开始
    [total_every_O_now, total_every_D_now, OD_now] = fun(hObject, handles, F_O, F_D, OD_now, total_every_O_now, total_every_D_now); %当前轮次迭代所得OD表
    [stop, F_O, F_D] = calculate_and_check(hObject, handles, F_O, F_D, total_every_O_now, total_every_D_now); %得到哨兵变量stop和误差向量
    write(hObject, handles, fid, OD_now, F_O, F_D); %日志写入
    handles.number = handles.number + 1; %轮次计数变量+1
end
OD_final = OD_now;
fprintf(fid, ['*******************************', '\n\n\n\n']);
fclose(fid);
end