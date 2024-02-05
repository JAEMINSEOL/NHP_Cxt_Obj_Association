function asterisk = draw_asterisk(p)
if p < 0.05
    asterisk = "*";
    if p < 0.001
        asterisk = "**";
        if p < 0.0005
            asterisk = "***";
        end
    end
else
    asterisk = "n.s.";
end

