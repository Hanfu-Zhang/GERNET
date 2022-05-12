format long;
% csilist={'data_3_1.dat','data_3_2.dat','data_3_3.dat','data_3_4.dat'...
%     'data_3_5.dat','data_3_6.dat','data_3_7.dat','data_3_8.dat','data_3_9.dat','data_3_10.dat'};
% csilist=read_csilist('csilist.txt');
% csilist=read_csilist('csilist522.txt');
csilist=read_csilist('all.txt');
% csilist=read_csilist('514_nic.txt');
% load('Subspace_Discriminant_4_10_12.mat');
% csilist={'csi_fake.dat'};
% csilist=read_csilist('csilistexp2.txt');
fc=[-28,-26,-24,-22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,-1,...
    1,3,5,7,9,11,13,15,17,19,21,23,25,27,28];
band=312500;
freq=fc*band+2.442*10^9;
temp_y=zeros(1,30);
start=1;
% fitr={};gosr={};
unlegal=[];
P=[];
% cacu=zeros(10,1);
% for t=1:length(csilist)
for t=1:30
% for t=[1 2 3 7 8 11 14 16 17 18 19 20]
    csi_trace = read_bf_file(csilist{t});
    csi_phase_all=zeros(length(csi_trace),30);
    n=2;
    % hangshu=floor(length(csi_trace)/200);
    hangshu=5;
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
Ptemp(111:112,:)=[];
% t_p = 130;
% n = randperm(size(Ptemp,1));
% train_data = Ptemp(n(1:t_p),1:30);
% test_data = Ptemp(n((t_p+1):end),1:30);
% train_label = Ptemp(n(1:t_p),31);
% test_label = Ptemp(n((t_p+1):end),31);
% [bestacc1,bestc1,bestg1] = lhj_SVMcg(train_label,train_data);
% %b_va=1;
% %cmd1 = ['-c ',num2str(bestc1),' -g ',num2str(bestg1),' -b ',num2str(b_va)];
% % format compact;
% % % ºË¾ØÕó
% % [trainRow,dim]=size(train_data);
% % [testRow,dim2]=size(test_data);
% % gamma=bestg1;
% % Ktrain=zeros(trainRow,trainRow);
% % %[~,~,gamma] = lhj_SVMcg(train_label,train_data);
% % for i=1:trainRow
% %     for j=1:trainRow
% % %Ktrain(i,j) = exp(-gamma*norm(train_data(i,:)-train_data(j,:))^2); 
% % Ktrain(i,j) = exp(-gamma*(dtw(train_data(i,1:(find(train_data(i,:)==inf))-1),train_data(j,1:(find(train_data(j,:)==inf))-1))^2)); 
% %     end
% % end
% % %Ktrain=[(1:trainRow)',Ktrain];
% % Ktest=zeros(testRow,trainRow);
% % for i=1:testRow
% %     for j=1:trainRow
% %         %Ktest(i,j) = exp(-gamma*norm(test_data(i,:)-train_data(j,:))^2); 
% % Ktest(i,j) = exp(-gamma*(dtw(test_data(i,1:(find(test_data(i,:)==inf))-1),train_data(j,1:(find(train_data(j,:)==inf))-1))^2)); 
% %     end
% % end
% % %Ktest=[(1:testRow)',Ktest];
% % [bestacc2,bestc2,bestg2] = lhj_SVMcg(train_label,Ktrain);
% cmd = ['-c ',num2str(bestc1),' -g ',num2str(bestg1)];
% model_precomputed = svmtrain(train_label, train_data,cmd);
% [predict_label, accuracy, dec_values] = svmpredict(test_label, test_data, model_precomputed);
% right = 0;
% total = size(test_label,1);
% for i=1:total
%     if test_label(i) == predict_label(i)
%       right = right + 1;  
%     end
% end
% test_acc = right/total * 100
% 




