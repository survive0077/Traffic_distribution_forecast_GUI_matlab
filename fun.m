function [Oi, Di, OD_now] = fun(hObject, handles, F_O, F_D, OD_now, total_every_O_now, total_every_D_now)
%具体算法原理请看《交通规划》第二版 东南大学 王炜 陈学武
    if strcmpi(handles.method, 'Average') %平均增长系数法
        for i = 1:handles.len_O
            for j = 1:handles.len_D
                f = (F_O(i) + F_D(j)) / 2;
                OD_now(i, j) = round(OD_now(i, j) * f, handles.num);
            end
        end
        Oi = sum(OD_now, 2); Di = sum(OD_now);
    end

    if strcmpi(handles.method, 'Detroit') %底特律法
        total_now = sum(sum(OD_now));
        G = total_now / handles.total_future;
        for i = 1:handles.len_O
            for j = 1:handles.len_D
                OD_now(i, j) = round(OD_now(i, j) * F_O(i) * F_D(j) * G, handles.num);
            end
        end
        Oi = sum(OD_now, 2); Di = sum(OD_now);
    end

    if strcmpi(handles.method, 'Fratar') %福莱特法
        Li = zeros(1, handles.len_D);
        Lj = zeros(1, handles.len_O);
        for i = 1:length(Li)
            d = dot(OD_now(i, :), F_D);
            Li(i) = total_every_O_now(i) / d;
        end
        for j = 1:length(Lj)
            d = dot(OD_now(:, j), F_O);
            Lj(j) = total_every_D_now(j) / d;
        end
        for i = 1:handles.len_O
            for j = 1:handles.len_D
                OD_now(i, j) = round(OD_now(i, j) * F_O(i) * F_D(j) * (Li(i) + Lj(j)) / 2, handles.num);
            end
        end
        Oi = sum(OD_now, 2); Di = sum(OD_now);
    end

    if strcmpi(handles.method, 'Furness') %弗尼斯法
        if handles.number == 1
            total_D_temp = handles.total_every_D_future;
            for i = 1:handles.len_O
                for j = 1:handles.len_D
                    OD_now(i, j) = round(OD_now(i, j) * F_O(i), handles.num);
                end
            end
            Oi = total_every_O_now; Di = total_D_temp;
        else
            if rem(handles.number, 2) == 0
                total_D_temp = sum(OD_now);
                for j = 1:handles.len_D
                    F_D_j = handles.total_every_D_future(j) / total_D_temp(j);
                    for i = 1:handles.len_O
                        OD_now(i, j) = round(OD_now(i, j) * F_D_j, handles.num);
                    end
                end
                total_O_temp = sum(OD_now, 2);
                Oi = total_O_temp; Di = total_D_temp;
            else
                total_O_temp = sum(OD_now, 2);
                for i = 1:handles.len_O
                    F_D_i = handles.total_every_O_future(i) / total_O_temp(i);
                    for j = 1:handles.len_D
                        OD_now(i, j) = round(OD_now(i, j) * F_D_i, handles.num);
                    end
                end
                total_D_temp = sum(OD_now);
                Oi = total_O_temp; Di = total_D_temp;
            end
        end
    end
end