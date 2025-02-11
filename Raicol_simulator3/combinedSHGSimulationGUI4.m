function combinedSHGSimulationGUI
    % Initialize main GUI window
    gui = initializeGUI();
    
    % Create UI components
    createUIComponents(gui);
    
      % Call the dialog function
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
             'Position', [550 750 420 30], ...
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
uicontrol('Parent',gui, 'Style', 'text', 'String', 'For Peak Power=(Pulse Energy)/(Pulse Duration) calculation enter zero in Average Power. For Peak Power=(Average Power)/(Repetition Rate*Pulse duration) enter zero in Pulse Energy','BackgroundColor', [0.95 0.95 1], 'Position',[280 430 250 50],'FontSize',7);

   cont1 = uipanel('Parent', gui, ...
                              'Title', 'Wavelength Controllers', ...
                              'Position', [0.03 0.3 0.3 0.2]);
    
   cont2 = uipanel('Parent', gui, ...
                              'Title', 'Temperature Controllers', ...
                              'Position', [0.03 0.1 0.3 0.2]);

    cont3 = uipanel('Parent', gui, ...
                              'Title', 'Pulsed laser peak power calculator', ...
                              'Position', [0.18 0.6 0.15 0.35]);   
end

function createInputControls(gui)
    % Crystal parameters
    createLabeledInput(gui, 'Crystal Length [mm]', '30', [50 650 100 30], [160 650 100 30], 'Crystal_length_Input');
    createLabeledInput(gui, 'Crystal Period [microns]', '8.95', [50 600 100 30], [160 600 100 30], 'Crystal_period_Input');
    createLabeledInput(gui, 'Pulse Energy [J]', '0', [310 700 100 30], [420 700 100 30], 'Pulse_Energy_Input');
    createLabeledInput(gui, 'Pulse Duration [s]', '2e-12', [310 650 100 30], [420 650 100 30], 'Pulse_Duration_Input');
    createLabeledInput(gui, 'Repetition Rate [Hz]', '80e6', [310 600 100 30], [420 600 100 30], 'Repetition_Rate_Input');
    createLabeledInput(gui, 'Average power [W]', '1', [310 550 100 30], [420 550 100 30], 'Average_power_Input');
    createLabeledInput(gui, 'Peak power caclulator[W]', '1', [310 500 100 30], [420 500 100 30], 'Peak_power_Input');

    % Crystal type selector
    uicontrol('Style', 'text', 'Position', [50 700 100 30], 'String', 'Crystal Type');
    typePopup = uicontrol('Style', 'popupmenu', ...
                         'Position', [160 700 100 30], ...
                         'BackgroundColor',[1 0.9 0.8],...
                         'String', {'PPKTP-Type 0', 'PPKTP-Type 2', 'PPSLT', 'PPLN'});
    setappdata(gui, 'typePopup', typePopup);
    
%     uicontrol('Style', 'text', 'Position', [310 700 100 30], 'String', 'Laser Type');
%     typePopup = uicontrol('Style', 'popupmenu', ...
%                          'Position', [420 700 100 30], ...
%                          'BackgroundColor',[1 0.9 0.8],...
%                          'String', {'CW', 'Pulsed Laser'});
%     setappdata(gui, 'typePopup', typePopup);
%     
    
    % In the createInputControls function, add this code after the crystal type selector:

    % Beam parameters
    createLabeledInput(gui, 'Waist [microns]', '50', [50 550 100 30], [160 550 100 30], 'Beam_Waist_Input');
    createLabeledInput(gui, 'Pump Power [Watt]', '1', [50 500 100 30], [160 500 100 30], 'Pump_Power_Input');
    createLabeledInput(gui, 'Central WL [nm]', '1064', [260 150 100 30], [370 150 100 30], 'Centeral_WL_Input');
    createLabeledInput(gui, 'Central Temp [deg C]', '35', [260 310 100 30], [370 310 100 30], 'Centeral_Temp_Input');
    
    
    
    
    
    % Wavelength Dependence Inputs
    %uicontrol('Style', 'text', 'Position', [50 400 150 30], 'String', 'Wavelength Scan [nm]');
    createLabeledInput(gui, 'Min WL [nm]', '1063.8', [50 350 100 30], [160 350 100 30], 'Pump_Wavelength_min_Input');
    createLabeledInput(gui, 'Step WL [nm]', '0.02', [50 300 100 30], [160 300 100 30], 'Pump_Wavelength_dl_Input');
    createLabeledInput(gui, 'Max WL [nm]', '1064.4', [50 250 100 30], [160 250 100 30], 'Pump_Wavelength_max_Input');
    
    % Temperature Dependence Inputs
    %uicontrol('Style', 'text', 'Position', [50 200 150 30], 'String', 'Temperature Scan [C]');
    createLabeledInput(gui, 'Min Temp [deg C]', '30', [50 190 100 30], [160 190 100 30], 'Temp_min_Input');
    createLabeledInput(gui, 'Step Temp [deg C]', '0.5', [50 140 100 30], [160 140 100 30], 'Temp_dt_Input');
    createLabeledInput(gui, 'Max Temp [deg C]', '34', [50 90 100 30], [160 90 100 30], 'Temp_max_Input');
