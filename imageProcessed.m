unction [maxAcc,x_min,y_min] = imageProcessed(II,blockSize,model)
   % blockSize = [width,height];
  accu = [];
  Initiate = 255*II;
  [M,N]= size(II);
  for i=1:M-blockSize(1)
      for j=1:N-blockSize(2)
      ImTemp = Initiate(i:i+blockSize(1)-1,j:j+blockSize(2) -1);
      [image, descrips, locs] = sift((ImTemp));
      label = ones(size(descrips,1),1);
      [predict_label, accuracy, dec_values] = svmpredict(label,descrips, model);
      Accu =[i,j,accuracy(1,1)];
      accu = cat(1,accu,Accu);
      end
  end
  [maxAcc,label]= max(accu(:,3));
  x_min = accu(label,2);
  y_min = accu(label,1);
  accu = maxAcc;
end
