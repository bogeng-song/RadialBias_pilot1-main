%% this script just want to try function
%%session SX-LL
%%'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\SX\Full_distance_radialtangential\Block1\eyedata\MATs'
path_blink='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\SX\Full_distance_radialtangential\Block1\eyedata\MATs\LL110912_blink.mat';
data_path='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\SX\Full_distance_radialtangential\Block1\eyedata\MATs\LL110912_Dat_all.mat';
new_data=omitblinks(data_path,path_blink);
tab_path='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\SX\Full_distance_radialtangential\Block1\eyedata\MATs\LL110912_tab_new_outside_blink.mat';
load(tab_path)
load(new_data)
%screenCenter = [ScreenSpecs.screenWidthPx/2 ScreenSpecs.screenHeightPx/2];  % screen center (intial fixation position)
%dvaPerPx = atan2(1,ScreenSpecs.distanceFromScreen)*180/pi/ScreenSpecs.screenWidthPx * ScreenSpecs.screenWidthCm; % degrees per pixel

distanceFromScreen = 60;   % Abstand zum Monitor in cm % Monitor distanceFromScreen in cm
screenWidthCm = 22.9;     % x Monitor Breite in cm % width of the CRT display area in cm
screenWidthPx = 1152;      % x-Aufloesung des Stimulus-Screens % x-resolution of the screen in pixels
screenHeightPx = 864;     % y-Aufloesung des Stimulus-Screens % y-resolution of the screen in pixels
screenCenter = [screenWidthPx/2 screenHeightPx/2];  % screen center (intial fixation position)
dvaPerPx = atan2(1,distanceFromScreen)*180/pi/screenWidthPx * screenWidthCm; % degrees per pixel

col_dva=nan(size(Dat_all,1),2);
velo=nan(size(Dat_all,1),2);

VFAC=[3,3]; 
MINDUR=6;
mergeInterval=10;
threshold_AM=[0.3,1];
msg_filepath='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\SX\Full_distance_radialtangential\Block1\eyedata\LL110912.msg';
samplingRateData=findSamplingRate(msg_filepath);

numBlink=[];
MS=[];

for i = 1 : 800
    order = tab(i,2) < Dat_all(:,1) & tab(i,8) > Dat_all(:,1);
    trial= Dat_all(order,:);
    new_trial=segmentnonBlinks2(trial);
    k=new_trial(:,6);
    num_seg=unique(k(~isnan(new_trial(:,5))));
    numBlink=[numBlink,size(num_seg,1)];
    for j = 1 : size(num_seg,1)
        ord=k==num_seg(j);
        o=find(ord);
        trial_seg=new_trial(ord,:);
        if sum(isnan(trial_seg(:,5)))==0
            x=dvaPerPx*(trial_seg(:,2)-screenCenter(1));
            y=dvaPerPx*(trial_seg(:,3)-screenCenter(2));
            if size(x,1) > 105
                x_fil=filtfilt(fir1(35,0.05),1,x);
                y_fil=filtfilt(fir1(35,0.05),1,y);
%             col_dva(o,1)=x_fil;
%             col_dva(o,2)=y_fil;
                d=[x_fil,y_fil];
                v = computevelocity(d,samplingRateData); 
            
            %velo(o,:)=v;
                [msac, radius] = microsaccMerge_absolute(d,v,VFAC,MINDUR,mergeInterval);
                if isempty(msac)==0
                    num_seg_start=msac(:,1);
                    num_seg_end=msac(:,2);
                    trail_start=num_seg_start+o(1)-1;
                    trail_end=num_seg_end+o(1)-1;
                    num_trial = ones(size(num_seg_start))*i;
                    msac=[msac,trail_start,trail_end,num_trial];
                    MS=[MS;msac];
                    MS_fil=filterAM(MS,threshold_AM);
                end
            end
        end
%         col_dva(o,1)=x_fil;
%         col_dva(o,2)=y_fil;
%         Dat_all=[Dat_all,col_dva,velo];
    end
    
end      
            