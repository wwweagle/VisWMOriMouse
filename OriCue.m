function  [StampCue,StampCR] = OriCue(wPtr,CueNum,CuePos,CuePosList,CueAngle,...
   TrialNum,startTime,StampCue,StampCR,Target,itr0,OriColorList,OriCueColor)
           
ImgTime = GetSecs-startTime;
for i = 1:CueNum(itr0)
    if i == Target
       StampCue = [StampCue; TrialNum, ImgTime,CueNum(itr0),...
           CuePosList(i),CueAngle(i),1]; 
       StampCR = [StampCR; TrialNum, CueNum(itr0), CueAngle(i)];
    else
       StampCue = [StampCue; TrialNum, ImgTime,CueNum(itr0),...
           CuePosList(i),CueAngle(i),0];
    end  
    
    Screen('DrawLine', wPtr,OriCueColor(OriColorList(i),:),...
        CuePos(CuePosList(i),1)+(55*sin(CueAngle(i))),...
        CuePos(CuePosList(i),2)-(55*cos(CueAngle(i))),...
        CuePos(CuePosList(i),1)-(55*sin(CueAngle(i))),...
        CuePos(CuePosList(i),2)+(55*cos(CueAngle(i))), 3);        
end









    