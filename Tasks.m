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
    while sum(start-Initial)~=0 || check_where==1
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
            disp(Loop(i,l))
            pause
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
                Loop(i,l)=start(1,3);
                LoopReference(i,l)=start(1,4);
                % go to the next element 
                l=l-1;
    
            end
        end
    end
        
    
   
    
    
end
