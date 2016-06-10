classdef NetModel < handle
    properties (Access = public)
        
        
        %Input Variable
        ShowThreshold
        AdjacencyMatrix
        Frequency
        
        LabelChannel
        
        IndexChannelVisable
   
        ChannelVisable
        
        PlottedMatrix
        
        PlottedLabel
        
        PlottedFrequency
        
    end
    
    properties (Access = public, Dependent = true)
        
        NumPlottedChannel
        NumPlottedFrequency

    end
    
    properties (Access = private)
        

    end
    
    events
        
        PlottedChannelChanged
        PlottedMatrixChanged
    end
    
    methods
        function nmobj = NetModel(varargin)
            
            nmobj = ValidInputArg(nmobj,varargin);

        end
        
        function ValidInputArg(nmobj,InputArgument)
        
            ArgValidation = inputParser;
            ArgValidation.CaseSensitive = false;
            ArgValidation.FunctionName = 'NetModelCreator';
            ArgValidation.PartialMatching = true;
            
            
            
            DefaultShowThreshold = 0.5;
            load ChannelInfo.mat;
            DefaultLabelChannel = ChannelInfo.Label;
            
            DefaultIndexChannnelVisable = NaN;
          
            
%             expectedShapes = {'square','rectangle','parallelogram'};
            
            %             addRequired(ArgValidation,'width',@isnumeric);
            %             addOptional(ArgValidation,'height',defaultHeight,@isnumeric);
            addParameter(ArgValidation,'ShowThreshold',DefaultShowThreshold,@(x)validateattributes(x,...
                {'numeric'},{'>=',0,'<=',1,'numel',1}));
            addParameter(ArgValidation,'AdjacencyMatrix',@(x)validateattributes(x,...
                {'numeric'},{'>=',0,'<=',1,'square'}));
            addParameter(ArgValidation,'Frequency',@(x)validateattributes(x,...
                {'numeric'},{'>=',0,'integer'}));
            
            addParameter(ArgValidation,'LabelChannel', DefaultLabelChannel ,@(x)iscellstr(x));
            addParameter(ArgValidation,'IndexChannelVisable',DefaultIndexChannnelVisable,@(x)validateattributes(x,...
                {'numeric'},{'>=',1,'integer'}));
            
            parse(ArgValidation,InputArgument{:});
            
            nmobj.ShowThreshold = ArgValidation.Results.ShowThreshold;
            nmobj.AdjacencyMatrix = ArgValidation.Results.AdjacencyMatrix;
            
            if ismember(lower(ArgValidation.Results.LabelChannel),lower(DefaultLabelChannel))
                nmobj.LabelChannel = ArgValidation.Results.LabelChannel;
            else
                error('Illegal input argument ''LabelChannel''.');
            end
            if isnan(ArgValidation.Results.IndexChannelVisable)
                nmobj.IndexChannelVisable = 1:size( nmobj.AdjacencyMatrix,1);
            
            elseif max(ArgValidation.Results.IndexChannelVisable)<= size(nmobj.AdjacencyMatrix,1)
                nmobj.IndexChannelVisable = ArgValidation.Results.IndexChannelVisable;
%                 nmobj.FlagChannelVisable = false(1,size(nmobj.AdjacencyMatrix,1));
%                 nmobj.FlagChannelVisable(nmobj.IndexChannelVisable) = true;
            else
                error('Illegal input argument ''IndexChannelVisable''.');  
            end
            
            if numel(ArgValidation.Results.Frequency) == size(nmobj.AdjacencyMatrix)
                  nmobj.Freqency = ArgValidation.Results.Frequency;
            end

        
        end
        
        function nmobj = get.NumPlottedChannel(nmobj)
            
            nmobj.NumPlottedChannel =  size(nmobj.AdjacencyMatrix,1);
            
        end
        
        function nmobj = get.NumPlottedFrequency(nmobj)
            
            nmobj.NumPlottedFrequency = numel(nmobj.PlottedFrequency);
            
        end
        
        function ShowThresholdChanged(nmobj)

            nmobj.PlottedMatrix(nmobj.PlottedMatrix<nmobj.ShowThreshold) = NaN;
            
        end
        
        function IndexPlottedChannelVisableChanged(nmobj)
            
            nmobj.PlottedMatrix = nmobj.AdjacencyMatrix(nmobj.IndexChannelVisable,nmobj.IndexChannelVisable,:);
            
        end
        
         function PlottedFrequencyChanged(nmobj)
             
            [flag,index] = ismember(nmobj.PlottedFrequency,nmobj.Frequency);
            nmobj.PlottedMatrix = nmobj.AdjacencyMatrix(nmobj.IndexChannelVisable,nmobj.IndexChannelVisable,index(flag));
            
        end
        
    end
    
    
end