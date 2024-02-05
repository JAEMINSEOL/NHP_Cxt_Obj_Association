        function Obj = Obj_Name(o)
        switch o
            case 2
                Obj = 'Pumpkin';
            case 1 
                Obj = 'Donut';
            case 4
                Obj = 'Jellyfish';
            case 3
                Obj = 'Turtle';
            case 6
                Obj = 'Pizza';
            case 5
                Obj = 'Octopus';
            otherwise
                Obj = ['Unknown_' num2str(o)];
        end
       