function  [quit] = ITI(wPtr,grey,white,rect)

KbName('UnifyKeyNames');
quit=0;
Screen('FillRect',wPtr,grey);
Screen('FillOval',wPtr,white,[rect(3)/2-10,rect(4)/2-10,rect(3)/2+10,rect(4)/2+10]);
Screen(wPtr, 'Flip');
tic
while toc < 1%3
    [~, ~, KeyCode] = KbCheck;
    if  find(KeyCode) == KbName('ESCAPE')
         quit = 1;
         break;
    end
end
