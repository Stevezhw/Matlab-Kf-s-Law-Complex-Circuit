% creat a list that contain all the cricuit elements

%create and save a workspace for all files.
clc
clear 

% this is the place to define all the variable. 
 Circuitelement = 'circuitelementworkspace.mat';
%Enter in the form of 
            % R1, R2, R3... for resistors
            % C1, C2, C3... for capacitors
            % L1, L2, L3... for inductors
            
%   [R1,N1]=dcele(1,2,'R',50);
%   [R2,N2]=dcele(1,2,'R',110);
%   [C1,N3]=dcele(1,2,'C',61);
%   [L1,N4]=dcele(1,2,'L',80);
i=1;
j=1;
M=[];
fprintf('Enter the Method: (a: type or b direct enter): \n')
W=input('Enter a or b : ');
switch W
    case 'a'
        
while i==1 
    fprintf('\n')
    fprintf('Circuit Element: %i \n',j)
    
CE(j)=circuitelement;
CE(j).name=input('Name of the element: ','s');
CE(j).value=input('Value in Ohm: ');
CE(j).type=input('Type (Must within { R C L}: ','s');
CE(j).spote=input('Starting Potential Node: ');
CE(j).epote=input('Ending Potential Node: ');

[Ce,N]=val(CE(j));
M(j,:)=[Ce,0, N];

j=j+1;
fprintf('\n')
check=input('Next Element? If yes, enter 1 ');
    if check==1
        i=1;
    else
        i=0;
    end
end
Nelement=j-1;
fprintf('\nThe Circut is: \n')
disp(M)
fprintf('\n')
PowerV=input('Enter the voltage of the power source: ');
fprintf('\n')
PowerVAngle=input('Enter the phase angle (in Rad) of the power source (phi zero): ');
fprintf('\n')
fprintf('\nDo you want to save the workspace? Yes enter Y\n');
check=input('enter Y or N: ','s');

    case 'b'
        
        
end

if check=='Y'
    save(Circuitelement,'CE','M','Nelement','PowerV','PowerVAngle')
else 
end

    


% workspace
