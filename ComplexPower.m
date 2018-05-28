%Find the complex power of the circuit

%first, find the voltages and currents
    
     %-------------------------------------------
    % I : Recutangular Domain
        I_Rect;
    % I : Frequency Domain
        I_Freq;
    %-------------------------------------------
    
    %-------------------------------------------
    % I : Recutangular Domain
        Z_Rect;
    % I : Frequency Domain
        Z_Freq;
    %-------------------------------------------
    
    %-------------------------------------------
    % I : Recutangular Domain
        V_Rect;
    % I : Frequency Domain
        V_Freq;
    %-------------------------------------------
  
 %second, find RMS Current and Voltage
 if Z_Freq(:,2)==0
     V_rms=V_Freq(:,1);
     I_rms=I_Freq(:,1);
 else
        V_rms=(1/sqrt(2))*V_Freq(:,1);
        I_rms=(1/sqrt(2))*I_Freq(:,1);
 end
 disp(V_rms)
        
  % third, find the magnitude of complex powers
  
        P_complexMag=V_rms.*I_rms;
        
  % The angle of complex power is the same as the impendence 
        P_complexAng=Z_Freq(:,2);
   
  % Find the rectangular form: 
        P_complexRec=I_rms.^2.*Z_Rect;
        
  % Find the net complex power in rectangular form 
        P_NetRec=sum(P_complexRec);
    
  % Find the magnitude of the net complex power 
        P_NetMag=sqrt(real(P_NetRec)^2+imag(P_NetRec)^2);
  % Find the angle of net complex power 
        P_NetAng=atan(imag(P_NetRec)/real(P_NetRec));
        
  % Power Factor (Lag or lead)
        if imag(P_NetRec)>0
            fprintf('\n the power is lagging\n')
        elseif imag(P_NetRec)<0
            fprintf('\n the power is leading\n')
        else
            fprintf('\n the power is alined \n')
        end
        PowerFactor=cos(P_NetAng);
            fprintf('\n the net complex power is (in frequency domain):\n %i L %i(in radian)  \n',P_NetMag,PowerFactor)
            
        
   % Adding to the table 
    NameTitle(1,18)=Empty;
    NameTitle(1,19)=Empty;
    NameTitle(1,20)='P_complexRec';
    NameTitle(1,21)=Empty;
    NameTitle(1,22)='P_complexMag';
    NameTitle(1,23)='P_complexAng';
    
    