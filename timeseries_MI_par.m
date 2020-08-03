function varargout = timeseries_MI_par(varargin)
% TIMESERIES_MI_PAR MATLAB code for timeseries_MI_par.fig
%      TIMESERIES_MI_PAR, by itself, creates a new TIMESERIES_MI_PAR or raises the existing
%      singleton*.
%
%      H = TIMESERIES_MI_PAR returns the handle to a new TIMESERIES_MI_PAR or the handle to
%      the existing singleton*.
%
%      TIMESERIES_MI_PAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMESERIES_MI_PAR.M with the given input arguments.
%
%      TIMESERIES_MI_PAR('Property','Value',...) creates a new TIMESERIES_MI_PAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before timeseries_MI_par_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to timeseries_MI_par_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help timeseries_MI_par

% Last Modified by GUIDE v2.5 29-Jul-2016 21:27:43

% Begin initialization code - DO NOT EDIT
% global Igorpro_output; 

% ******************** Relies on infotheory and minepy toolboxes
% *********************(AIT)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @timeseries_MI_par_OpeningFcn, ...
                   'gui_OutputFcn',  @timeseries_MI_par_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before timeseries_MI_par is made visible.
function timeseries_MI_par_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to timeseries_MI_par (see VARARGIN)

% Choose default command line output for timeseries_MI_par
%Miji;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using timeseries_MI_par.
if strcmp(get(hObject,'Visible'),'off')
    %D = evalin('base','D');
    D = get(handles.uitable1,'Data');
     plot(D(:,1));
     plot(handles.axes1,D);
end
set(handles.slider2,'Min',1);
set(handles.slider2,'Max',rank(D));
set(handles.slider2,'SliderStep',[1/(rank(D)-1) 10/(rank(D)-1)]);
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',length(D));
set(handles.slider4,'Min',-round(max(max(D))));
set(handles.slider4,'Max',round(max(max(D))));
set(handles.slider1,'SliderStep',[1/(length(D)-1) 10/(length(D)-1)]);
s1Listener=addlistener(handles.slider1, 'ContinuousValueChange', @(hObject, eventdata) popupmenu1_Callback(hObject, eventdata, handles));
s2Listener=addlistener(handles.slider2, 'ContinuousValueChange', @(hObject, eventdata) popupmenu1_Callback(hObject, eventdata, handles));
s4Listener=addlistener(handles.slider4, 'ContinuousValueChange', @(hObject, eventdata) popupmenu1_Callback(hObject, eventdata, handles));

% UIWAIT makes timeseries_MI_par wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = timeseries_MI_par_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

%D = evalin('base','D');
tStart = tic;
h=waitbar(0.1,'computing...');
set(h,'windowstyle','modal');
D = get(handles.uitable1,'Data');
Baseline=get(handles.slider4,'Value');
D=D-Baseline;
WinWidth =round(get(handles.slider1, 'Value'));
popup_sel_index = get(handles.popupmenu1, 'Value');
analysis_sel_index = get(handles.popupmenu2, 'Value');
rowD=size(D,1);
colD=size(D,2);
% D=gpuArray(D); % Try GPU
if popup_sel_index < 3
    d=round(get(handles.slider2,'Value'));
    if analysis_sel_index==1
        PlotData=D;
    elseif analysis_sel_index<7
%         PlotData=gpuArray(zeros((rankD-WinWidth),lengthD)); 
        PlotData=zeros((rowD-WinWidth),colD); 
        parfor j=1:(rowD-WinWidth) %parallel computing
            subD = D(j:j+WinWidth,:);
            for i=1:(colD)
                switch analysis_sel_index
                    case 2
                        %MI2D(j,i)=mutualInformation(subD(:,d),subD(:,i));
                        MI2D_coeff=mine(subD(:,d)',subD(:,i)');
                        PlotData(j,i)=MI2D_coeff.mic;
                        %             MAS2D(j,i)=MI2D_coeff.mas;
                        %             MEV2D(j,i)=MI2D_coeff.mev;
                        %             MCN2D(j,i)=MI2D_coeff.mcn;
                        %             MCNGEN2D(j,i)=MI2D_coeff.mcn_general;
                        %
                    case 3
                        PlotData(j,i)=dcor(subD(:,d),subD(:,i));
                    case 4
                        PlotData(j,i)=corr(subD(:,d),subD(:,i));
                    case 5
                        PlotData(j,i)=corr(subD(:,d),subD(:,i),'type','Kendall');
                    case 6
                        PlotData(j,i)=corr(subD(:,d),subD(:,i),'type','Spearman');
                end
            end
            waitbar(j/rowD)
        end
    else
        PlotData=zeros(2*rowD-1,colD);
%  PlotData=gpuArray(zeros(2*rankD-1,lengthD));
        parfor i=1:(colD); %rank(D);
            PlotData(:,i)=xcorr(D(:,d),D(:,i));
        end
    end
    switch popup_sel_index
        case 1
            plot(handles.axes1,PlotData);
%             plot(handles.axes1,gather(PlotData));
            set(handles.uitable2,'Data',PlotData);