end






function createSimulationControls(gui)
    % Simulate Wavelength Dependence button
    uicontrol('Style', 'pushbutton', ...
             'Position', [300 260 150 40], ...
              'BackgroundColor', [1 1 1], ...
             'String', 'Simulate Wavelength', ...
             'Callback', @runWavelengthSimulation);
    
    % Simulate Temperature Dependence button
    uicontrol('Style', 'pushbutton', ...
             'Position', [300 100 150 40], ...
                'BackgroundColor', [1 1 1], ...
             'String', 'Simulate Temperature', ...
             'Callback', @runTemperatureSimulation);
         
         
          % Calculate waist button
    uicontrol('Style', 'pushbutton', ...
             'Position', [50 550 100 30], ...
             'String', 'Waist [microns]', ...
             'Callback', @runcalc);
         
         
     % Calculate peakpower button
    uicontrol('Style', 'pushbutton', ...
             'Position', [310 500 100 30], ...
             'String', 'Peak power [W]', ...
             'Callback', @runcalc2);      
         
         
end



function createPlotPanels(gui)

                     
                           

    % Wavelength Dependence Plot Panel
    wavelengthPanel = uipanel('Parent', gui, ...
                              'Title', 'Wavelength Dependence', ...
                              'Position', [0.4 0.52 0.55 0.4]);
    wavelengthAxes = axes('Parent', wavelengthPanel, ...
                          'Position', [0.15 0.15 0.75 0.75]);
    setappdata(gui, 'wavelengthAxes', wavelengthAxes);
    
    % Temperature Dependence Plot Panel
    temperaturePanel = uipanel('Parent', gui, ...
                               'Title', 'Temperature Dependence', ...
                               'Position', [0.4 0.1 0.55 0.4]);
    temperatureAxes = axes('Parent', temperaturePanel, ...
                           'Position', [0.15 0.15 0.75 0.75]);
    setappdata(gui, 'temperatureAxes', temperatureAxes);
   
                           
                           
end

function runcalc(hObject, ~)
    gui = get(hObject, 'Parent');
    
    % Get input values
    Crystal_length_Input = getappdata(gui, 'Crystal_length_Input');
    Centeral_WL_Input = getappdata(gui, 'Centeral_WL_Input');

    Centeral_WL = str2double(get(Centeral_WL_Input, 'String'))* 1e-7;
    Crystal_length = str2double(get(Crystal_length_Input, 'String'))./10;
    
      response = createYesNoDialog(num2str(Centeral_WL.*1e7));
    
    % Check the response and take action
    if response
        % User clicked 'Yes'
        disp('Continuing with the program...');
        % Add your code for continuing
    else
        % User clicked 'No' or closed the dialog
        disp('Program terminated by user.');
        % Add your code for cancellation
        return;
    end
    
    

    
    % Calculate optimal waist
    omega = sqrt((Crystal_length*Centeral_WL)/(2.84*2*pi));
    
    % Update waist input
    Beam_Waist_Input = uicontrol('Style', 'edit', ...
                                'Position', [160 550 100 30], ...
                                'String', num2str(omega*1e4));
    setappdata(gui, 'Beam_Waist_Input',  Beam_Waist_Input);
    
    
    
end
function result = createYesNoDialog(textfruser)
    % Create a yes/no dialog box in MATLAB GUI
    
    % Option 1: Using MATLAB's built-in questdlg function
    choice = questdlg(strcat({'The wavelength is',textfruser,'[nm]','Do you want to continue?'}), ...
                      'Confirmation', ... % Dialog title
                      'Yes', 'No', 'Yes'); % Default option is 'Yes'
    
    % Check the user's response
    switch choice
        case 'Yes'
            result = true;
            disp('User clicked Yes');
        case 'No'
            result = false;
            disp('User clicked No');
        otherwise
            result = false;
            disp('User closed the dialog or pressed Cancel');
    end
    
