classdef NetView < matlab.apps.AppBase
    
    % Properties that correspond to nvobj components
    properties (Access = public)

        ScreenSizeX
        ScreenSizeY
        InitialFigureSize
        HandleNetModel
        HandleNetController
        PanelGapWidth
        
    end
    

   
    properties(Access = private)
        
        UIFigure matlab.ui.Figure % UI Figure
        Panel1 matlab.ui.container.Panel %Panel1
        Panel2 matlab.ui.container.Panel %Panel2
        Panel3 matlab.ui.container.Panel %Panel3
        
        LabelDispalyMode  matlab.ui.control.Label
        DropDownDispalyMode matlab.ui.control.DropDown
        LabelSetFreq  matlab.ui.control.Label
        EditFieldSetFreq matlab.ui.control.EditField
        LabelSetThreshold  matlab.ui.control.Label
        SliderSetThreshold matlab.ui.control.Slider
        ButtonShowAll matlab.ui.control.Button 
        ButtonHideAll matlab.ui.control.Button 
        ButtonDefault matlab.ui.control.Button
        
        UIAxesNetGraph matlab.ui.control.UIAxes
        UIAxesSelectedGraph matlab.ui.control.UIAxes
        
        CalPanel1ComponnetPos ApplyVerizon
        CalPanel3ComponnetPos ApplyVerizon
        
    end
    
    methods (Access = private)
        
        
        % Get Screen Size
        function getScreenSize(nvobj)
            ScreenSize = get(0,'ScreenSize');
            nvobj.ScreenSizeX = ScreenSize(3);
            nvobj.ScreenSizeY = ScreenSize(4);
        end
        
        function validInputArgument(nvobj,InputArgument)
            
            ArgValidation = inputParser;
            ArgValidation.CaseSensitive = false;
            ArgValidation.FunctionName = 'NetModelCreator';
            ArgValidation.PartialMatching = true;
            
            DefaultUiFigureSize = 0.8;
            DefaultPanelGapWidth = 0.01;
            
            addParameter(ArgValidation,'InitialFigureSize',DefaultUiFigureSize,@(x)validateattributes(x,...
                {'numeric'},{'>=',0,'<=',1,'numel',1}));
            %             addParameter(ArgValidation,'HandleNetModel',@(x)validateattributes(x,{'NetModel'}));
            addParameter(ArgValidation,'PanelGapWidth',DefaultPanelGapWidth ,@(x)validateattributes(x,...
                {'numeric'},{'>=',0,'<=',1,'numel',1}));
            
            parse(ArgValidation,InputArgument{:});
            
            nvobj.InitialFigureSize = ArgValidation.Results.InitialFigureSize;
            nvobj.PanelGapWidth = ArgValidation.Results.PanelGapWidth;
            
            %             if isvalid(ArgValidation.Results.HandleNetModel)
            %                 nvobj.HandleNetModel = ArgValidation.Results.HandleNetModel;
            %             else
            %                 error('Invalid input argument ''HandleNetModel''');
            %             end
            
            
        end
        
        % UIFigure size change function
        function correctFigureSize(nvobj)
            
            SetFigurePos(nvobj);
            SetPanelPos(nvobj);
            SetPanel1ComponentPos(nvobj);
            SetPanel3ComponentPos(nvobj);
            SetGrpahPos(nvobj);
            
        end
    end
    
    % nvobj initialization and construction
    methods (Access = private)
        
        % Create UIFigure and components
        function createComponents(nvobj)
            %%
            % Create UIFigure
            nvobj.UIFigure = uifigure;
            
            nvobj.UIFigure.Position = [round((1-nvobj.InitialFigureSize )/2*nvobj.ScreenSizeX),...
                round((1-nvobj.InitialFigureSize )/2*nvobj.ScreenSizeY),...
                round(nvobj.InitialFigureSize *nvobj.ScreenSizeX),...
                round(nvobj.InitialFigureSize *nvobj.ScreenSizeY)];
            
            nvobj.UIFigure.Name = 'Net View';
            nvobj.UIFigure.Units = 'Pixels';
            nvobj.UIFigure.Resize = 'on';
            
            nvobj.UIFigure.SizeChangedFcn = createCallbackFcn(nvobj, @correctFigureSize);
            %             setAutoResize(nvobj, nvobj.UIFigure, true);
            
            %%
            % Create Panel1
            
            nvobj.Panel1 = uipanel(nvobj.UIFigure);
            
            nvobj.Panel1.BorderType = 'none';
            nvobj.Panel1.Title = '网络连接图';
            nvobj.Panel1.TitlePosition = 'lefttop';
            nvobj.Panel1.FontName = 'Helvetica';
            nvobj.Panel1.FontUnits = 'pixels';
            nvobj.Panel1.FontSize = 12;
            nvobj.Panel1.Units = 'pixels';
            %%
            % Create Panel2
            
            nvobj.Panel2 = uipanel(nvobj.UIFigure);
            
            
            
            nvobj.Panel2.BorderType = 'none';
            nvobj.Panel2.Title = '控制1';
            nvobj.Panel2.TitlePosition = 'lefttop';
            nvobj.Panel2.FontName = 'Helvetica';
            nvobj.Panel2.FontUnits = 'pixels';
            nvobj.Panel2.FontSize = 12;
            nvobj.Panel2.Units = 'pixels';
            %%
            % Create Panel3
            
            nvobj.Panel3 = uipanel(nvobj.UIFigure);
            
            nvobj.Panel3.BorderType = 'none';
            nvobj.Panel3.Title = '控制2';
            nvobj.Panel3.TitlePosition = 'lefttop';
            nvobj.Panel3.FontName = 'Helvetica';
            nvobj.Panel3.FontUnits = 'pixels';
            nvobj.Panel3.FontSize = 12;
            nvobj.Panel3.Units = 'pixels';
            
            SetPanelPos(nvobj);
            
            %%
            % Create LabelDisplayMode
            nvobj.LabelDispalyMode = uilabel(nvobj.Panel1);
            nvobj.LabelDispalyMode.HorizontalAlignment = 'right';
            nvobj.LabelDispalyMode.VerticalAlignment = 'center';
            nvobj.LabelDispalyMode.FontName = 'Helvetica';
            nvobj.LabelDispalyMode.Text = 'Mode';
            nvobj.LabelDispalyMode.FontSize = round(0.2 * nvobj.Panel1.Position(4)*0.2*0.5);
            
            % Create DisplayMode
            nvobj.DropDownDispalyMode = uidropdown(nvobj.Panel1);
            nvobj.DropDownDispalyMode.FontName = 'Helvetica';
            
            %%
            % Create LabelSetFreq
            nvobj.LabelSetFreq = uilabel(nvobj.Panel1);
            nvobj.LabelSetFreq.HorizontalAlignment = 'right';
            nvobj.LabelSetFreq.VerticalAlignment = 'center';
            nvobj.LabelSetFreq.FontName = 'Helvetica';
            nvobj.LabelSetFreq.Text = 'Frequency';
            nvobj.LabelSetFreq.FontSize = round(0.2 * nvobj.Panel1.Position(4)*0.2*0.5);
            
            % Create SetFreq
            nvobj.EditFieldSetFreq = uieditfield(nvobj.Panel1, 'text');
            nvobj.EditFieldSetFreq.FontName = 'Helvetica';
            
            %%
            % Create LabelSetThreshold
            nvobj.LabelSetThreshold = uilabel(nvobj.Panel1);
            nvobj.LabelSetThreshold.HorizontalAlignment = 'right';
            nvobj.LabelSetThreshold.VerticalAlignment = 'center';
            nvobj.LabelSetThreshold.Text = 'Threshold';
            nvobj.LabelSetThreshold.FontName = 'Helvetica';
            nvobj.LabelSetThreshold.FontSize = round(0.2 * nvobj.Panel1.Position(4)*0.2*0.5);
            
            % Create SetThreshold
            nvobj.SliderSetThreshold = uislider(nvobj.Panel1);
            nvobj.SliderSetThreshold.FontName = 'Helvetica';
            %             nvobj.SliderSetThreshold.MajorTicksMode = 'manual';
            %             nvobj.SliderSetThreshold.MajorTickLabels = {'0','0.2','0.4','0.6','0.8','1'};
            nvobj.SliderSetThreshold.Limits = [0,1];
            nvobj.SliderSetThreshold.Value = 0.5;
            %             nvobj.SliderSetThreshold.MinorTicks = linspace(0,1,11);
            
            nvobj.CalPanel1ComponnetPos = ApplyVerizon('ParentPosition',nvobj.Panel1.Position,'CanvasArea',[0.8,0.8,0.2,0.2],...
                'ApplyDirection','Vertical','AlignWay','Center','AlignLine',0.5,...
                'InternalMargin',1,'ExternalMargin',1,'ComponentSizeX',[0.9,0.9,0.9],...
                'ComponentSizeY',[0.25,0.2,0.25]);
            
            SetPanel1ComponentPos(nvobj);
            %%
            % Create 'Show All'Button
            nvobj.ButtonShowAll = uibutton(nvobj.Panel3, 'push');
            nvobj.ButtonShowAll.Text = 'Show All';
            
            % Create 'Hide All'Button
            nvobj.ButtonHideAll = uibutton(nvobj.Panel3, 'push');
            nvobj.ButtonHideAll.Text = 'Hide All';
            
            % Create 'Default'Button
            nvobj.ButtonDefault = uibutton(nvobj.Panel3, 'push');
            nvobj.ButtonDefault.Text = 'Default';
            
            
            nvobj.CalPanel3ComponnetPos = ApplyVerizon('ParentPosition',nvobj.Panel3.Position,'CanvasArea',[0,0,1,1],...
                'ApplyDirection','Vertical','AlignWay','Center','AlignLine',0.5,...
                'InternalMargin',0.5,'ExternalMargin',1.5,'ComponentSizeX',[0.5,0.5,0.5],...
                'ComponentSizeY',[0.1,0.1,0.1]);
            
            SetPanel3ComponentPos(nvobj);
            

            %%
            % Create UIAxes
            nvobj.UIAxesNetGraph = uiaxes(nvobj.Panel1);
