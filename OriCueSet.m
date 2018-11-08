function [CuePosList,CueAngle,Target,TargetAng,TargetPos,RotationAngle]...
             = OriCueSet(CueNum,itr0)

CuePosList = 1:12; 
CuePosList = Shuffle(CuePosList(1:length(CuePosList)));
SP = pi/36:pi/180:pi/15; % startpoint
SP = Shuffle(SP(1:length(SP)));
Angle = SP:pi/7:pi*0.99;  % pi and 0 are same 
Angle = Shuffle(Angle(1:length(Angle)));

CueAngle = [];
for i = 1:CueNum(itr0)  
    CueAngle = [CueAngle,Angle(1)]; 
    while abs(Angle(1)-Angle(2)) < pi/10
        Angle = [Angle(1),Angle(3:end)];
    end
    Angle = Angle(2:end);
end

Target = randperm(CueNum(itr0));
Target = Target(1);
TargetAng = CueAngle(Target);
TargetPos = CuePosList(Target);

RotationAngleList = 0:pi/180:pi;
RotationAngleList = Shuffle(RotationAngleList(1:length(RotationAngleList)));
RotationAngle = RotationAngleList(1);    
while abs(RotationAngle - TargetAng) < pi/12
    RotationAngleList = RotationAngleList(2:end);
    RotationAngle = RotationAngleList(1);
end



