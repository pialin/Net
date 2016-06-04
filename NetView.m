classdef NetView < matlab.apps.AppBase
    
    % Properties that correspond to nvobj components
    properties (Access = public)
        UIFigure matlab.ui.Figure % UI Figure
        Panel1 matlab.ui.container.Panel %Panel1
        Panel2 matlab.ui.container.Panel %Panel2
        Panel3 matlab.ui.container.Panel %Panel3
        LabelDispalyMode matlab.ui.control.Label    
        ChooseDisplayMode matlab.ui.control.DropDown 
        ScreenSizeX
        ScreenSizeY
        InitialFigureSize
        HandleNetModel
        HandleNetController
        PanelGapWidth
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
            position = nvobj.UIFigure.Position;
            position(3) = position(4)/nvobj.ScreenSizeY*nvobj.ScreenSizeX;
            nvobj.UIFigure.Position = position;
            
            
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
            
            nvobj.Panel1.Position = [round(nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth),...
                round(nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth),...
                round(nvobj.UIFigure.Position(3)*(2/3)-nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*1.5),...
                round(nvobj.UIFigure.Position(4)-nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*2)];
            
            nvobj.Panel1.BorderType = 'none';
            nvobj.Panel1.Title = '网络连接图';
            nvobj.Panel1.TitlePosition = 'lefttop';
            nvobj.Panel1.FontName = 'Noto Sans CJK SC Bold';
            nvobj.Panel1.FontUnits = 'pixels';
            nvobj.Panel1.FontSize = 12;
            nvobj.Panel1.Units = 'pixels';
%%
            % Create Panel2
            
            nvobj.Panel2 = uipanel(nvobj.UIFigure);
            
            nvobj.Panel2.Position = [round(nvobj.UIFigure.Position(3)*(2/3) + nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*0.5),...
                round(nvobj.UIFigure.Position(4)*(1/2) + nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*0.5),...
                round(nvobj.UIFigure.Position(3)*(1/3)-nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*1.5),...
                round(nvobj.UIFigure.Position(4)*(1/2)-nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*1.5)];
            
            nvobj.Panel2.BorderType = 'none';
            nvobj.Panel2.Title = '控制1';
            nvobj.Panel2.TitlePosition = 'lefttop';
            nvobj.Panel2.FontName = 'Noto Sans CJK SC Bold';
            nvobj.Panel2.FontUnits = 'pixels';
            nvobj.Panel2.FontSize = 12;
            nvobj.Panel2.Units = 'pixels';
%%
            % Create Panel3
            
            nvobj.Panel3 = uipanel(nvobj.UIFigure);
            
            nvobj.Panel3.Position = [round(nvobj.UIFigure.Position(3)*(2/3) + nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*0.5),...
                round(nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth),...
                round(nvobj.UIFigure.Position(3)*(1/3)-nvobj.UIFigure.Position(3)*nvobj.PanelGapWidth*1.5),...
                round(nvobj.UIFigure.Position(4)*(1/2)-nvobj.UIFigure.Position(4)*nvobj.PanelGapWidth*1.5)];
            
            nvobj.Panel3.BorderType = 'none';
            nvobj.Panel3.Title = '控制2';
            nvobj.Panel3.TitlePosition = 'lefttop';
            nvobj.Panel3.FontName = 'Noto Sans CJK SC Bold';
            nvobj.Panel3.FontUnits = 'pixels';
            nvobj.Panel3.FontSize = 12;
            nvobj.Panel3.Units = 'pixels';
            
%%
            % Create LabelDropDown
            nvobj.LabelDispalyMode = uilabel(nvobj.Panel1);
            nvobj.LabelDispalyMode.HorizontalAlignment = 'right';
            nvobj.LabelDropDown.Position = [76 147 63 15];
            nvobj.LabelDropDown.Text = 'Drop Down';

            % Create DropDown
            app.DropDown = uidropdown(app.Panel);
            app.DropDown.Position = [154 145 100 20];
 %%
  % Create LabelSlider
            app.LabelSlider = uilabel(app.Panel);
            app.LabelSlider.HorizontalAlignment = 'right';
            app.LabelSlider.Position = [22 125 33 15];
            app.LabelSlider.Text = 'Slider';

            % Create Slider
            app.Slider = uislider(app.Panel);
            app.Slider.Position = [76 131 150 3];
%%
% Create LabelEditField
            app.LabelEditField = uilabel(app.Panel);
            app.LabelEditField.HorizontalAlignment = 'right';
            app.LabelEditField.Position = [44 122 52 15];
            app.LabelEditField.Text = 'Edit Field';

            % Create EditField
            app.EditField = uieditfield(app.Panel, 'text');
            app.EditField.Position = [111 118 100 22];
%%
            % Create Button
            app.Button = uibutton(app.Panel, 'push');
            app.Button.Position = [71 98 100 22];
            
%%
 % Create UIAxes
            app.UIAxes = uiaxes(app.Panel);
            title(app.UIAxes, 'Title');
            xlabel(app.UIAxes, 'X');
            ylabel(app.UIAxes, 'Y');
            app.UIAxes.Position = [64 109 300 185];
            
            
            
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
end












