classdef NetModel < handle
    properties (Access = public)
        %Input Variable
        ShowThreshold
        %NumChannel
        LabelChannel
        
        %Internal Variable
        LabelAllChannel

        FlagChannelVisable
    end
    
    properties (Access = public, Dependent = true)

    end
    
    properties (Access = private)
        

    end
    
    
    methods
        function nmobj = NetModel(varargin)
            
            ArgValidation = inputParser;
            ArgValidation.CaseSensitive = false;
            ArgValidation.FunctionName = 'NetModelCreator';
            ArgValidation.PartialMatching = true;
            
            
            
            DefaultShowThreshold = 0.5;
            load ChannelInfo.mat;
            nmobj.LabelAllChannel = ChannelInfo.Label;
            DefaultLabelChannel = ChannelInfo.Label;
            
            DefaultFlagChannnelVisable = true(size(ChannelInfo.Label));
          
            
%             expectedShapes = {'square','rectangle','parallelogram'};
            
            %             addRequired(ArgValidation,'width',@isnumeric);
            %             addOptional(ArgValidation,'height',defaultHeight,@isnumeric);
            addParameter(ArgValidation,'ShowThreshold',DefaultShowThreshold,@(x)validateattributes(x,...
                {'numeric'},{'>=',0,'<=',1,'numel',1}))
            
            %             addParameter(ArgValidation,'NumChannel',DefaultShowThreshold,@(x)validateattributes(x,...
            %                 {'numeric'},{'integer','>=','2','<=','62'}))
            addParameter(ArgValidation,'LabelChannel',DefaultFlagVisable ,@(x)iscellstr(x));
            addParameter(ArgValidation,'FlagChannelVisable',DefaultFlagVisable ,@(x)validateattributes(x,...
                {'logical'}));
            
            
            parse(ArgValidation,varargin{:});
            
            nmobj.ShowThreshold = ArgValidation.Results.ShowThreshold;
            
            if ismember(lower(ArgValidation.Results.LabelChannel),lower(DefaultLabelAllChannel))
                nmobj.LabelChannel = ArgValidation.Results.LabelChannel;
            else
                error('Illegal input argument ''LabelChannel''.');
            end
            if numel(ArgValidation.Results.FlagChannelVisable) == numel(LabelChannel)
                nmobj.FlagChannelVisable = ArgValidation.Results.FlagChannelVisable;
            else
                error('Illegal input argument ''FlagChannelVisable''.');  
            end

        end
    end
    
    
end