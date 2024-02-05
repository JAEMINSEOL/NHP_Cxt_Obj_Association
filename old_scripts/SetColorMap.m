function SetColorMap(c,FR_mean,FR_sem,Range)
image(FR_mean(:,:,c),'CDataMapping','scaled');
caxis([0 Range])
xticks([1 2 3])
yticks([1 2 3])

set(gca,'XTickLabel',{'Pumpkin', 'Jellyfish', 'Pizza'},'fontsize',15,'TickDir','out')
set(gca,'YTickLabel',{'Donut', 'Turtle', 'Octopus'},'fontsize',15,'TickDir','out')
caxis([0 Range])
for i = 1:3
    for j = 1:3
        switch i
            case 1
                strlobj = 'P';
            case 2
                strlobj = 'J';
            case 3
                strlobj = 'Z';
        end
        switch j
            case 1
                strrobj = 'D';
            case 2
                strrobj = 'T';
            case 3
                strrobj = 'O';
        end
        
        if c ==1 || c==4
            dir = 'L';
        else
            dir = 'R';
        end
        if c ==1 || c==2
            cxt = 'F';
        else
            cxt = 'C';
        end
        
        str = {[cxt strlobj strrobj dir], ['mean = ' num2str(FR_mean(j,i,c), '%.2f')], ['SEM = ' num2str(FR_sem(j,i,c), '%.2f')]};
        text(i-0.3,j,str,'FontSize',6)
        set(gca,'XTickLabel',get(gca,'XTickLabel'),'fontsize',10,'FontWeight','bold')
        ytickangle(90)

    end
end
end