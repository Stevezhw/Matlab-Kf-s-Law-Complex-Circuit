classdef add
    properties 
        Value;
        Time;
    end
    
    methods
   
        function r=add10(obj)
            r=[obj.Value]+10;
        end
        function d=time1(obj)
            d=[obj.Time]./6;
        end
        
    end
end
