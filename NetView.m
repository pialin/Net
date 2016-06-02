classdef NetView < handle
    properties
        HandleFigure;
    end
    methods
        function nvobj = NetView()
            if verLessThan('matlab','R2016a')
                
            else
                nvobj.HandleFigure = uifigure;
                nvobj.HandleFigure.Position = [100 100 640 480];
                app.UIFigure.Name = 'NetViewer';
                setAutoResize(app, app.UIFigure, true)
            end
            
            
            
            % Create LabelSlider
            app.LabelSlider = uilabel(app.UIFigure);
            app.LabelSlider.HorizontalAlignment = 'right';
            app.LabelSlider.Position = [181 244 33 15];
            app.LabelSlider.Text = 'Slider';
            
            % Create Slider
            app.Slider = uislider(app.UIFigure);
            app.Slider.Position = [235 250 150 3];
            
            
        end
        
        
    end
end