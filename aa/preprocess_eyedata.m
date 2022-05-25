%% for ET data
%% load data
nun_data=8; name_data={'HL021010','HR022314','LL020812','LR022114','UL021615','UR020111','VL021714','VU020214'};
pathway='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\ET\Full_distance_radialtangential\Block1\eyedata\MATs\';
pathway_csv='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\ET\Full_distance_radialtangential\Block1\';
stim_name='_Dat_stim.mat';
tabname='_tab.mat';
csv_file_name='expResET_RadialBias_pilot1_';
csv_con_name={'HL.csv','HR.csv','LL.csv','LR.csv','UL.csv','UR.csv','VL.csv','VU.csv'};
loc={'loc_315','loc_135','loc_225','loc_45','loc_270','loc_90','loc_180','loc_0'};

%% 
total_cond_x=nan(4,200,1010,8);
total_cond_y=nan(4,200,1010,8);
cond_x=zeros(4,8);
cond_y=zeros(4,8);
for i = 1 : 8
    Dat_stim_name=sprintf('%s%s%s',pathway,name_data{i},stim_name);
    tab_name=sprintf('%s%s%s',pathway,name_data{i},tabname);
    filepath_csv=sprintf('%s%s%s',pathway_csv,csv_file_name,csv_con_name{i});
    M_csv=csvread(filepath_csv);
    Dat_stim=load(Dat_stim_name);
    tab_stim=load(tab_name);
    Dat_stim=Dat_stim.Dat_stim;
    tab=tab_stim.tab;
    a=tab(:,7)==0; 
    tab=tab(a,:);
    M_csv=M_csv(a,:);
    locat_num=unique(M_csv(:,3));
    tab_con=zeros(200,8,4);
    for f = 1:4 %4 locations
        b = M_csv(:,3) == locat_num(f);
        tab_con(:,:,f)=tab(b,:);
    end
    %Dat_stim=sortrows(Dat_stim,1);
    num_timepoints=sum(Dat_stim(:,1)>=tab_con(1,5,1) & Dat_stim(:,1)<=tab_con(1,5,1)+500);
    final_x = nan(4,200,num_timepoints+1);
    final_y = nan(4,200,num_timepoints+1);
    order_sum=[];
    for j = 1 : 4 
        for k = 1 : 200
            num=tab_con(k,5,j);
            order=num<=Dat_stim(:,1) & Dat_stim(:,1)<=num+500;
            order_sum=[order_sum,sum(order)];
            x=Dat_stim(order,2);
            y=Dat_stim(order,3);
            final_x(j,k,1:sum(order))=squeeze(squeeze(x));
            final_y(j,k,1:sum(order))=squeeze(squeeze(y)); 
            mean_final_x=mean(nanmean(final_x,3),2);
            mean_final_y=mean(nanmean(final_y,3),2);
        end
    end
    total_cond_x(:,:,1:size(final_x,3),i)=final_x;
    total_cond_y(:,:,1:size(final_y,3),i)=final_y;
    cond_x(:,i)=mean_final_x;
    cond_y(:,i)=mean_final_y;
end

%%for 3,6,8('LL020812','UR020111','VU020214') they don't have stimulus_on.

%% try use trail start get this data
total_cond_x=nan(4,200,1010,8);
total_cond_y=nan(4,200,1010,8);
cond_x=zeros(4,8);
cond_y=zeros(4,8);
for i = 1 : 8
    Dat_stim_name=sprintf('%s%s%s',pathway,name_data{i},stim_name);
    tab_name=sprintf('%s%s%s',pathway,name_data{i},tabname);
    filepath_csv=sprintf('%s%s%s',pathway_csv,csv_file_name,csv_con_name{i});
    M_csv=csvread(filepath_csv);
    Dat_stim=load(Dat_stim_name);
    tab_stim=load(tab_name);
    Dat_stim=Dat_stim.Dat_stim;
    tab=tab_stim.tab;
    a=tab(:,7)==0; 
    tab=tab(a,:);
    M_csv=M_csv(a,:);
    locat_num=unique(M_csv(:,3));
    tab_con=zeros(200,8,4);
    for f = 1:4 %4 locations
        b = M_csv(:,3) == locat_num(f);
        tab_con(:,:,f)=tab(b,:);
    end
    %Dat_stim=sortrows(Dat_stim,1);
    num_timepoints=sum(Dat_stim(:,1)>=tab_con(1,2,1)+1300 & Dat_stim(:,1)<=tab_con(1,2,1)+1800);
    final_x = nan(4,200,num_timepoints+1);
    final_y = nan(4,200,num_timepoints+1);
    order_sum=[];
    for j = 1 : 4 
        for k = 1 : 200
            num=tab_con(k,2,j)+1300;
            order=num<=Dat_stim(:,1) & Dat_stim(:,1)<=num+500;
            order_sum=[order_sum,sum(order)];
            x=Dat_stim(order,2);
            y=Dat_stim(order,3);
            final_x(j,k,1:sum(order))=squeeze(squeeze(x));
            final_y(j,k,1:sum(order))=squeeze(squeeze(y)); 
            mean_final_x=mean(nanmean(final_x,3),2);
            mean_final_y=mean(nanmean(final_y,3),2);
        end
    end
    total_cond_x(:,:,1:size(final_x,3),i)=final_x;
    total_cond_y(:,:,1:size(final_y,3),i)=final_y;
    cond_x(:,i)=mean_final_x;
    cond_y(:,i)=mean_final_y;
end

%% plot 
shape={'o','+','.','x','s','d','p','h'};
color=[1,0,0;0,1,0;0,0,1;0,0,0];
figure
for ii = 1 :8
    for jj = 1 :4
        hold on 
        scatter(cond_x(jj,ii),cond_y(jj,ii),'MarkerFaceColor',color(jj,:),'Marker',shape{ii})
        hold on
    end
end
scatter(576,435,'*')


%legend 
%{'o','+','.','x','s','d','p','h'} -- {'HL','HR','LL','LR','UL','UR','VL','VU'}
%{'red','green','blue','black'} -- {'loc_315','loc_135','loc_225','loc_45'} and {'loc_270','loc_90','loc_180','loc_0'}

%% create a movie
loc_movie=1;
trial_movie=1;
dir_movie=1;
x_movie=squeeze(squeeze(total_cond_x(loc_movie,trial_movie,:,dir_movie)));
y_movie=squeeze(squeeze(total_cond_y(loc_movie,trial_movie,:,dir_movie)));
x_movie(isnan(x_movie))=0; ord=find(x_movie); x_movie=x_movie(ord); y_movie=y_movie(ord);
max_x= max(x_movie); min_x=min(x_movie);
max_y= max(y_movie); min_y=min(y_movie);

mov(1:956)=struct('cdata',[],'colormap',[]);
v = VideoWriter('eyemovement2.avi');
open(v)
figure
for kk = 1:956
    plot(x_movie(1:kk),y_movie(1:kk))
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.2, 0.7,1])
    pause(0.1);
    mov(kk) = getframe(gcf);
    xlim([min_x,max_x])
    ylim([min_y,max_y])
end
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.2, 0.7,1])
% pause(0.1);
% mov(1:956/2) = getframe(gcf);
writeVideo(v,mov)
close(v)
clear mov