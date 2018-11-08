function  [value] = OriFeedBack(wPtr,finish,RespAng,TargetAng,flipInterval,white)
              
Screen('TextSize', wPtr , 90);
Screen('Preference','TextEncodingLocale','UTF-8');
Screen('TextFont',wPtr,'SimHei');
value = round((RespAng-TargetAng)/pi*180);
if value > 90
    value = round(value - 180);
elseif value < -90
    value = round(value + 180);
end
if finish == 1    
    if value <= 15
        DrawFormattedText(wPtr, '太棒了','center','center',white);
    elseif value > 15 && value <= 45
        DrawFormattedText(wPtr, '很好','center','center',white);
    else
    DrawFormattedText(wPtr, '不错','center','center',white);
    end
elseif finish == 0  
    DrawFormattedText(wPtr, '没做','center','center',white);
end
Screen(wPtr, 'Flip');
tic
while toc < flipInterval*59
end


