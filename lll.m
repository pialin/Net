classdef lll
    properties(Access = public)
        a
        b
    end
    properties(Access = private)
        c 
        d
    end
    
    methods
        function obj = lll()
            obj.a=1;
            obj.b=2;
            obj.c=3;
            obj.d=4;
        end
        function obj = sb(obj)
            obj = sa(obj);
        end
    end
    methods(Access = private)
        function obj = sa(obj)
            obj.a=0;
        end
        
        
    end
end
function c = f1(obj,x)
obj.c=233;
obj.a=x;
c=233;
sa(obj);
end
