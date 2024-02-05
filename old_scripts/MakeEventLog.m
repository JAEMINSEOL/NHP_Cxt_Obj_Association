function y = MakeEventLog(Time, PositionX, PositionY, EventName, x)
iVoidOff = find(strcmp(EventName, 'VoidOff'), 1 );
iSessionEnd = find(strcmp(EventName, 'SessionEnd'), 1 );
if size(EventName,2)==2
ix = find(strcmp(EventName, x) & ~strcmp(EventName(:,2), 'Void_Lap'));
 vx = strcmp(EventName(ix,2), 'Void');
else
    ix = find(strcmp(EventName, x));
     vx = zeros(length(ix),1);
end
tx = Time(ix);
px = PositionX(ix);
py =  PositionY(ix);
y = horzcat(ix, tx, px, py, vx);
y(y(:,1)<iVoidOff,:) = [];
y(y(:,1)>iSessionEnd,:) = [];
clearvars ix tx px py vx
end