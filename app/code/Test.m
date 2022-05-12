function char_a  = Test(filename, db_filename)%测试用途，实际应为 function char_a  = Test(filename,finger_database)
    thou = 0.3;
    load('trainedClassifier.mat')
    load(db_filename)
%     finger_database = finger_database;%若是.mat文件名不为finger_database，需要把右边的名字替换掉
    fc=[-28,-26,-24,-22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,-1,...
    1,3,5,7,9,11,13,15,17,19,21,23,25,27,28];
    band=312500;
    P=[];
    % cacu=zeros(10,1);
    % for t=1:length(csilist)
    for t=1:1
    % for t=[1 2 3 7 8 11 14 16 17 18 19 20]
        csi_trace = read_bf_file(filename);
        csi_phase_all=zeros(length(csi_trace),30);
        n=2;
        % hangshu=floor(length(csi_trace)/200);
        hangshu=1;
        if length(csi_trace)>=2000
            start=1001;
        else
            start=1;
        end
        for index=1:hangshu
            count=1;
            phase_set=[];
            for i=(start-1+(1+200*(index-1))):(start-1+(1+200*(index-1))+199)
                csi_entry = csi_trace{i};
                point=2;
            %     point=find(csi_entry.perm==1);
                csi=squeeze(get_scaled_csi(csi_entry));
                if csi_entry.Ntx==2
                    csi=squeeze(csi(1,:,:));
                end
                csi_phase=angle(csi);
                temp=(csi_phase(point,:));
                ph_line=unwrap(temp);
                center=(ph_line(15)+ph_line(16))/2;
                ph_normalization=ph_line-center;
                decision=derivative(fc,ph_normalization);
                if legal(decision)
                     ph_normalization=phase_normalization(ph_normalization);
                     phase_set(count,:)=ph_normalization;
                     count=count+1;
                end
            end
            ph_average=mean(phase_set,1);
            int_phase=ph_average;
            ptrain=[int_phase,(ceil(t/1))];
            P(hangshu*(t-1)+index,:)=ptrain;
        end
    end
    Ptemp=P;
    Ptemp = Ptemp(:, 1:30);
    Distance=[];
    for i = 1:size(finger_database, 1)
        Distance(i) =  dist_E(Ptemp,(finger_database(i,1:30))); 
    end
    if min(Distance)<=thou
        Distance_mindex = find(Distance == min(Distance));
        device_index = finger_database(Distance_mindex,31);
        char_a = sprintf('%s%s%d','此设备是合法设备,','可能的设备编号是：',device_index);
    else
        char_a = '此设备是非法设备';
    end  
end
% 方法1
function dist = dist_E(x,y)
dist = [];
if(length(x)~=length(y))
    disp('length of input vectors must agree')  % disp函数会直接将内容输出在Matlab命令窗口中
else
    z =(x-y).*(x-y);
    dist = sqrt(sum(z));
end
end
