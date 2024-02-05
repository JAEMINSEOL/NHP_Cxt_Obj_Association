function Q = QuiverFromFixation(Fix,x,y)

Q_temp(:,1:2:3) = Fix(:,1:2);

Q_temp(:,2) = x(Fix(:,3)+1);
Q_temp(:,4) = y(Fix(:,3)+1);

Q_temp(:,5) = sqrt((Q_temp(:,2)-Q_temp(:,1)).^2 + (Q_temp(:,4)-Q_temp(:,3)).^2);

Q(:,1:2)=Q_temp(:,1:2:3);
Q(:,3) = 10*(Q_temp(:,2)-Q_temp(:,1))./Q_temp(:,5);
Q(:,4) = 10*(Q_temp(:,4)-Q_temp(:,3))./Q_temp(:,5);

end