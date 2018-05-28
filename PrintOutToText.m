clc

fileID = fopen('CircuitResult.txt','w');
% The rules: 
   %0. Starting at the edges ( The left and right, top or right). 
   
   % The battery is denoted as <1 V 0>. 
        % When it cross the *0 edge [*1 *0], the voltage add (+V).
        % When it cross the *1 edge [*0 *1], the voltage add (-V).
       
   % 1. Starting from indicators { r e pi}, cross the value {R C L},  
   % end at some indicators such that it is a multiple or single i.e (r*e). 
   
   
   % The moving direction 
        
        % after choosing a direction (such as [*1 *0] ), the indicators
        % must move forward and cannot go backward. 
        
   % 2. Change lines.
        % 2.1 If it is a single, change row (below or above),
        % and start at the same point in the new row. 
   
        % 2.2 If it is a multiple indicator, keep the same row 
        % and cross values until it reatches a single indicator. 
        
        % 2.3 If the indicator below is zero, ignue this row and 
        % jump to the next row until it becomes a none zero indicator.  
        
        % 2.4 If the current row has zeros after the point(start from power
        % source indicator toward the end of power source), change row. 
        
load('circuitelementworkspace.mat')

%--------------------------------------------------------------------------
%Maintain the circuitShape in matrix.         
CircuitShape=zeros(Nelement,3*Nelement);
Reference=CircuitShape;

Voltage=M(:,5:6);
Cirelement=M(:,1:3);
i=1;

PowerVComplex=PowerV*(cos(PowerVAngle)+sin(PowerVAngle)*1i);

while i<=Nelement
    %Odd column represent indicators position
    %even column represent value position
    CircuitShape(i,2*Voltage(i,1)-1:2*Voltage(i,1))=Cirelement(i,1:2);
    
    CircuitShape(i,2*Voltage(i,2)-1)=Cirelement(i,3);
    i=i+1;
end

save('circuitelementworkspace1.mat','CircuitShape');


%--------------------------------------------------------------------------
%plot representation (not necessory in the process)
index=1:1:3*Nelement;
SUM=sum(CircuitShape);
for r=1:1:length(SUM)
    if SUM(1,r)==0
        SUM(1,r)=-1;
    else
    end
end

Average=CircuitShape./SUM;
i=1;

