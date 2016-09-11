function distancia = som(front, back, right, left)

    %numeros de neuronios
    neuros=5;
    
    % w eh o vetor de pesos, onde cada coluna representa os pesos de cada neuronio
    w=-3+(3+3)*rand(4,neuros);    
    
    distancia(neuros) = []; %vetor de distancias
    for i = 0:neuros
        distancia(i) = distEuclidiana( w(0,i), w(1,i), w(2,i), w(3,i), front, back, right, left );
    end
    
    %identificaçao do neuronio vencedor
    %colunaDoVencedor = neuroVencedor(distancia);
    
    %atualizar os pesos
    %vencedor = [w(0,colunaDoVencedor) w(1,colunaDoVencedor) w(2,colunaDoVencedor) w(3,colunaDoVencedor)];
    %for i = 0:8
       %h(i) = e^-( neuroNeuro(w, i, vencedor)/2 );%falta o sigma e o n
      
       %z(0,i) = w(0,i) + h(i) * (front - w(0,i));
       %z(1,i) = w(1,i) + h(i) * (back - w(1,i));
       %z(2,i) = w(2,i) + h(i) * (right - w(2,i));
       %z(3,i) = w(3,i) + h(i) * (left - w(3,i));
    %end
    
    %verificar se houve alguma mudança
    %for i = 0:8
        %for j = 0:4
           %if(w(j,i) == z(j,i))
               %acabou
           %else
               %voltar ao passo de calcular as distancias
           %end
       % end
    %end
    
end

%Calcula a distancia euclidiana
function distancia = distEuclidiana(pontFront, pontBack, pontRight, pontLeft, front, back, right, left)
    distancia = sqrt(abs( (pontFront - front)^2 + (pontBack - back)^2 + (pontRight + right)^2 + (pontLeft + left)^2 ));
end

%Retorna a posiçao do neuronio com menor distancia euclidiana
%function [i] = neuroVencedor( distVetor )
    %valorMin = min(disVetor);
    %for i = 0:8
       %if(distVetor(i) == valorMin)
          %return i;  
       %end
    %end    
%end

%retorna o valor da distancia entre o neuronio e o neuronio vencedor
%function valor = neuroNeuro(distNeuro, coluna, distVencedor)
    %valor = sqrt(abs( (disNeuro(0,coluna)-disVencedor(0))^2 + (distNeuro(1,coluna)-disVencedor(1))^2 + (distNeuro(2,coluna)-distVencedor(2))^2 + (distNeuro(3,coluna)-distVencedor(3))^2 ));
%end






