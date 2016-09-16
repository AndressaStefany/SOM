function finalRad= ControleRobo(serPort)
    load('rede.mat')
    wd= rand();
    we= rand();
    while(1)
        x= genSonar(serPort);
        v = obj.AvaliaEntrada(x);
        v=v*0.9;
        %position= getPosition(serPort);
        %Vector of doubles [front left back right]
        %d= [ReadSonar(serPort, 1) ReadSonar(serPort, 2) ReadSonar(serPort, 3) ReadSonar(serPort, 4)]
        SetFwdVelAngVelCreate(serPort,v(1),v(2));
        pause(0.1)
    end
    finalRad= 1;
end