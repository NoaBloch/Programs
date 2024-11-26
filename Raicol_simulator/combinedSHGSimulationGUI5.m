function combinedSHGSimulationGUI
    % Initialize main GUI window
    gui = initializeGUI();
    
    % Create UI components
    createUIComponents(gui);
end

function gui = initializeGUI()
    % Create and configure main figure
    gui = figure('Name', 'Second Harmonic Generation Simulator', ...
        'Color', [0.95 0.95 1], ....
                'Position', [500 200 1600 800]);
    feature('DefaultCharacterSet', 'UTF-8');
    
end

function createUIComponents(gui)
    % Create title and headers
    createHeaders(gui);
    
    % Create input controls
    createInputControls(gui);
    
    % Create simulation controls
    createSimulationControls(gui);
    
    % Create plot panels
    createPlotPanels(gui);
end

function createHeaders(gui)
    % Main title
    uicontrol('Parent', gui, ...
             'Style', 'text', ...
             'String', 'Raicols Second Harmonic Simulator', ...
             'Position', [500 750 620 30], ...
             'FontSize', 12, ...
             'FontWeight', 'bold');
    
    % Hebrew title 
    str1 = char([1489 1505 1524 1491]);
    uicontrol('Parent', gui, ...
             'Style', 'text', ...
             'String', str1, ...
             'Position', [1200 750 600 40], ...
             'BackgroundColor', [0.95 0.95 1], ...
             'FontName', 'Arial', ...
             'FontSize', 12, ...
             'FontWeight', 'bold');

uicontrol('Parent',gui, 'Style', 'text', 'String', 'Push botton to optimize waist','BackgroundColor', [0.95 0.95 1], 'Position',[40 515 150 30],'FontSize',7);
uicontrol('Parent',gui, 'Style', 'text', 'String', 'For CW enter average power. For pulse enter peak power','BackgroundColor', [0.95 0.95 1], 'Position',[40 470 230 30],'FontSize',7);

end

function createInputControls(gui)
    % Crystal parameters
    createLabeledInput(gui, 'Crystal Length [mm]', '30', [50 650 100 30], [160 650 100 30], 'Crystal_length_Input');
    createLabeledInput(gui, 'Crystal Period [microns]', '8.95', [50 600 100 30], [160 600 100 30], 'Crystal_period_Input');
    
    % Crystal type selector
    uicontrol('Style', 'text', 'Position', [50 700 100 30], 'String', 'Crystal Type');
    typePopup = uicontrol('Style', 'popupmenu', ...
                         'Position', [160 700 100 30], ...
                         'BackgroundColor',[1 0.9 0.8],...
                         'String', {'PPKTP', 'PPSLT', 'PPLN'});
    setappdata(gui, 'typePopup', typePopup);
    
    % NEW CODE: Add radio button group for power type
    bg = uibuttongroup('Parent', gui,...
                       'Position', [50 450 200 40],...
                       'Title', 'Power Type',...
                       'BackgroundColor', [0.95 0.95 1]);
                   
    % Create radio buttons
    r1 = uicontrol(bg, 'Style', 'radiobutton',...
                   'String', 'CW',...
                   'Position', [10 5 70 20],...
                   'BackgroundColor', [0.95 0.95 1]);
               
    r2 = uicontrol(bg, 'Style', 'radiobutton',...
                   'String', 'Pulse',...
                   'Position', [100 5 70 20],...
                   'BackgroundColor', [0.95 0.95 1]);

    % Save the button group to gui data
    setappdata(gui, 'powerTypeGroup', bg);
    % END OF NEW CODE
    
    % Beam parameters
    createLabeledInput(gui, 'Waist [microns]', '50', [50 550 100 30], [160 550 100 30], 'Beam_Waist_Input');
    createLabeledInput(gui, 'Pump Power [Watt]', '1', [50 500 100 30], [160 500 100 30], 'Pump_Power_Input');
    createLabeledInput(gui, 'Central WL [nm]', '1064', [260 150 100 30], [370 150 100 30], 'Centeral_WL_Input');
    createLabeledInput(gui, 'Central Temp [deg C]', '35', [260 310 100 30], [370 310 100 30], 'Centeral_Temp_Input');
    createLabeledInput(gui, 'Min WL [nm]', '1063.8', [50 350 100 30], [160 350 100 30], 'Pump_Wavelength_min_Input');
    createLabeledInput(gui, 'Step WL [nm]', '0.02', [50 300 100 30], [160 300 100 30], 'Pump_Wavelength_dl_Input');
    createLabeledInput(gui, 'Max WL [nm]', '1064.4', [50 250 100 30], [160 250 100 30], 'Pump_Wavelength_max_Input');
    createLabeledInput(gui, 'Min Temp [deg C]', '30', [50 190 100 30], [160 190 100 30], 'Temp_min_Input');
    createLabeledInput(gui, 'Step Temp [deg C]', '0.5', [50 140 100 30], [160 140 100 30], 'Temp_dt_Input');
    createLabeledInput(gui, 'Max Temp [deg C]', '34', [50 90 100 30], [160 90 100 30], 'Temp_max_Input');
