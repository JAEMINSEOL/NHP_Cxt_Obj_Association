figure;
plot([1:size(lap_BIAS_movemean_Day1,1)],lap_BIAS_movemean_Day1,'-ok','LineWidth',3);
str = num2cell(round(lap_BIAS_movemean_Day1,2)');
text([1:size(lap_BIAS_movemean_Day1,1)]+0.05,lap_BIAS_movemean_Day1-0.1,str,'Color','black','FontSize',14);

hold on

plot([1:size(lap_BIAS_movemean_Day2,1)],lap_BIAS_movemean_Day2,'-ob','LineWidth',3);
str = num2cell(round(lap_BIAS_movemean_Day2,2)');
text([1:size(lap_BIAS_movemean_Day2,1)]+0.05,lap_BIAS_movemean_Day2-0.1,str,'Color','blue','FontSize',14);

plot([1:size(lap_BIAS_movemean_Day3,1)],lap_BIAS_movemean_Day3,'-or','LineWidth',3);
str = num2cell(round(lap_BIAS_movemean_Day3,2)');
text([1:size(lap_BIAS_movemean_Day3,1)]+0.05,lap_BIAS_movemean_Day3-0.1,str,'Color','red','FontSize',14);

set(gca,'YLim',[-1 1],'FontSize', 24,'XTick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]);
line([0 max(get(gca,'XLim'))],[0 0],'color','k');
xlabel('Blocks (4 Laps)'); ylabel('Bias');
title('Block Side Bias (2 Objects, 2nd pair)')

legend({'Day1','Day2', 'Day3'})

A = 0;
for n = 1:LapNum
    m=1;
    while m <= 6
        
        if correctness_mat(n,m:m+2) == [1 1 1 ]
            A = A+1;
            m=m+3;
        else
            m = m+1;
        end
    end
end

B = 0;
for n = 1:LapNum
    m=1;
    while m <= 6
        
        if correctness_mat(n,m:m+2) == [0 0 0]
            B = B+1;
            m=m+3;
        else
            m = m+1;
        end
    end
end