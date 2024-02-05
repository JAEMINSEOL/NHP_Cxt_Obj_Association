function EyeRaster_Setting(img)
xlim([400 1500]); ylim([200 700])
set(gca,'YDir','reverse');
hold on
Diagram = image(1:1920,1:1080,img);
Diagram.AlphaData = 0.5;
daspect([1 1 1])
xticks([])
yticks([])
end
