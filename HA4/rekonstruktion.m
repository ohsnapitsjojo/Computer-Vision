function [T,R, lambdas, P1] = rekonstruktion(T1,T2,R1,R2, Korrespondenzen, K)
% Funktion zur Bestimmung der korrekten euklidischen Transformation, der
% Tiefeninformation und der 3D Punkte der Merkmalspunkte in Bild 1
    x1 = [Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2 = [Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
    lambda = cell(4,2);
    nPos = zeros(4,1);
    Ts = cell(4,1);
    Rs = cell(4,1);
    s = zeros(4,2);
    
    x1 = K\x1;
    x2 = K\x2;
    
    [ lambda{1,1}, lambda{1,2} ] = calculateLambda(x1,x2,T1,R1);
    [ lambda{2,1}, lambda{2,2} ] = calculateLambda(x1,x2,T1,R2);
    [ lambda{3,1}, lambda{3,2} ] = calculateLambda(x1,x2,T2,R1);
    [ lambda{4,1}, lambda{4,2} ] = calculateLambda(x1,x2,T2,R2);

    nPos(1) = getNPos(lambda{1,1}, lambda{1,2});
    nPos(2) = getNPos(lambda{2,1}, lambda{2,2});
    nPos(3) = getNPos(lambda{3,1}, lambda{3,2});
    nPos(4) = getNPos(lambda{4,1}, lambda{4,2});
    
    TR = [T1,R1; T1,R2; T2,R1; T2,R2];
    Ts = {T1, T1, T2, T2};
    Rs = {R1, R2, R1, R2};
    
    
    [M, idx] = max(nPos);
    

    
    lambdas = [lambda{idx,1}, lambda{idx,2}];
    T = Ts{idx};
    R = Rs{idx};
    
    l1 = lambda{idx,1};
    
    P1 = [l1, l1, l1].*x1';
    camCorners = [3000, 3000, 0, 0, 3000,;
              2000,  0, 0, 2000, 2000;
              1,1,1,1           ,1];
          
    camCorners = K\camCorners;
    camCorners2 = (inv(R)*camCorners - [T,T,T,T,T]);
    
    figure; 
    plotPoints(P1);
    hold on;
    plotCamera(camCorners, 'Camera1');
    plotCamera(camCorners2, 'Camera2');
    

    
end