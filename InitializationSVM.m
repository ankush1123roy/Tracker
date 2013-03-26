function [Positive,Negative] = InitializationSVM(Initialization,Initiate,Templt,x_min,y_min,width,height)
sig = 0.1;
Positive = [];
Negative = [];
x_max = x_min + width-1;
y_max = y_min + height-1;
x_bck = x_max + width-1;
x_lck = x_min - width+1;;
y_bck = y_max + height-1;
y_lck = y_min - height+1;
XLimit = round((Initialization(1,1)/10)*width);
YLimit = round((Initialization(1,2)/10)*height);

for i = -XLimit:XLimit
    for j= -YLimit:YLimit
        PosI = im2double(Initiate(y_min+j:y_max+j, x_min+i:x_max+i));
        Positive = cat(3, Positive,PosI);
    end
end

for sig = sig:0.1:Initialization(1,3)
I = im2double(imfilter(Templt,fspecial('Gaussian',[2*round(3*sig)+1 2*round(3*sig)+1],sig),'same','conv','replicate'));
Positive = cat(3, Positive,I);
end


for i=1:width
    NegI = im2double(Initiate(y_lck:y_min, x_min+i:x_max+i));
    Negative = cat(3,Negative,NegI);
    NegI = im2double(Initiate(y_max:y_bck, x_min+i:x_max+i));
    Negative = cat(3,Negative,NegI);
end


for i=1:height
    NegI = im2double(Initiate(y_min+i:y_max+i, x_lck:x_min));
    Negative = cat(3,Negative,NegI);
    NegI = im2double(Initiate(y_min+i:y_max+i, x_max:x_bck));
    Negative = cat(3,Negative,NegI);
end
end
