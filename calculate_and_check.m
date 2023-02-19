function [stop, F_O, F_D] = calculate_and_check(hObject, handles, F_O, F_D, total_every_O_now, total_every_D_now)
%stop为哨兵，为true时do函数中循环停止，意味着满足误差要求，此函数为stop的bool值判断函数
    temp = true;
    for i = 1:handles.len_O
        F_O(i) = handles.total_every_O_future(i) / total_every_O_now(i);
    end
    for j = 1:handles.len_D
        F_D(j) = handles.total_every_D_future(j) / total_every_D_now(j);
    end
    for F = [F_O, F_D]
        for k = F
            if abs(1 - k) > handles.error
                temp = false;
            end
        end
    end
    stop = temp;
 end