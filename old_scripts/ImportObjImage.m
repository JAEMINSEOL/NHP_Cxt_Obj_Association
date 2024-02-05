function [F_O,F_O_A] = ImportObjImage(n,alpha)
for ol=1:2*n
FigName_Obj = ['ObjL' num2str(ol)];

F_O(ol,:,:,:) = imread([FigName_Obj '.png']);
F_O_A(ol,:,:) = MakeTransLImage( squeeze(F_O(ol,:,:,:)),alpha);

FigName_Obj = ['ObjR' num2str(ol)];
F_O(ol+2*n,:,:,:) = imread([FigName_Obj '.png']);
F_O_A(ol+2*n,:,:) = MakeTransLImage( squeeze(F_O(ol+2*n,:,:,:)),alpha);
end
end