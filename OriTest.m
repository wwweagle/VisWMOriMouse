function  [RespAng,RT,FT,firstResp,finish] = OriTest(wPtr,TargetPos,RotationAngle,...
        CuePos,rect,OriTarget,OriCueColor,OriColorList,recording,signalDuratoin,s)
    
finish = 0; 
start = GetSecs;
quit = 0;
response = 0;
deadline = 10;
respORnot = 1;
firstResp = 0;
tic
while toc < deadline
    
    Screen('DrawLine', wPtr,OriCueColor(OriColorList(OriTarget),:), ...
        CuePos(TargetPos,1) + 55*sin(RotationAngle),...
        CuePos(TargetPos,2) - 55*cos(RotationAngle),...
        CuePos(TargetPos,1) - 55*sin(RotationAngle),...
        CuePos(TargetPos,2) + 55*cos(RotationAngle), 3);
    Screen('TextSize', wPtr , 80);    
    Screen('DrawText', wPtr, num2str(deadline-floor(GetSecs-start)), rect(3)/2-40,rect(4)/5*4, [255 255 255]); % Timer  
    Screen(wPtr, 'Flip');   
    if respORnot==1 && recording==1
        EventTrigger(0,0,1,0,0,0,0,0,signalDuratoin,s);      
        respORnot = 0;
    end
    [~,~,buttons] = GetMouse;
    
    if find(buttons)
        if response == 0
            response = 1;
            RT = GetSecs-start; 
            if buttons(1)== 1
                if recording==1
                    EventTrigger(0,0,0,1,0,0,0,0,signalDuratoin,s);  
                end
                firstResp = 1;
            elseif buttons(3)== 1
                if recording==1
                    EventTrigger(0,0,0,0,1,0,0,0,signalDuratoin,s);  
                end
                firstResp = 2;
            elseif buttons(2)== 1
                if recording==1
                    EventTrigger(0,0,0,0,0,1,0,0,signalDuratoin,s);            
                end
                firstResp = 3;
            end
        end
        if  buttons(1)== 1
             if recording==1
                  EventTrigger(0,0,0,1,0,0,0,0,signalDuratoin,s);  
             end
             if RotationAngle> 0
                RotationAngle= RotationAngle - (pi/150);
             else
                RotationAngle= pi;
             end            
        elseif buttons(3)== 1
            if recording==1
                EventTrigger(0,0,0,0,1,0,0,0,signalDuratoin,s);  
            end
            if RotationAngle< pi
                RotationAngle= RotationAngle + (pi/150);
            else
                RotationAngle= 0;
            end
         elseif buttons(2)== 1
             if recording==1
                EventTrigger(0,0,0,0,0,1,0,0,signalDuratoin,s);            
             end
             finish = 1;  
             FT = GetSecs-start; % finish time
             RespAng = RotationAngle;
             break;       
         end    
    end
    pause(0.01)
end

if response == 0
    RespAng = RotationAngle;%NaN;
    RT = 0;% NaN;
    FT = 0;%NaN;
elseif  response == 1 
    if quit == 1
        RespAng = RotationAngle;%NaN;
    end
    if finish == 0
        FT = deadline;
        RespAng = RotationAngle;
    end
end