%     % Alternative method using msgbox with custom buttons
%     % Create a figure for the message box
%     h = msgbox('Do you want to continue?', 'Confirm', 'question', 'modal');
%     
%     % Add custom Yes and No buttons
%     set(h, 'WindowStyle', 'modal');
%     
%     % Wait for user response
%     uiwait(h);
  end

  
function runcalc2(hObject, ~)
    gui = get(hObject, 'Parent');
    
    % Get input values
    Pulse_Energy_Input = getappdata(gui, 'Pulse_Energy_Input');
    Pulse_Duration_Input = getappdata(gui, 'Pulse_Duration_Input');
    Repetition_Rate_Input = getappdata(gui, 'Repetition_Rate_Input');
    Average_power_Input = getappdata(gui, 'Average_power_Input');
    Peak_power_Input = getappdata(gui, 'Peak_power_Input');


    Pulse_Energy= str2double(get(Pulse_Energy_Input,'String'));
    Pulse_Duration = str2double(get(Pulse_Duration_Input, 'String'));
    Repetition_Rate = str2double(get( Repetition_Rate_Input,'String'));
    Average_power = str2double(get(Average_power_Input,'String'));
    Peak_power = str2double(get(Peak_power_Input,'String'));

    
    
    

    
    % Calculate optimal waist
    if Pulse_Energy==0; 
    Peak_power = Average_power/(Pulse_Duration*Repetition_Rate);
    end
    
    if Average_power==0;
    Peak_power = Pulse_Energy /(Pulse_Duration);
    end
    
    % Update waist input
    Peak_power1 = uicontrol('Style', 'edit', ...
                                'Position', [420 500 100 30], ...
                                'String', num2str(Peak_power));
    Pump_Power= uicontrol('Style', 'edit', ...
                                'Position', [160 500 100 30], ...
                                'String', num2str(Peak_power));                       
                            
                            
      Pump_Power=Peak_power;                      
    setappdata(gui, 'Peak_power_Input',  Peak_power1);
        setappdata(gui, 'Pump_Power_Input',  Peak_power1);

    
    
end
function createLabeledInput(gui, labelText, defaultValue, labelPos, inputPos, dataKey)
    uicontrol('Style', 'text', 'Position', labelPos, 'String', labelText);
    input = uicontrol('Style', 'edit', 'Position', inputPos, 'String', defaultValue);
    setappdata(gui, dataKey, input);

end

function runWavelengthSimulation(hObject, ~)
    gui = get(hObject, 'Parent');
    
    % Get simulation parameters
    params = getWavelengthSimulationParameters(gui);
    
    % Run simulation based on crystal type
    po2w = runWavelengthCrystalSimulation(params);
    
    % Plot results in wavelength axes
    plotWavelengthResults(gui, params, po2w);
end

function runTemperatureSimulation(hObject, ~)
    gui = get(hObject, 'Parent');
    
    % Get simulation parameters
    params = getTemperatureSimulationParameters(gui);
    
    % Run simulation based on crystal type
    po2w = runTemperatureCrystalSimulation(params);
    
    % Plot results in temperature axes
    plotTemperatureResults(gui, params, po2w);
end

function params = getWavelengthSimulationParameters(gui)
    % Retrieve and convert all input values
    params = struct();
    
    % Crystal parameters
    params.length = str2double(get(getappdata(gui, 'Crystal_length_Input'), 'String'))/10;
    params.period = str2double(get(getappdata(gui, 'Crystal_period_Input'), 'String')) * 1e-4;
    params.temperature = str2double(get(getappdata(gui, 'Centeral_Temp_Input'), 'String'));
    
    % Wavelength parameters
    params.wavelength_cl = str2double(get(getappdata(gui, 'Centeral_WL_Input'), 'String')) * 1e-7;
    params.wavelength_min = str2double(get(getappdata(gui, 'Pump_Wavelength_min_Input'), 'String')) * 1e-7;
    params.wavelength_max = str2double(get(getappdata(gui, 'Pump_Wavelength_max_Input'), 'String')) * 1e-7;
    params.wavelength_dl = str2double(get(getappdata(gui, 'Pump_Wavelength_dl_Input'), 'String')) * 1e-7;
    
    % Beam parameters
    params.waist = str2double(get(getappdata(gui, 'Beam_Waist_Input'),'String')).*1e-4;
    params.power = str2double(get(getappdata(gui, 'Pump_Power_Input'), 'String'));
    
    % Crystal type
    params.type = get(getappdata(gui, 'typePopup'), 'Value');
    
    return;
end

