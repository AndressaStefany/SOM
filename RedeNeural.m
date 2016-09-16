classdef RedeNeural < handle
   properties
       pesos;
       entradas, saidas, Y, Yref, deltas;
       funcA, dfuncA;
       faCamada, funcALista;
       pfa, afa, eta, erroQuadratico;
       numNeuCam, numSaidas, numEntradas, numCam;
   end
   methods
       function Configura(obj)
           obj.funcALista = {'Logistica', 'Tanh', 'Linear'};
           obj.funcA= { @(x,p,a) a/(1+exp(-p*x)) @(x,p,a) a*tanh(p*x)  @(x,p,a) a*p*x};
           obj.dfuncA={ @(y,p,a) a*p*y*(1-y) @(y,p,a) a*p*(1-y*y) @(y,p,a) a*p};
           
           obj.numCam=4; obj.numEntradas=4; obj.numSaidas=2;
           obj.pfa=1; obj.afa=1; obj.eta= 0.01;
           obj.faCamada= [2 2 2 3];
           obj.numNeuCam= [4 4 3 2];
       end
       function CarregaConjuntoEntradaSaida(obj)
           A = fscanf(fopen('resultadoSom.txt','r'),'%f',[obj.numEntradas+obj.numSaidas Inf])';
           obj.entradas= A(1:end,1:obj.numEntradas);
           obj.saidas= A(1:end,obj.numEntradas+1:end);
       end
       function InicializaPesos(obj)
           obj.Y{1}= [-1 1:obj.numEntradas];
           for c=1:obj.numCam
               obj.Y{c+1} = [-1 1:obj.numNeuCam(c)];
               for n=1:obj.numNeuCam(c)
                   if c-1>=1; aux=obj.numNeuCam(c-1); else aux=obj.numEntradas; end
                   for e=1:aux+1
                       obj.pesos{c}(n,e)= rand();
                   end
               end
           end
       end
       function EmbaralhaEntradas(obj)
           for e=1:size(obj.entradas,1)
               r= randi([1 size(obj.entradas,1)]);
               aux= obj.entradas(e,:);
               obj.entradas(e,:)= obj.entradas(r,:);
               obj.entradas(r,:)= aux;
               aux= obj.saidas(e,:);
               obj.saidas(e,:)= obj.saidas(r,:);
               obj.saidas(r,:)= aux;
           end
       end
       function CalculaSaidas(obj)
           for c=1:obj.numCam
               for n=1:obj.numNeuCam(c)
                   obj.Y{c+1}(n+1)= obj.funcA{obj.faCamada(c)}(sum(obj.pesos{c}(n,:).*obj.Y{c}), obj.pfa, obj.afa);
               end
           end
       end
       function CalculaDeltas(obj)
           for c=obj.numCam:-1:1
               for n= 1:obj.numNeuCam(c)
                   if c == obj.numCam
                       obj.erroQuadratico = obj.erroQuadratico+power(obj.Yref{c}(n)-obj.Y{c+1}(n+1), 2);
                       obj.deltas{c}(n) = (obj.Yref{c}(n)-obj.Y{c+1}(n+1))*obj.dfuncA{obj.faCamada(c)}(obj.Y{c+1}(n+1), obj.pfa, obj.afa);
                   else
                       obj.deltas{c}(n) = (obj.Yref{c}(n))*obj.dfuncA{obj.faCamada(c)}(obj.Y{c+1}(n+1), obj.pfa, obj.afa);
                   end
               end
               if c>1
                   for e=2:obj.numNeuCam(c-1)+1
                       obj.Yref{c-1}(e-1)= 0;
                       for n=1:obj.numNeuCam(c)
                           obj.Yref{c-1}(e-1)=obj.Yref{c-1}(e-1)+obj.deltas{c}(n)*obj.pesos{c}(n,e);
                       end
                   end
               end
           end
       end
       function CalculaPesos(obj)
           for c=1:obj.numCam
               for n=1:obj.numNeuCam(c)
                   obj.pesos{c}(n,:)=obj.pesos{c}(n,:)+obj.eta*obj.deltas{c}(n)*obj.Y{c};
               end
           end
       end
       function Treina(obj)
           Configura(obj);
           CarregaConjuntoEntradaSaida(obj);
           y= zeros(1,5000);
           InicializaPesos(obj);
           for it=1:5000
               EmbaralhaEntradas(obj);
               obj.erroQuadratico=0;
               for input=1:size(obj.entradas,1)
                   obj.Y{1}= [-1 obj.entradas(input,:)];
                   obj.Yref{obj.numCam} = obj.saidas(input,:);
                   CalculaSaidas(obj);
                   CalculaDeltas(obj);
                   CalculaPesos(obj);
               end
               obj.erroQuadratico=obj.erroQuadratico/size(obj.entradas,1)/obj.numSaidas;
               y(it)= obj.erroQuadratico;
           end
           plot(y);
           save('rede.mat','obj');
       end
       function y= AvaliaEntrada(obj, input)
           obj.Y{1}= [-1 input];
           CalculaSaidas(obj);
           y= obj.Y{end}(2:end);
       end
   end
end