%             set(handles.uitable2,'Data',gather(PlotData));
            zoom('on');
        case 2
            axes(handles.axes1);
            imagesc(PlotData');
% imagesc(gather(PlotData)');
            set(handles.uitable2,'Data',PlotData);
%             set(handles.uitable2,'Data',gather(PlotData));
            zoom('on');
    end
else
       if analysis_sel_index < 6
        PlotData=zeros(colD,colD,(rowD-WinWidth));
%         PlotData=gpuArray(zeros(lengthD,lengthD,(rankD-WinWidth)));% preallocated
       parfor d=1:colD
       for j=1:(rowD-WinWidth)
            subD = D(j:j+WinWidth,:);
            for i=1:colD
                                switch analysis_sel_index
%                 % %                     case 1
%                 % %                         PlotData=D;
%                 % %                         %                         i=rank(D);
%                 % %                         %                         j=length(D)-WinWidth;
%                 % %                         %                         d=rank(D);
%                 % %                         break
                                    case 2
                                        MI(i,d,j)=mutualInformation(subD(:,d),subD(:,i));
                                        MI_coeff=mine(subD(:,d)',subD(:,i)');
                                        % MIC, mutual information coeff
                                        PlotData(i,d,j)=MI_coeff.mic;
                                        %                         MAS(i,d,j)=MI_coeff.mas;
                                        %                         MEV(i,d,j)=MI_coeff.mev;
                                        %                         MCN(i,d,j)=MI_coeff.mcn;
                                        %                         MCNGEN(i,d,j)=MI_coeff.mcn_general;
                                    case 3
%                 % Distance correlation
                PlotData(i,d,j)=dcor(subD(:,d),subD(:,i));
                                    case 4
                                        % Pearson
                                        PlotData(i,d,j)=corr(subD(:,d),subD(:,i));
                                    case 5
                                        % Kendall
                                        PlotData(i,d,j)=corr(subD(:,d),subD(:,i),'type','Kendall');
                                    case 6
                                        % Spearman
                                        PlotData(i,d,j)=corr(subD(:,d),subD(:,i),'type','Spearman');
%                 
%            waitbar(d*i*j/lengthD/lengthD/rankD)     
            end
            end
       set(handles.text2,'String',toc(tStart));     
       end
   
    waitbar(d/colD)
       end
     else
        PlotData=zeros(colD,colD,(2*rowD-1)); % preallocated
          parfor d=1:colD
            for z=1:colD
            PlotData(z,d,:)=(xcorr(D(:,d),D(:,z)))';
            end
        end
       end
       assignin('base','tsMIout',PlotData)
       Ccell=mean(PlotData,1);
%        Ccell=mean(gather(PlotData),1);
Ccell_sq=squeeze(Ccell(1,:,:));
Cf=mean(Ccell_sq,1);
cla(handles.axes1,'reset');
axes(handles.axes1);
hold on
plot(Ccell_sq','s');
plot(Cf','k');
zoom('on');
hold off
set(handles.uitable2,'Data',[Ccell_sq' Cf']);
end
close(h)
toc(tStart)
set(handles.text2,'String',toc(tStart));



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Line Plot','Image Plot/Heatmap','Correlation Matrix'});

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
popupmenu1_Callback(hObject, eventdata, handles);






% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Original','Mutual Information','Distance Correlation','Pearson','Kendall','Spearman','Cross-Correlation'});



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit1,'String',num2str(get(handles.slider1, 'Value')));




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% D = evalin('base','D');
D = get(handles.uitable1,'Data');
set(handles.edit2,'String',num2str(get(handles.slider2, 'Value')));
plot(handles.axes2,D(:,get(handles.slider2,'Value')));


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
% WinWidth= get(handles.slider1, 'Value');
set(handles.slider1,'Value',str2double(get(handles.edit1, 'String')));




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
% D = evalin('base','D');
D = get(handles.uitable1,'Data');
set(handles.slider2,'Value',str2double(get(handles.edit2, 'String')));
plot(handles.axes2,D(:,get(handles.slider2,'Value')));

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
D = importdata('-pastespecial');
set(handles.uitable1,'Data',D);
%popupmenu1_Callback(hObject, eventdata, handles);


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit4,'String',num2str(get(handles.slider4, 'Value')));


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
set(handles.slider4,'Value',str2double(get(handles.edit1, 'String')));


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function copy_output_table_Callback(hObject, eventdata, handles)
% hObject    handle to copy_output_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clipboard('copy',get(handles.uitable2,'Data'));


% --------------------------------------------------------------------
function Edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function compCopy(op, np)
%COMPCOPY copies a figure object represented by "op" and its % descendants to another figure "np" preserving the same hierarchy.

ch = get(op, 'children');
if ~isempty(ch)
nh = copyobj(ch,np);
for k = 1:length(ch)
compCopy(ch(k),nh(k));
end
end;
%return;


% --------------------------------------------------------------------
function table_clipboard_Callback(hObject, eventdata, handles)
% hObject    handle to table_clipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
copy(get(handles.uitable2,'Data'),'.');


% --------------------------------------------------------------------
function graph_clipboard_Callback(hObject, eventdata, handles)
% hObject    handle to graph_clipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig2 = figure;
handles.axes3=axes;
compCopy(handles.axes1, handles.axes3);
print(fig2,'-clipboard','-dmeta','-r600');
close(fig2);


% --------------------------------------------------------------------
function bmp_graph_clipboard_Callback(hObject, eventdata, handles)
% hObject    handle to bmp_graph_clipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig2 = figure;
handles.axes3=axes;
compCopy(handles.axes1, handles.axes3);
print(fig2,'-clipboard','-dbitmap','-r600');
close(fig2);


% --------------------------------------------------------------------
function paste_data_Callback(hObject, eventdata, handles)
% hObject    handle to paste_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
D = importdata('-pastespecial');
set(handles.uitable1,'Data',D);
popupmenu1_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