while i<=length(Average(1,:))
    plot(i,Average(:,i)','*')
    
    hold on
    %if SUM(1,i)==-1 %changed from the DEF
    %else
     %   o=o+1;
    %end
    i=2*i+1;
end

%--------------------------------------------------------------------------
% Loops Laws

% Set up count 2 method
% 1. Idea is choose a indcator place and find the near reactive or resistive
% position. 
% 2. Second is to cross the value to the same line vector. 
% 3. Choose any posistion that is with in the second row, (above or below)
% then, move the indicator to that position. 
% 4. Cross any value that the row have. 
% 5. If change the row, there are no limit for the row unless the same
% potnential voltage is crossed 2 times. 
% the lest favor decition is to cross the voltage of the power source. 

z=1;

DecideStarting=[]; % the index of starting points 
while z<=Nelement
       Sgn=sign(Voltage(z,2)-Voltage(z,1));
       %decide the position point 
       S=find(CircuitShape(z,:)~=0);
       DecideStarting(z,:)=S(1,mod(S,2)~=0); % the first line
       z=z+1;
end
% find the how many in parallel 
count1=0;
count2=[];
t=1;
for a=1:1:length(DecideStarting(:,1))-1
    
    if DecideStarting(a,1)==DecideStarting(a+1,1) && DecideStarting(a+1,2)==...
            DecideStarting(a+1,2)
       count1=count1+1;
       count2(t,:)=DecideStarting(a,:);
       t=t+1;
    end
    
end


disp(DecideStarting)
fprintf('\n')
disp(count1)
% building the checking order (starting from the first) 

i=1;
Y=[];
r=0;
u=1;
totallength=length(DecideStarting(:,1))*length(DecideStarting(1,:));
while i<=totallength
        v=~mod(i,2)+1;
          r=r+1;
       Y(i,:)=[u,v];
       if mod(r,2)==0
          u=u+1;
        end
       i=i+1;
end
disp(Y)
% Starting checking 
 h=1;
 g=1;
 Loops=[];
 DirectionRecord=[];
IndexElement=[];
for g=1:1:Nelement
    h=2*g-1; % represent the odd column. 
    currentposition=DecideStarting(Y(h,1),Y(h,2));
    Homogposition=DecideStarting(Y(h+1,1),Y(h+1,2));% in the same line. 
    Elementposition=currentposition+1;%some time can be(currentposition+Homogposition)/2;
    CrossElement=CircuitShape(g,Elementposition);
    IndexElement(g,:)=[currentposition,Homogposition,Elementposition,CrossElement,g];
    %IndexElement(h+1,:)=[-Homogposition,-currentposition,Elementposition,-CrossElement,0];
   
    
end
    
%Loops
Loop=[];
LoopReference=[];
for i=1:1:Nelement
    
%--------------------------------------------------------------------------

    start=[IndexElement(i,1),IndexElement(i,2),IndexElement(i,4),IndexElement(i,5)];
    Initial=[IndexElement(i,1),IndexElement(i,2),IndexElement(i,4),IndexElement(i,5)];
    %adding a relactionship 
    %reference check 
    check_where=1;
    l=1;
    indicator_returnInital=0;
    while sum(real(start-Initial))~=0 || check_where==1
        %set to deactivate 
        check_where=0;
        %find where is the second element in the first coloum toward Max
        NextPosiElement=find(start(1,2)==IndexElement(:,1));
        % two way: 
                % 1, NextPosiElement is empty: reach to the max
                % 2, NextPosiElement is not empty.
        %1 
        if isempty(NextPosiElement)==1
            
            Loop(i,l)=start(1,3);
            LoopReference(i,l)=start(1,4);
            l=l+1;
            Loop(i,l)=-PowerVComplex;
            LoopReference(i,l)=pi;
            break
        %2
        else
        %find where the loop will end with power supply
        Max_Indix=max(IndexElement(:,2));
        %find where the loop will start after it passes trough the power
        %supply 
        Min_Indix=min(IndexElement(:,1));
        % find and decide where the second start  by using
        % the first row 
        NextPosiElement=NextPosiElement(1,1);
        % record the circuit element 
        Loop(i,l)=start(1,3);
        LoopReference(i,l)=start(1,4);
        % go to the next element 
        l=l+1;
        % moving to the next element 
        start=[IndexElement(NextPosiElement,1),IndexElement(NextPosiElement,2)...
            ,IndexElement(NextPosiElement,4),IndexElement(NextPosiElement,5)];
        end
    end
    
%--------------------------------------------------------------------------

%Determine the maximun coloum the Loop have 
    l_max=(Min_Indix+Max_Indix)/2;
    %Check after it return to initial state
    Check_isInitial=Initial(1,1);
    if Check_isInitial==Min_Indix
        disp('good')
    else
        %start reverse direction by using while loop 
        start=Initial;
        %Set l to reduce from the maximum  
        l=l_max;
        while start(1,1)~=Min_Indix
            %going backward toward the Min 
        BackPosiElement=find(start(1,1)==IndexElement(:,2));
               %Check is the Backward an empty array
            if isempty(BackPosiElement)==1
                disp('error')
            else
                 %set backward equal to the first element
                BackPosiElement=BackPosiElement(1,1);
                %Set the new backward start moving backward
                start=[IndexElement(BackPosiElement,1),IndexElement(BackPosiElement,2)...
                ,IndexElement(BackPosiElement,4),IndexElement(BackPosiElement,5)];
                % record the circuit element 
                Loop(i,l-1)=start(1,3);
                LoopReference(i,l)=start(1,4);
                % go to the next element 
                l=l-1;
    
            end
        end
    end
        
    
   
    
    
end





%Current

CurrentCoff=zeros(l_max-2,Nelement);
r=1;
for i=3:2:max(IndexElement(:,2))-2%----Node 
    NodeEle=find(CircuitShape(:,i));
    AmountCurrent=length(NodeEle);
    NodeEle=NodeEle';
    
    if AmountCurrent==2
        
        CurrentCoff(r,NodeEle(1,1))=1;
        CurrentCoff(r,NodeEle(1,2))=-1;
    elseif AmountCurrent>2
        for k=1:1:AmountCurrent
            CheckSign=find(abs(CircuitShape(NodeEle(1,k),1:i-1))~=0);
            Howmany=length(CheckSign);
            
            if Howmany==0%----Def Sign
                CurrentCoff(r,NodeEle(1,k))=-1;
            elseif Howmany~=0
                 CurrentCoff(r,NodeEle(1,k))=1;
            end 
        end
    end
    r=r+1;
end

%Current DEF
% For any current, if the indicator in the CircuitShape equal to only
% exist 2 element in a coloum (Same potential), the current pass the first
% element equals the current pass the second current 

%Current

CurrentCoff=zeros(l_max-2,Nelement);
r=1;
for i=3:2:max(IndexElement(:,2))-2%----Node 
    NodeEle=find(CircuitShape(:,i));
    AmountCurrent=length(NodeEle);
    NodeEle=NodeEle';
    
    if AmountCurrent==2
        
        CurrentCoff(r,NodeEle(1,1))=1;
        CurrentCoff(r,NodeEle(1,2))=-1;
    elseif AmountCurrent>2
        for k=1:1:AmountCurrent
            CheckSign=find(abs(CircuitShape(NodeEle(1,k),1:i-1))~=0);
            Howmany=length(CheckSign);
            
            if Howmany==0%----Def Sign
                CurrentCoff(r,NodeEle(1,k))=-1;
            elseif Howmany~=0
                 CurrentCoff(r,NodeEle(1,k))=1;
            end 
        end
    end
    r=r+1;
end
disp(CurrentCoff)

ContiLoop=length(CurrentCoff(:,1))+1;

%---------
RangedLoopReference=[];

%Rearange the element 
    for z=1:1:Nelement
RangedLoopReference(z,:)=sort(LoopReference(z,:));
    end
    

disp(RangedLoopReference)

 [NewRerange,RangeLocation]=unique(RangedLoopReference,'rows');

 RangeLocation=RangeLocation';
 
 D=length(RangeLocation);
 
 %---Continue loop with "ContiLoop" 
 

 for p=1:1:D
     s=RangeLocation(1,p);
      FindCurrent=LoopReference(s,:);
      FindElement=Loop(s,:);

      disp(s)
     for l=1:1:l_max
         
         if FindCurrent(1,l)==pi
            
             CurrentCoff(ContiLoop,Nelement+1)=PowerVComplex;
            
         elseif FindCurrent(1,l)==0
             continue
         else
            CurrentCoff(ContiLoop,FindCurrent(1,l))=FindElement(1,l);
         end
        
     end
     ContiLoop=ContiLoop+1;
 end
 
 
 
 %Slove the Current 
 
 A=CurrentCoff(:,1:Nelement);
 B=CurrentCoff(:,1+Nelement);
 
 %Find the Current 
 I=A\B;
 
 
 
 Count=1:1:Nelement;
 Count=Count';
 %-------------------------------------------
 % I is in the Recutangular Domain
 I_Rect=I;

 
% Concerge into Frequency domain

I_Freq=[];

I_Freq(:,1)=sqrt(real(I).^2+imag(I).^2);
I_Freq(:,2)=atan(imag(I)./real(I));
%-------------------------------------------

%%%%%%
CurrentFrequencyDomain=I_Freq;
CurrentRectangularDomain=I_Rect;


% Z is in the Recutangular Domain
Z_Rect=IndexElement(:,4);

% Find the Impidence for all circuit elements in Frequency domain 

Z_Freq=[];

Z_Freq(:,1)=sqrt(real(IndexElement(:,4)).^2+imag(IndexElement(:,4)).^2);
Z_Freq(:,2)=atan(imag(IndexElement(:,4))./real(IndexElement(:,4)));


ElementFrequencyDomain=Z_Freq;
ElementRectangularDomain=Z_Rect;

%-------------------------------------------
% Find the Voltage for all circuit elements in Frequency domain 
V_Freq=[];
V_Freq(:,1)=Z_Freq(:,1).*I_Freq(:,1);
V_Freq(:,2)=Z_Freq(:,2)+I_Freq(:,2);

%-------------------------------------------
% Find the Voltage for all circuit elements in rechtangular domain 
V_Rect=V_Freq(:,1).*(cos(V_Freq(:,2))+sin(V_Freq(:,2))*(1i));


VoltageFrequencyDomain=V_Freq;
VoltageRectangularDomain=V_Rect;
% Create Table 
S=[];
SS=[];
SS=string(SS);
for i=1:1:Nelement 
    S=string(CE(1,i).name);
    SS(1,i)=S;
end
SS=SS';

Empty=[];
Empty=string(Empty);
for i=1:1:Nelement
Empty(1,i)=' ';
end
Empty=Empty';


CircuitResult=[];
CircuitResult=string(CircuitResult);




CircuitResult=[SS,ElementRectangularDomain,Empty,ElementFrequencyDomain,Empty,...
    Empty,VoltageRectangularDomain,Empty,VoltageFrequencyDomain,Empty,Empty,...
    CurrentRectangularDomain, Empty, CurrentFrequencyDomain];


NameofElement='NameofElement';
ElementRectangularDomain='ElementRectangularDomain';
Empty=' ';
ElementFrequencyDomain='ElementFrequencyDomain';
VoltageRectangularDomain='VoltageRectangularDomain';
VoltageFrequencyDomain='VoltageFrequencyDomain';
CurrentRectangularDomain='CurrentRectangularDomain';
CurrentFrequencyDomain='CurrentFrequencyDomain';
CurrentFrequencyDomainAngle='CurrentFrequencyDomainAngle';
VoltageFrequencyDomainAngle='VoltageFrequencyDomainAngle';
ElementFrequencyDomainAngle='ElementFrequencyDomainAngle';

NameTitle=[];
NameTitle=string(NameTitle);
NameTitle(1,1)=NameofElement;
NameTitle(1,2)=ElementRectangularDomain;
NameTitle(1,3)=Empty;
NameTitle(1,4)=ElementFrequencyDomain;
NameTitle(1,5)=ElementFrequencyDomainAngle;
NameTitle(1,6)=Empty;
NameTitle(1,7)=Empty;
NameTitle(1,8)=VoltageRectangularDomain;
NameTitle(1,9)=Empty;
NameTitle(1,10)=VoltageFrequencyDomain;
NameTitle(1,11)=VoltageFrequencyDomainAngle;
NameTitle(1,12)=Empty;
NameTitle(1,13)=Empty;
NameTitle(1,14)=CurrentRectangularDomain;
NameTitle(1,15)=Empty;
NameTitle(1,16)=CurrentFrequencyDomain;
NameTitle(1,17)=CurrentFrequencyDomainAngle;



CircuitResult=[NameTitle;CircuitResult];

CircuitResult=string(CircuitResult);
disp(CircuitResult)

fprintf(fileID,'The Circuit Result is: \n\n');

for i=1:1:Nelement+1
    for r=1:1:17
    S=CircuitResult(i,r);
    fprintf(fileID,'%11s\t',S);
    end
fprintf(fileID,'\n\n')
end
    
%end

fclose(fileID);