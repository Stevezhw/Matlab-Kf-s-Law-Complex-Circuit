function [element,Vl] = dcele(StartPotentialNode,EndPotentialNode,TypeOfCircuitElement,ValueOhm)
%Define a circuit element and its potential  
%  using the roles to translate the graphic design into matrix

%define the potential column 
global r p e
r=1;
p=pi;
e=exp(1);
Vl=[StartPotentialNode,EndPotentialNode];
switch TypeOfCircuitElement
    case 'R'
        R=ValueOhm;
        Relement=[r R r];
        d=1;
    case 'C'
        C=-1j*ValueOhm;
        Celement=[p C p];
        d=2;
    case 'L'
        L=1j*ValueOhm;
        Lelement=[e L e];
        d=3;
end
if d==1
    fprintf('\n the resistor value is %i%+ij\n', real(R), imag(R))
    element=Relement;
elseif d==2
    fprintf('\n the capacitor value is %i%+ij\n', real(C), imag(C))
    element=Celement;
elseif d==3
    fprintf('\n the inductor value is %i%+ij\n', real(L), imag(L))
    element=Lelement;
else 
   fprintf('Enter a proper element')
end
fprintf('\n')
fprintf('\n the potential node is [%i, %i] \n',Vl(1,1),Vl(1,2))





end

