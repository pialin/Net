classdef NetModel < handle
    properties
        ShowThreshold = 0.5;
        
        
    end
    methods
        function nmobj = NetModel(varargin)
            
            ArgValidation = inputParser;
            defaultHeight = 1;
            defaultUnits = 'inches';
            defaultShape = 'rectangle';
            expectedShapes = {'square','rectangle','parallelogram'};
            
            %             addRequired(ArgValidation,'width',@isnumeric);
            %             addOptional(ArgValidation,'height',defaultHeight,@isnumeric);
            addParameter(p,'nickname','-',@(x)validateattributes(x,...
                {'char'},{'nonempty'}))
            addParameter(ArgValidation,'units',defaultUnits);
            addParameter(ArgValidation,'shape',defaultShape,...
                @(x) any(validatestring(x,expectedShapes)));
            
            parse(ArgValidation,width,varargin{:});
            a = ArgValidation.Results.width .* ArgValidation.Results.height;
            
        end
    end
    
    
end