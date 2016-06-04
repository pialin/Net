classdef ApplyVerizon < handle
    properties (Access = public)
        
        %Input Variable
        ApplyDirection
        ParentPosition
        CanvasArea
        AlignWay
        AlignLine
        ExternalMargin
        InternalMargin
        ComponentSizeX
        ComponentSizeY
        
        NumComponent
        
        
    end
    properties (Access = private)
        
        %Internal Variable
        ComponentNormalizePosition
        
        
    end
    
    
    properties(Dependent)
        %Output Variable
        
        ComponentPosition
    end
    
    methods
        function avobj = ApplyVerizon(varargin)
            
            ArgValidation = inputParser;
            ArgValidation.CaseSensitive = false;
            ArgValidation.FunctionName = 'ApplyVerizonCreator';
            ArgValidation.PartialMatching = true;
            
            DefaultApplyDirection = 'Vertical';
            DefaultCanvasArea = [0,0,1,1];
            DefaultAlignWay = 'Center';
            DefaultAlignLine = 0.5;
            
            
            %默认间隔最大
            DefaultExternalMargin = 1;
            DefaultInternalMargin = 1;
            
            addParameter(ArgValidation,'ApplyDirection',DefaultApplyDirection,@(nx) any(validatestring(nx,{'Horizontal','Vertical'})));
            addParameter(ArgValidation,'ParentPosition',@(nx)validateattributes(nx,{'numeric'},{'numel',4},{'>=',0}));
            addParameter(ArgValidation,'CanvasArea',DefaultCanvasArea,@(nx)validateattributes(nx,{'numeric'},{'numel',4,'>=',0,'<=',1}));
            addParameter(ArgValidation,'AlignWay',DefaultAlignWay,@(nx) any(validatestring(nx,{'Left','Right','Top','Bootom','Center'})));
            addParameter(ArgValidation,'AlignLine',DefaultAlignLine,@(nx)validateattributes(nx,{'numeric'},{'numel',1,'>=',0,'<=',1}));
            addParameter(ArgValidation,'ExternalMargin',DefaultExternalMargin,@(nx)validateattributes(nx,{'numeric'},{'>=',0,'<=',1}));
            addParameter(ArgValidation,'InternalMargin',DefaultInternalMargin,@(nx)validateattributes(nx,{'numeric'},{'>=',0,'<=',1}));
            addParameter(ArgValidation,'ComponentSizeX',@(nx)validateattributes(nx,{'numeric'},{'>=',0,'<=',1}));
            addParameter(ArgValidation,'ComponentSizeY',@(nx)validateattributes(nx,{'numeric'},{'>=',0,'<=',1}));
            
            parse(ArgValidation,varargin{:});
            
            avobj.ApplyDirection = validatestring(ArgValidation.Results.ApplyDirection,{'Horizontal','Vertical'});
            avobj.ParentPosition = ArgValidation.Results.ParentPosition;
            avobj.CanvasArea = ArgValidation.Results.CanvasArea;
            avobj.AlignWay = validatestring(ArgValidation.Results.AlignWay,{'Left','Right','Top','Bottom','Center'});
            avobj.AlignLine = ArgValidation.Results.AlignLine;
            if numel(ArgValidation.Results.ComponentSizeX) == numel(ArgValidation.Results.ComponentSizeY)
                avobj.ComponentSizeX = reshape(ArgValidation.Results.ComponentSizeX,1,[]);
                avobj.ComponentSizeY = reshape(ArgValidation.Results.ComponentSizeY,1,[]);
            else
                error('Illegal input argument ''ComponentSizeX'' or ''ComponentSizeY''.');
            end
            
            
            
            if numel(ArgValidation.Results.ExternalMargin) == 1
                avobj.ExternalMargin = repmat(ArgValidation.Results.ExternalMargin,1,2);
            elseif numel(ArgValidation.Results.ExternalMargin) == 2
                avobj.ExternalMargin = reshape(ArgValidation.Results.ExternalMargin,1,2);
            else
                error('Illegal input argument ''ExternalMargin''.');
            end
            if numel(ArgValidation.Results.InternalMargin) == 1
                avobj.InternalMargin = repmat(ArgValidation.Results.InternalMargin,1,numel(avobj.ComponentSizeX)-1);
            elseif numel(ArgValidation.Results.InternalMargin) == numel(avobj.ComponentSizeX)-1
                avobj.InternalMargin = reshape(ArgValidation.Results.InternalMargin,1,[]);
            else
                error('Illegal input argument ''InternalMargin''.');
            end
            
            
            
            avobj.NumComponent  = numel(avobj.ComponentSizeX);
            
        end
        
        function ComponentPosition = get.ComponentPosition(avobj)
            if strcmpi(avobj.ApplyDirection,'Horizontal');
                
                avobj.ComponentNormalizePosition = CalPosHorizontal(avobj);
                
            elseif strcmpi(avobj.ApplyDirection,'Vertical');
                
                avobj.ComponentNormalizePosition = CalPosVertical(avobj);
                
            end
            
            ComponentPosition = Normal2Pixel(avobj);
            
        end
        
        
    end
    
    methods(Access = private)

        function avobj = CalPosVertical(avobj)
            
            TopDownMargin = (1-sum(avobj.ComponentSizeY))/(avobj.NumComponent+1)*avobj.ExternalMargin;
            MiddleMargin = (1-sum(avobj.ComponentSizeY))/(avobj.NumComponent+1)*avobj.InternalMargin;
            
            ny = reshape([avobj.ComponentSizeY(1:end-1);MiddleMargin],1,[]);
            ny = [TopDownMargin(1),ny,avobj.ComponentSizeY(end),TopDownMargin(2)];
            
            ny = cumsum(ny(1:end-1));
            
            nyStart = ny(1:2:end);
            
            
            if strcmpi(avobj.AlignWay,'Left')
                nxLeft = repmat(avobj.AlignLine,1,avobj.NumComponent);
                nxStart  = nxLeft;
                
            elseif strcmpi(avobj.AlignWay,'Center')
                nxMiddle = repmat(avobj.AlignLine,1,avobj.NumComponent);
                nxStart = nxMiddle - avobj.ComponentSizeX/2;
                
            elseif strcmpi(avobj.AlignWay,'Right')
                
                nxRight = repmat(avobj.AlignLine,1,avobj.NumComponent);
                nxStart  = nxRight - avobj.ComponentSizeX;
                
            else
                error('Illegal input argument ''AlignWay''.');
            end
            
            avobj.ComponentNormalizePosition(:,1) = nxStart;
            avobj.ComponentNormalizePosition(:,2) = nyStart;
            avobj.ComponentNormalizePosition(:,3) = avobj.ComponentSizeX;
            avobj.ComponentNormalizePosition(:,4) = avobj.ComponentSizeY;
            
            
        end
        
        
        function avobj = CalPosHorizontal(avobj)
            
            LeftRightMargin = (1-sum(avobj.ComponentSizeX))/(avobj.NumComponent+1)*avobj.ExternalMargin;
            MiddleMargin = (1-sum(avobj.ComponentSizeX))/(avobj.NumComponent+1)*avobj.InternalMargin;
            
            nx = reshape([avobj.ComponentSizeX(1:end-1);MiddleMargin],1,[]);
            nx = [LeftRightMargin(1),nx,avobj.ComponentSizeX(end),LeftRightMargin(2)];
            
            nx= cumsum(nx(1:end-1));
            
            nxStart = nx(1:2:end);
            
            
            if strcmpi(avobj.AlignWay,'Top')
                nyTop = repmat(avobj.AlignLine,1,avobj.NumComponent);
                nyStart  = nyTop - avobj.ComponentSizeY;
                
            elseif strcmpi(avobj.AlignWay,'Center')
                nyMiddle = repmat(avobj.AlignLine,1,avobj.NumComponent);
                nyStart = nyMiddle - avobj.ComponentSizeY/2;
                
            elseif strcmpi(avobj.AlignWay,'Bottom')
                
                nyBottom = repmat(avobj.AlignLine,1,avobj.NumComponent);
                nyStart  = nyBottom;
                
            else
                error('Illegal input argument ''AlignWay''.');
            end
            
            avobj.ComponentNormalizePosition(:,1) = nxStart;
            avobj.ComponentNormalizePosition(:,2) = nyStart;
            avobj.ComponentNormalizePosition(:,3) = avobj.ComponentSizeX;
            avobj.ComponentNormalizePosition(:,4) = avobj.ComponentSizeY;
            
            
        end
        
        
        
        function ComponentPosition = Normal2Pixel(avobj)
            CanvasPosition = zeros(1,4);
            ComponentPosition = zeros(avobj.NumComponent,4);
            CanvasPosition(1)  = round(avobj.ParentPosition(1) + avobj.ParentPosition(3)*avobj.CanvasArea(1));
            CanvasPosition(2)  = round(avobj.ParentPosition(2) + avobj.ParentPosition(4)*avobj.CanvasArea(2));
            CanvasPosition(3)  = round(avobj.ParentPosition(3)*avobj.CanvasArea(3));
            CanvasPosition(4)  = round(avobj.ParentPosition(4)*avobj.CanvasArea(4));
            
            ComponentPosition(:,1)  = round(CanvasPosition(1) + CanvasPosition(3)*avobj.ComponentNormalizePosition(:,1));
            ComponentPosition(:,2)  = round(CanvasPosition(2) + CanvasPosition(4)*avobj.ComponentNormalizePosition(:,2));
            ComponentPosition(:,3)  = round(CanvasPosition(3)*avobj.ComponentNormalizePosition(:,3));
            ComponentPosition(:,4)  = round(CanvasPosition(4)*avobj.ComponentNormalizePosition(:,4));
            
        end
    end
    
    
end