end

% NEW FUNCTION: Add this function to get power type
function powerType = getPowerType(gui)
    % Get the power type selection from radio buttons
    % Returns 'CW' or 'Pulse' as a string
    try
        % Get the button group and selected button
        buttonGroup = getappdata(gui, 'powerTypeGroup');
        selectedButton = get(get(buttonGroup, 'SelectedObject'), 'String');
        
        % Return the power type
        powerType = selectedButton;  % Will be either 'CW' or 'Pulse'
    catch
        % If there's any error, default to CW
        warning('Could not get power type selection. Defaulting to CW.');
        powerType = 'CW';
    end
end

% Rest of your code remains the same, but modify getWavelengthSimulationParameters and getTemperatureSimulationParameters:

function params = getWavelengthSimulationParameters(gui)
    % Existing code...
    params = struct();
    
    % Add power type to parameters
    params.powerType = getPowerType(gui);
    
    % Rest of your existing code...
    params.length = str2double(get(getappdata(gui, 'Crystal_length_Input'), 'String'))/10;
    params.period = str2double(get(getappdata(gui, 'Crystal_period_Input'), 'String')) * 1e-4;
    params.temperature = str2double(get(getappdata(gui, 'Centeral_Temp_Input'), 'String'));
    params.wavelength_cl = str2double(get(getappdata(gui, 'Centeral_WL_Input'), 'String')) * 1e-7;
    params.wavelength_min = str2double(get(getappdata(gui, 'Pump_Wavelength_min_Input'), 'String')) * 1e-7;
    params.wavelength_max = str2double(get(getappdata(gui, 'Pump_Wavelength_max_Input'), 'String')) * 1e-7;
    params.wavelength_dl = str2double(get(getappdata(gui, 'Pump_Wavelength_dl_Input'), 'String')) * 1e-7;
    params.waist = str2double(get(getappdata(gui, 'Beam_Waist_Input'),'String')).*1e-4;
    params.power = str2double(get(getappdata(gui, 'Pump_Power_Input'), 'String'));
    params.type = get(getappdata(gui, 'typePopup'), 'Value');
    return;
end

function params = getTemperatureSimulationParameters(gui)
    % Existing code...
    params = struct();
    
    % Add power type to parameters
    params.powerType = getPowerType(gui);
    
    % Rest of your existing code...
    params.length = str2double(get(getappdata(gui, 'Crystal_length_Input'), 'String'))/10;
    params.period = str2double(get(getappdata(gui, 'Crystal_period_Input'), 'String')) * 1e-4;
    params.wavelength = str2double(get(getappdata(gui, 'Centeral_WL_Input'), 'String'))* 1e-7;
    params.temp_min = str2double(get(getappdata(gui, 'Temp_min_Input'),'String'));
    params.temp_max = str2double(get(getappdata(gui, 'Temp_max_Input'), 'String'));
    params.temp_dt = str2double(get(getappdata(gui, 'Temp_dt_Input'), 'String'));
    params.waist = str2double(get(getappdata(gui, 'Beam_Waist_Input'),'String')).*1e-4;
    params.power = str2double(get(getappdata(gui, 'Pump_Power_Input'), 'String'));
    params.type = get(getappdata(gui, 'typePopup'), 'Value');
    return;
end

% The rest of your functions remain unchanged