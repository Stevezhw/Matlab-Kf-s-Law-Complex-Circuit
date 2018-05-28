% Circuit Element ClassFile 
classdef circuitelement
    properties 
        value;
        type;
        spote;
        epote;
        name;
    end
   
       methods 
           function [r,n]=val(obj)
               [r,n]=dcele(obj.spote,obj.epote,obj.type,obj.value);
           end
           function a=Name(obj)
               a=obj.name;
           end
       end
end

               