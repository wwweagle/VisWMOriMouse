function Ori(SubjID,PosID,recording)
  if SubjID==0
    Screen('Preference', 'SkipSyncTests', 1);
  end

if recording==1   
    daq.getDevices   
    s=daq.createSession('ni');
    s.addDigitalChannel('Dev2','Port1/Line0:7','OutputOnly');
    s.outputSingleScan([0 0 0 0 0 0 0 0]) % sample cue, up,down,left, right, enter,NA,NA
    signalDuratoin=0.002;
else
    signalDuratoin=0;
    s=0;
end
tmpTime = clock;
%Screen('Preference', 'SkipSyncTests', 1)
Screen('Preference','SyncTestSettings' , maxStddev=0.01, minSamples=30, maxDeviation=0.2, maxDuration=10);
screenNum = max(Screen('Screens'));
[wPtr,rect]=Screen('OpenWindow',screenNum);
flipInterval=Screen('GetFlipInterval', wPtr);
white = WhiteIndex(wPtr);
grey = [80 80 80];

Screen('FillRect',wPtr,grey);
Screen(wPtr, 'Flip');
ShowCursor(2)
Screen('TextFont', wPtr ,'Times New Roman');

%%
OriCuePos = [rect(3)/2-225 rect(4)/2-160; rect(3)/2-75 rect(4)/2-165;  rect(3)/2+75 rect(4)/2-155; rect(3)/2+230 rect(4)/2-160;...
            rect(3)/2-230 rect(4)/2;     rect(3)/2-80 rect(4)/2-5;    rect(3)/2+70 rect(4)/2+10;  rect(3)/2+220 rect(4)/2;...
            rect(3)/2-220 rect(4)/2+160; rect(3)/2-77 rect(4)/2+165;  rect(3)/2+72 rect(4)/2+170; rect(3)/2+220 rect(4)/2+160];
OriCueColor = [255 0 0; 0 255 0; 0 0 255; 255 255 0; 0 255 255; 255 0 255; 255 255 255];

CueNum = 1:6;  
OriStampCue = [];
OriStampCR = [];
OriStampButton = [];
repeatTime = 5;
OriResult = zeros(length(CueNum),repeatTime);       
OriRTResult = zeros(length(CueNum),repeatTime);  
OriFTResult = zeros(length(CueNum),repeatTime);  
OriConfiResult=zeros(length(CueNum),repeatTime);
%%
Number = repeatTime*ones(1,length(CueNum));

ShowCursor(2)
Screen('FillRect',wPtr,grey);
Screen(wPtr, 'Flip');
startTime=GetSecs;
TrialNum = 0;
%%
for  itr0 = 1:length(CueNum)     
    for itr1 = 1:Number(itr0)        
        
        TrialNum = TrialNum + 1;    
        OriColorList = randperm(size(OriCueColor,1));
        [CuePosList,CueAngle,OriTarget,TargetAng,OriTargetPos,RotationAngle]...
            = OriCueSet(CueNum,itr0);
       
        [OriStampCue,OriStampCR] = OriCue(wPtr,CueNum,OriCuePos,CuePosList,CueAngle,TrialNum,...
            startTime,OriStampCue,OriStampCR,OriTarget,itr0,OriColorList,OriCueColor);           
        Screen(wPtr, 'Flip');       
        if recording==1  % sample on
            EventTrigger(1,0,0,0,0,0,0,0,signalDuratoin,s);      
        end
        tic
        while toc<flipInterval*120
        end

        Screen('FillRect',wPtr,grey);
        Screen(wPtr, 'Flip');
        if recording==1 % delay
            EventTrigger(0,1,0,0,0,0,0,0,signalDuratoin,s);      
        end
        tic
        while toc<flipInterval*180
        end
        
        RespTime = GetSecs-startTime;   
        [RespAng,RT,FT,firstResp,finish] = OriTest(wPtr,OriTargetPos,RotationAngle,OriCuePos,...
            rect,OriTarget,OriCueColor,OriColorList,recording,signalDuratoin,s);  
       
        [value,confidence] = OriFeedBack(wPtr,finish,RespAng,TargetAng,flipInterval,white,rect);        
     
        OriResult(itr0,itr1) = value;
        OriConfiResult(itr0,itr1)=confidence;
        OriRTResult(itr0,itr1) = RT;  
        OriFTResult(itr0,itr1) = FT;  
        OriStampButton = [OriStampButton;TrialNum,RespTime,firstResp,finish,RT,FT,RespAng];        

        if recording==1   % ITI
            EventTrigger(0,0,0,0,0,0,1,0,signalDuratoin,s);           
        end 
        [quit] = ITI(wPtr,grey,white,rect);  
         if quit == 1  
             break
         end   
    end
    
    if quit == 1 
        break
    end
    
end
%%
Screen('CloseAll'); 
fnTime = cell(1,5);
for i = 1:5
    if i == 5
        if tmpTime(i+1)<10
            fnTime{i} = ['0',num2str(round(tmpTime(i+1)))];
        else
            fnTime{i} = num2str(round(tmpTime(i+1)));
        end
    else
        if tmpTime(i+1)<10
            fnTime{i} = ['0',num2str(tmpTime(i+1))];
        else
            fnTime{i} = num2str(tmpTime(i+1));
        end
    end
end

tempPath = pwd;
cd ..
savePath = [pwd,'\DATA'];
cd(savePath);

logfn = ['Ori_',num2str(SubjID),'_',num2str(PosID),'_',num2str(tmpTime(1)),...
    fnTime{1},fnTime{2},'_',fnTime{3},fnTime{4},fnTime{5},'.mat'];
save(logfn, 'SubjID','OriStampCue','OriStampButton','OriResult','OriRTResult','OriFTResult','OriConfiResult');
cd(tempPath);
clear