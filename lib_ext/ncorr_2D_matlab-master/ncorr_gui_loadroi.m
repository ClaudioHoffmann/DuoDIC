function outstate = ncorr_gui_loadroi(img,roi,pos_parent)
% This is a mini GUI for displaying a loaded region of interest.
%
% Inputs -----------------------------------------------------------------%
%   img - ncorr_class_img; single image used for displaying the background
%   image.
%   roi - ncorr_class_roi; used for displaying the ROI
%   pos_parent - integer array; this is the position of the parent figure
%   which determines where to position this figure
%
% Outputs ----------------------------------------------------------------%
%   outstate - integer; returns either out.cancelled, out.failed, or
%   out.success.

    % Data ---------------------------------------------------------------%
    % Initialize Output
    outstate = out.cancelled;    
    % Get GUI handles
    handles_gui = init_gui();    
    % Run c-tor
    feval(ncorr_util_wrapcallbacktrycatch(@constructor,handles_gui.figure));
    
    % Callbacks and functions --------------------------------------------%
    function constructor()         
        % Set images
        update_axes('set');
        
        % Format window
        set(handles_gui.figure,'Visible','on'); 
    end
    
    function callback_button_finish(hObject,eventdata) %#ok<INUSD>
        % Set output
        outstate = out.success;
        
        % Exit
        close(handles_gui.figure);
    end

    function callback_button_cancel(hObject,eventdata) %#ok<INUSD>
        close(handles_gui.figure);
    end

    function update_axes(action)
        if (strcmp(action,'set'))            
            % Overlay ROI over img
            preview_roi = img.get_gs();
            preview_roi(roi.mask) = preview_roi(roi.mask)+img.max_gs;
            imshow(preview_roi,[img.min_gs 2*img.max_gs],'Parent',handles_gui.axes_preview);
            set(handles_gui.axes_preview,'Visible','off');
            set(handles_gui.text_name,'String',['Name: ' img.name(1:min(end,22))]);
        end
    end

    function handles_gui = init_gui()
    % GUI controls -------------------------------------------------------%
        % Figure
        handles_gui.figure = figure( ...
            'Tag', 'figure', ...
            'Units', 'characters', ...
            'Position', ncorr_util_figpos(pos_parent,[35 126.7]), ...
            'Name', 'Load ROI', ...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'Color', get(0,'DefaultUicontrolBackgroundColor'), ...
            'handlevisibility','off', ...
            'DockControls','off', ...
            'Resize','off', ...
            'WindowStyle','modal', ...
            'Visible','off', ...
            'IntegerHandle','off', ...
            'Interruptible','off');

        % Panels
        handles_gui.group_menu = uipanel( ...
            'Parent', handles_gui.figure, ...
            'Tag', 'group_menu', ...
            'Units', 'characters', ...
            'Position', [2 27.8 35 6.6], ...
            'Title', 'Menu', ...
            'Interruptible','off');

        handles_gui.group_preview = uibuttongroup( ...
            'Parent', handles_gui.figure, ...
            'Tag', 'group_preview', ...
            'Units', 'characters', ...
            'Position', [38.7 0.75 85.8 33.6], ...
            'Title', 'ROI Preview', ...
            'Interruptible','off');

        % Axes
        handles_gui.axes_preview = axes( ...
            'Parent', handles_gui.group_preview, ...
            'Tag', 'axes_preview', ...
            'Units', 'characters', ...
            'Visible','off', ...
            'Position', [2.4 3 80 28.6], ...
            'Interruptible','off');

        % Static texts    
        handles_gui.text_name = uicontrol( ...
            'Parent', handles_gui.group_preview, ...
            'Tag', 'text_name', ...
            'Style', 'text', ...
            'Units', 'characters', ...
            'Position', [3 0.7 56.9 1.3], ...
            'String', 'Name: ', ...
            'HorizontalAlignment', 'left', ...
            'Interruptible','off');        
        
        % Pushbuttons
        handles_gui.button_finish = uicontrol( ...
            'Parent', handles_gui.group_menu, ...
            'Tag', 'button_finish', ...
            'Style', 'pushbutton', ...
            'Units', 'characters', ...
            'Position', [2.1 3 29.7 1.7], ...
            'String', 'Finish', ...
            'Callback', ncorr_util_wrapcallbacktrycatch(@callback_button_finish,handles_gui.figure), ...
            'Interruptible','off');

        handles_gui.button_cancel = uicontrol( ...
            'Parent', handles_gui.group_menu, ...
            'Tag', 'button_cancel', ...
            'Style', 'pushbutton', ...
            'Units', 'characters', ...
            'Position', [2.1 1 29.7 1.7], ...
            'String', 'Cancel', ...
            'Callback', ncorr_util_wrapcallbacktrycatch(@callback_button_cancel), ...
            'Interruptible','off');    
    end

    % Pause until figure is closed ---------------------------------------%
    waitfor(handles_gui.figure);
end
