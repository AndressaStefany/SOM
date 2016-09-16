function w = som(number,nomeArquivo, eta, sigma, numEntrada)
    fileID = fopen(nomeArquivo,'r');
    entradas = fscanf(fileID, '%f', [numEntrada, Inf])';

    %numeros de neuronios
    neuros = number^2;
    % w eh o vetor de pesos, onde cada coluna representa os pesos de cada neuronio    
    for i = 1:number
        for j = 1:number
            w{i,j} = (1+1)*rand(1,numEntrada);
        end
    end
    for it = 1:1000
        for ne = 1:length(entradas)
           ale = randi(length(entradas));
           aux =  entradas(ne);
           entradas(ne) = entradas(ale);
           entradas(ale) = aux;
        end
        for ne = 1: length(entradas)
            entrada = entradas(ne,:);
            %distancia(neuros) = []; %vetor de distancias
            for i = 1:number
                for j = 1:number
                    distancia(i,j) = distEuclidiana( w{i,j}, entrada );
                end
            end
            %identifica�ao da posicao do neuronio vencedor
            [linha, coluna] = neuroVencedor(distancia);
            %atualizar os pesos
            for i = 1:number
                for j = 1:number
                    w{i,j} = w{i,j} + eta * exp(-distEuclidiana([i,j], [linha, coluna])/(2*sigma)) * (entrada - w{i,j});
                end
            end
            %w = atualizaPeso(w, entrada, linha, coluna, number, eta, sigma);
        end
    end
    fprintf(fopen('resultadoSom.txt','w'),'%f %f %f %f %f %f\n',w{:});
    %avaliaSaida(w,number,entradas);
end

function avaliaSaida(pesos, number, entrada)
    for ne = 1:length(entrada)
        distancia(1:length(entrada(ne)),1:length(entrada(ne)))= 0;
        for i = 1:number
            for j = 1:number
                distancia(i,j) =  distEuclidiana(pesos{i,j}, entrada(ne,:));
            end
        end
        x=imresize(distancia,10);
        figure, imshow(x,[]);
    end
end

%Calcula a distancia euclidiana
function distancia = distEuclidiana(a, b)
    distancia = sqrt(sum( (a - b).^2));
end

%Retorna a posi�ao do neuronio com menor distancia euclidiana
function [linha, coluna] = neuroVencedor( neuroMatriz )
    [M,I] = min(neuroMatriz(:));
    [linha, coluna] = ind2sub(size(neuroMatriz),I);
end

%atualiza os pesos
function y = atualizaPeso(w, entrada, lVencedor, cVencedor, number, eta, sigma)
    for i = 1:number
        for j = 1:number
            y{i,j} = w{i,j} + eta * exp(-distEuclidiana([i,j], [lVencedor, cVencedor])^2/(2*sigma^2)) * (entrada - w{i,j});
        end
    end
end