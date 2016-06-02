classdef NetView < handle
    properties
        HandleFigure;
    end
    methods
        function nvobj = NetView(nmobj)
            get(0,'ScreenSize')
            if verLessThan('matlab','R2016a')
                
            else
                
                nvobj.nmobj = nmobj;
                
                
                nvobj.HandleUifigure.Name = 'NetView';
                nvobj.HandleUifigure.Position = [100 100 640 480];
                nvobj.HandleUifigure.Units = 'normalized';
                nvobj.HandleUifigure.Resize = 'on';
                nvobj.HandleUifigure.SizeChangedFcn = @;
                
                setAutoResize(nvobj, nvobj.HandleUifigure, true)
                
                nvobj.nmobj.addlistener('event',@fcn);
                nvobj.BuildUi;
                nvobj.ncobj = nvobj.CreateController();
                nvobj.AttachToController(nvobj.ncobj);
            end
            
            function BuildUi(nvobj)
                nvobj.HandleFigure = uifigure(nvobj.HandleUifigure);
                
                % Create LabelSlider
                nvobj.LabelSlider = uilabel(nvobj.HandleUifigure);
                nvobj.LabelSlider.HorizontalAlignment = 'right';
                nvobj.LabelSlider.Position = [181 244 33 15];
                nvobj.LabelSlider.Text = 'Slider';
                
                % Create Slider
                nvobj.Slider = uislider(nvobj.UIFigure);
                nvobj.Slider.Position = [235 250 150 3];
                nvobj.HandleSlider =
                
                
            end
            
            
            
            
            
            
        end
        
        
    end
end