%             title(nvobj.UIAxesNetGraph, 'Title');
%             xlabel(nvobj.UIAxesNetGraph, 'X');
%             ylabel(nvobj.UIAxesNetGraph, 'Y');
%             axis off; 
t = 0:pi/20:2*pi;
l = plot(t,sin(t));
l.LineWidth = 1;
l.Color = [0 0 0];
l.Parent = nvobj.UIAxesNetGraph;
l.LineJoin = 'round';
l.ButtonDownFcn ={@() disp('clicked')};
% line(t+.06,sin(t),...
%     'LineWidth',1,...
%     'Color',[0  0 0],...
%     'Parent',nvobj.UIAxesNetGraph);


            % Create UIAxes
            nvobj.UIAxesSelectedGraph = uiaxes(nvobj.Panel2);
%             title(nvobj.UIAxesNetGraph, 'Title');
%             xlabel(nvobj.UIAxesNetGraph, 'X');
%             ylabel(nvobj.UIAxesNetGraph, 'Y');
            axis(nvobj.UIAxesSelectedGraph,'off'); 
            SetGraphPos(nvobj);            
            
        end
    end
    
    methods (Access = public)
        
        % Construct nvobj
        function nvobj = NetView(varargin)
            %Input arguments validation
            validInputArgument(nvobj,varargin);
            %Get Screen Size
            getScreenSize(nvobj);
            % Create and configure components
            createComponents(nvobj);
            
            % Register the nvobj
            registerApp(nvobj, nvobj.UIFigure);
            
            %                 nvobj.HandleNetModel.addlistener('event',@fcn);
            %                 nvobj.HandleNetController = nvobj.CreateController();
            %                 nvobj.AttachToController(nvobj.ncobj);
            
            
            if nargout == 0
                clear nvobj;
            end
        end
        
        % Code that executes before nvobj deletion
        function delete(nvobj)
            
            % Delete UIFigure when nvobj is deleted
            delete(nvobj.UIFigure);
        end
        
    end
    
    methods (Access = private)
        function nvobj = SetFigurePos(nvobj)
            
            position = nvobj.UIFigure.Position;
            position(3) = position(4)/nvobj.ScreenSizeY*nvobj.ScreenSizeX;
            nvobj.UIFigure.Position = position;
            
        end
        
        function nvobj = SetPanelPos(nvobj)
            nvobj.Panel1.Position = [round(nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth),...
                round(nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth),...
                round(nvobj.UIFigure.Position(3)*(2/3)-nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*1.5),...
                round(nvobj.UIFigure.Position(4)-nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*2)];
            
            nvobj.Panel2.Position = [round(nvobj.UIFigure.Position(3)*(2/3) + nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*0.5),...
                round(nvobj.UIFigure.Position(4)*(1/2) + nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*0.5),...
                round(nvobj.UIFigure.Position(3)*(1/3)-nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*1.5),...
                round(nvobj.UIFigure.Position(4)*(1/2)-nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*1.5)];
            
            
            nvobj.Panel3.Position = [round(nvobj.UIFigure.Position(3)*(2/3) + nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*0.5),...
                round(nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth),...
                round(nvobj.UIFigure.Position(3)*(1/3)-nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*1.5),...
                round(nvobj.UIFigure.Position(4)*(1/2)-nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*1.5)];
            
            
        end
        
        function nvobj = SetPanel1ComponentPos(nvobj)
            
           nvobj.CalPanel1ComponnetPos.ParentPosition = nvobj.Panel1.Position;
            ComponentPos = nvobj.CalPanel1ComponnetPos.ComponentPosition;
            %因为Panel上方有标题
            ComponentPos(:,2) = ComponentPos(:,2) - 20;
            LabelPos(:,1) = round(ComponentPos(:,1) - nvobj.Panel1.Position(3) * 0.1);
            LabelPos(:,2) = ComponentPos(:,2);
            LabelPos(:,3) = repmat(round(nvobj.Panel1.Position(3) * 0.1 * 0.9),nvobj.CalPanel1ComponnetPos.NumComponent,1);
            LabelPos(:,4) = ComponentPos(:,4);
            
            
            nvobj.LabelDispalyMode.Position = LabelPos(1,:);
            nvobj.DropDownDispalyMode.Position = ComponentPos(1,:);
            
            nvobj.LabelSetFreq.Position =  LabelPos(2,:);
            nvobj.EditFieldSetFreq.Position = ComponentPos(2,:);
            
            nvobj.LabelSetThreshold.Position =  LabelPos(3,:);
            %Slider对象的高度(横放时)不能调
            ComponentPos(3,2) = round(ComponentPos(3,2)+ ComponentPos(3,4)/2 +10);
            ComponentPos(3,4) = 3;
            nvobj.SliderSetThreshold.InnerPosition = ComponentPos(3,:);
            %             nvobj.SliderSetThreshold.OuterPosition = ComponentPos(3,:);
            
        end
        
        
        
        function nvobj = SetPanel3ComponentPos(nvobj)
            
            nvobj.CalPanel3ComponnetPos.ParentPosition = nvobj.Panel3.Position;
            ComponentPos = nvobj.CalPanel3ComponnetPos.ComponentPosition;
            %因为Panel上方有标题
            ComponentPos(:,2) = ComponentPos(:,2) - 20;

            nvobj.ButtonShowAll.Position = ComponentPos(1,:);
            

            nvobj.ButtonHideAll.Position = ComponentPos(2,:);

            nvobj.ButtonDefault.Position = ComponentPos(3,:);
          
            
        end
        
        function SetGraphPos(nvobj)
            nxAxes = (nvobj.Panel1.Position(4)-20)/nvobj.Panel1.Position(3)*0.8;
            NormalizedPosition = [(1-nxAxes)/2,0.1,nxAxes,0.8];
            nvobj.UIAxesNetGraph.Position = [ NormalizedPosition(1)*nvobj.Panel1.Position(3),...
                                            NormalizedPosition(2)*(nvobj.Panel1.Position(4)-20),...
                                            NormalizedPosition(3)*nvobj.Panel1.Position(3),...
                                            NormalizedPosition(4)*(nvobj.Panel1.Position(4)-20)];
            nyAxes = nvobj.Panel2.Position(3)/(nvobj.Panel2.Position(4)-20)*0.8;
            NormalizedPosition = [0.1,(1-nyAxes)/2,0.8,nyAxes];
            nvobj.UIAxesSelectedGraph.Position = [NormalizedPosition(1)*nvobj.Panel2.Position(3),...
                                            NormalizedPosition(2)*(nvobj.Panel2.Position(4)-20),...
                                            NormalizedPosition(3)*nvobj.Panel2.Position(3),...
                                            NormalizedPosition(4)*(nvobj.Panel2.Position(4)-20)];
                                            
        
        end
        
        
    end
end



