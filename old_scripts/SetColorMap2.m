function SetColorMap2(c,FR_mean,FR_sem,Range,FontSize)
image(FR_mean(:,:),'CDataMapping','scaled');
caxis([0 Range])
xticks([1 2 3])
yticks([1 2 3])
if c ==1
set(gca,'XTickLabel',{'Pumpkin', 'Jellyfish', 'Pizza'},'fontsize',15,'TickDir','out')
set(gca,'YTickLabel',{'Donut', 'Turtle', 'Octopus'},'fontsize',15,'TickDir','out')
caxis([0 Range])
for i = 1:3
    for j = 1:3
        switch i
            case 1
                strlobj = 'Pumpkin';
            case 2
                strlobj = 'Jellyfish';
            case 3
                strlobj = 'Pizza';
        end
        switch j
            case 1
                strrobj = 'Donut';
            case 2
                strrobj = 'Turtle';
            case 3
                strrobj = 'Octopus';
        end
        

        
        str = {[strlobj,',',strrobj] ['mean = ' num2str(FR_mean(j,i), '%.3f') ], ['SEM = ' num2str(FR_sem(j,i), '%.3f')]};
        text(i-0.4,j,str,'FontSize',FontSize,'FontWeight','bold')
        set(gca,'XTickLabel',get(gca,'XTickLabel'),'fontsize',15,'FontWeight','bold')
        ytickangle(90)

    end
end
else
    set(gca,'XTickLabel',{'Pumpkin', 'Jellyfish', 'Pizza'},'fontsize',15,'TickDir','out')
set(gca,'YTickLabel',{'Donut', 'Turtle', 'Octopus'},'fontsize',15,'TickDir','out')
caxis([0 Range])
for i = 1:3
    for j = 1:3
        switch i
            case 1
                strlobj = 'Pumpkin';
            case 2
                strlobj = 'Jellyfish';
            case 3
                strlobj = 'Pizza';
        end
        switch j
            case 1
                strrobj = 'Donut';
            case 2
                strrobj = 'Turtle';
            case 3
                strrobj = 'Octopus';
        end
        

        
        str = {[strlobj,',', strrobj] ['mean = ' num2str(FR_mean(j,i), '%.3f') ], ['SEM = ' num2str(FR_sem(j,i), '%.3f')]};
        text(i-0.4,j,str,'FontSize',FontSize,'FontWeight','bold')
        set(gca,'XTickLabel',get(gca,'XTickLabel'),'fontsize',15,'FontWeight','bold')
        ytickangle(90)

    end
end
end