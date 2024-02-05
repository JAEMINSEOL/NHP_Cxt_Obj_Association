        function Obj = ObjName(o)
        switch o
            case 0
                Obj = 'Pumpkin';
            case 1 
                Obj = 'Donut';
            case 2
                Obj = 'Jellyfish';
            case 3
                Obj = 'Turtle';
            case 4
                Obj = 'Pizza';
            case 5
                Obj = 'Octopus';
            otherwise
                Obj = ['Unknown_' num2str(o)];
        end
       