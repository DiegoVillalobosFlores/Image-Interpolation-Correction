[baseFileName,folder]=uigetfile('*.*','Imagen','');  
fullimageFileName=fullfile(folder,baseFileName);
imagen=imread(fullimageFileName);  
image =rgb2gray(imagen); 

imshow(image) 

percentRuido = 10;

[lenX,lenY] = size(image);

x_= zeros(lenX);
y_= zeros(lenY);

tamImagen = lenY * lenX;

tamImagen = tamImagen * (percentRuido);

tamRuido = tamImagen / 100;

for i=1:tamRuido
     x=round(mod(rand.*lenX,lenX-1))+1;     
     y=round(mod(rand.*lenY,lenY-1))+1;
     
     image(x,y)=255;     
     x_(i)=x;     
     y_(i)=y; 
end

figure()
 imshow(image)  
 axis off  
 axis image
 
 Aux=1;  
 Numero = -1;  
 Cont = 0;
 for i=1: 8    
     for j=1: 256      
         deseada(i,j)= Numero;
         Cont = Cont+1;
         if Cont>Aux
             Numero = Numero*-1;  
         Cont=1;      
         end
     end
     Aux = Aux *2;   
 end
 
 P = [;]';
 for i=1: 100
     for j=1: 100
         Busqueda=0;
         for k=1: tamRuido
             if x_(k)==i && y_(k)==j
                 Busqueda=1;
                 break
             end
         end
         if Busqueda == 0
             auxiliar=[i,j]';
             P = [repmat(P,1,1) repmat(auxiliar,1,1)];
         end
     end
 end
 
 auxi=image(P(1,1),P(2,1)) ;
 T=deseada(:,auxi);
 tam = size(P);
 for i=2: tam(2)
     Busqueda=0;
     for k=1: tamRuido
         if x_(k)==P(1,i) && y_(k)==P(2,i)
             Busqueda=1;
             break          
         end
     end
     if Busqueda == 0
         auxi=image(P(1,i),P(2,i));
         deseada1=deseada(:,auxi);
         T=[repmat(T,1,1) repmat(deseada1,1,1)];
     end
 end
 
 net = feedforwardnet([30 20]);
 
 net.trainParam.epochs = 100;
 net.trainParam.goal = 0;
 
 [net,tr,Y,E] = train(net,P,T);
 
  prueba_=[x_(1),y_(1)]';
  for i=2 : tamRuido
      auxi=[x_(i),y_(i)]';
      prueba_=[repmat(prueba_,1,1) repmat(auxi,1,1)];
  end
  
  Resultado=sim(net,prueba_);
  Tam= size(Resultado);
  for i=1: Tam(2)
      for j=1: Tam(1)
          if Resultado(j,i) >0
              Resultado(j,i) = 1;
          else
              Resultado(j,i) = 0;
          end
      end
  end
 for i=1: Tam(2)
     Decimal(i)=0;
     for j=1: Tam(1)
         if Resultado(j,i) == 1
             Decimal(i) = Decimal(i) + 2^(j-1);
         end
     end
     image(prueba_(1,i),prueba_(2,i))=Decimal(i);
 end
 figure();
 imshow(image)
 axis off
 axis image
  
