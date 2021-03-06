function [Korrespondenzen] = punkt_korrespondenzen(I1,I2,Mpt1,Mpt2,varargin)
% In dieser Funktion sollen die extrahierten Merkmalspunkte aus einer
% Stereo-Aufnahme mittels NCC verglichen werden um Korrespondenzpunktpaare
% zu ermitteln.

%% Input parser
 P = inputParser;

    defaultMinCorr = 0.98;
    defaultWindowLength = 33;
    
    % Liste der notwendigen Parameter
    % Ein Bild als Input ist zwingend notwendig
    P.addOptional('min_corr', defaultMinCorr, @(x)isnumeric(x));
    P.addOptional('window_length',defaultWindowLength, @(x) x > 1 && (mod(x,2)));
    P.addOptional('do_plot', false, @islogical);

    % Parsen der Eingabewerte
    P.parse(varargin{:});
    
    % Laden der Werte des Input Parsers in Variablen
    min_corr = P.Results.min_corr;
    window_length = P.Results.window_length;
    plot = P.Results.do_plot;

    
%% Initialisierung von Variablen     
    N = window_length*window_length;
    n_W = size(Mpt1, 2);
    n_V = size(Mpt2, 2);
    W = cell(n_W, 1);
    V = cell(n_V, 1);
    window_length_2 = (window_length-1)/2;
    NCC = zeros(n_W, n_V);
    
    
% Eigentlicher Algorithmus
    W_mean = mean2(double(I1));
    V_mean = mean2(double(I2));
    W_no_mean = double(I1) - W_mean;
    V_no_mean = double(I2) - V_mean;
    W_sigma = std2(I1);
    V_sigma = std2(I2);
    
    I1_norm = W_no_mean/W_sigma;
    I2_norm = V_no_mean/V_sigma;
    
    for i=1:n_W
        x = Mpt1(2,i);
        y = Mpt1(1,i);
        
        x_up = x + window_length_2;
        y_up = y + window_length_2;
        x_down = x - window_length_2;
        y_down = y - window_length_2;
        
        tmp = I1(x_down:x_up,y_down:y_up); 
        W_mean = mean2(double(tmp));
        W_no_mean = double(tmp) - W_mean;
        W_sigma = std2(tmp);
        W{i} = W_no_mean/W_sigma;

    end
    
    for i=1:n_V
        x = Mpt2(2,i);
        y = Mpt2(1,i);
        x_up = x + window_length_2;
        y_up = y + window_length_2;
        x_down = x - window_length_2;
        y_down = y - window_length_2;
        
        tmp = I2(x_down:x_up,y_down:y_up); 
        V_mean = mean2(double(tmp));
        V_no_mean = double(tmp) - V_mean;
        V_sigma = std2(tmp);
        V{i} = V_no_mean/V_sigma;
    end

    for i=1:n_W
        for j=1:n_V
            NCC(i,j) = trace(W{i}'*V{j})/(N-1);
        end
    end
    
    [M,I] = max(NCC');
    valid_M = M > min_corr;
    I = valid_M.*I;
    ind1 = find(valid_M ==1);
    ind2 = find(I > 0);
    match1 = Mpt1(:,ind1)';
    match2 = Mpt2(:,I(ind2))';
    

    if plot
        figure; ax = axes;
        showMatchedFeatures(I1,I2,match1, match2,'montage','Parent', ax);
        title(ax, 'Candidate point matches');
        legend(ax, 'Matched points 1','Matched points 2');
    end
end