function params = getTemperatureSimulationParameters(gui)

    % Retrieve and convert all input values
    params = struct();
    
    % Crystal parameters
    params.length = str2double(get(getappdata(gui, 'Crystal_length_Input'), 'String'))/10;
    params.period = str2double(get(getappdata(gui, 'Crystal_period_Input'), 'String')) * 1e-4;
    params.wavelength = str2double(get(getappdata(gui, 'Centeral_WL_Input'), 'String'))* 1e-7;
    % Temperature parameters
    params.temp_min = str2double(get(getappdata(gui, 'Temp_min_Input'),'String'));
    params.temp_max = str2double(get(getappdata(gui, 'Temp_max_Input'), 'String'));
    params.temp_dt = str2double(get(getappdata(gui, 'Temp_dt_Input'), 'String'));
    
    % Beam parameters
    params.waist = str2double(get(getappdata(gui, 'Beam_Waist_Input'),'String')).*1e-4;
    params.power = str2double(get(getappdata(gui, 'Pump_Power_Input'), 'String'));
    
    % Crystal type
    params.type = get(getappdata(gui, 'typePopup'), 'Value');
    
    return;
end

% Update the simulation functions to handle the new crystal types
function po2w = runWavelengthCrystalSimulation(params)
    % Convert power to ergs/s
    power_ergs = params.power * 1e7;
    
    % Run appropriate simulation based on crystal type
    switch params.type
        case 1
            po2w = PhasM_lambda(params.length, params.waist, params.temperature, ...
                              power_ergs, params.wavelength_cl, params.wavelength_min, ...
                              params.wavelength_max, params.wavelength_dl, ...
                              params.period, 'PPKTP-Type 0');
        case 2
            po2w = PhasM_lambda(params.length, params.waist, params.temperature, ...
                              power_ergs, params.wavelength_cl, params.wavelength_min, ...
                              params.wavelength_max, params.wavelength_dl, ...
                              params.period, 'PPKTP-Type 2');
        case 3
            po2w = PhasM_lambda(params.length, params.waist, params.temperature, ...
                              power_ergs, params.wavelength_cl, params.wavelength_min, ...
                              params.wavelength_max, params.wavelength_dl, ...
                              params.period, 'PPSLT');
        case 4
            po2w = PhasM_lambda(params.length, params.waist, params.temperature, ...
                              power_ergs, params.wavelength_cl, params.wavelength_min, ...
                              params.wavelength_max, params.wavelength_dl, ...
                              params.period, 'PPLN');
    end
end

function po2w = runTemperatureCrystalSimulation(params)
    % Convert power to ergs/s
    power_ergs = params.power * 1e7;
    
    % Run appropriate simulation based on crystal type
    switch params.type
        case 1
            po2w = PhasM_Temp(params.length, params.waist, params.wavelength, power_ergs, ...
                              params.temp_min, params.temp_max, params.temp_dt, ...
                              params.period, 'PPKTP-Type 0');
        case 2
            po2w = PhasM_Temp(params.length, params.waist, params.wavelength, power_ergs, ...
                              params.temp_min, params.temp_max, params.temp_dt, ...
                              params.period, 'PPKTP-Type 2');
        case 3
            po2w = PhasM_Temp(params.length, params.waist, params.wavelength, power_ergs, ...
                              params.temp_min, params.temp_max, params.temp_dt, ...
                              params.period, 'PPSLT');
        case 4
            po2w = PhasM_Temp(params.length, params.waist, params.wavelength, power_ergs, ...
                              params.temp_min, params.temp_max, params.temp_dt, ...
                              params.period, 'PPLN');
    end
end

function plotWavelengthResults(gui, params, po2w)
    % Get wavelength axes
    ax = getappdata(gui, 'wavelengthAxes');
    
    % Generate wavelength array for x-axis
    wavelengths = (params.wavelength_min:params.wavelength_dl:params.wavelength_max).* 1e7;
    
    % Clear previous plot
    cla(ax);
    
    % Plot results
    plot( ax, wavelengths, po2w./1e7);
    title(ax, 'SH Power [W] vs Wavelength');
    
    xlabel(ax, 'Wavelength [nm]');
    ylabel(ax, 'SH Power [W]');
    grid(ax, 'on');
end

function plotTemperatureResults(gui, params, po2w)
    % Get temperature axes
    ax = getappdata(gui, 'temperatureAxes');
    
    % Generate temperature array for x-axis
    temps = (params.temp_min:params.temp_dt:params.temp_max);
    
    % Clear previous plot
    cla(ax);
    
    % Plot results
    plot(ax, temps, po2w./1e7, 'Color', [rand(1), rand(1), rand(1)]);
    title(ax, 'SH Power [W] vs Temperature');
    xlabel(ax, 'Temperature [ deg C]');
    ylabel(ax, 'SH Power [W]');
    grid(ax, 'on');
end

  
