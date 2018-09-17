function varargout = label_data(varargin)
% LABEL_DATA MATLAB code for label_data.fig
%      LABEL_DATA, by itself, creates a new LABEL_DATA or raises the existing
%      singleton*.
%
%      H = LABEL_DATA returns the handle to a new LABEL_DATA or the handle to
%      the existing singleton*.
%
%      LABEL_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABEL_DATA.M with the given input arguments.
%
%      LABEL_DATA('Property','Value',...) creates a new LABEL_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before label_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to label_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help label_data

% Last Modified by GUIDE v2.5 12-Jul-2017 22:04:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @label_data_OpeningFcn, ...
                   'gui_OutputFcn',  @label_data_OutputFcn, ...
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

% --- Executes just before label_data is made visible.
function label_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to label_data (see VARARGIN)


global data_dir;
global RECORDS;
global label;
global list;
global index;
index = 1;
data_dir = evalin('base','data_dir');
RECORDS = evalin('base','RECORDS');
label = evalin('base','label');
class=evalin('base','class');
FT=evalin('base','FT');
% list = find(class==4 & label' ==2);
% 正常的，被识别为other，同时
list = find(label==3 & class'==2);
list =  find(class'==2 ~=0 &label==2 );
% Choose default command line output for label_data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.edit1, 'string',num2str(length(list)));
set(handles.edit2, 'string',num2str(index));
% This sets up the initial plot - only do when we are invisible
% so window can get raised using label_data.
if strcmp(get(hObject,'Visible'),'off')
    process(data_dir,RECORDS,label,list(index),1);
        str = sprintf('ref = %d   class = %d ', label(list(index)) , class(list(index)));
  set(handles.text3, 'string',str);
end

% UIWAIT makes label_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = label_data_OutputFcn(hObject, eventdata, handles)
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
popup_sel_index = get(handles.popupmenu1, 'Value');
global list;
global RECORDS;
global label;
global index;
global data_dir;
class=evalin('base','class');
FT=evalin('base','FT');
userlist = evalin('base','userlist');
switch popup_sel_index
    case 1
        list =  find(class'==2 ~=0 &label==2 );
    case 2
        list =  find(class'==3 ~=0 &label==2 );
    case 3
        list =  find(class'==4 ~=0 &label==2 );
    case 4
        list =  find(class'==3 ~=0 &label==3 );
    case 5
        list =  find(class'==2 ~=0 &label==3 );
    case 6
        list =  find(class'==4 ~=0 &label==3 );
    case 7
        list =  find(class'==4 ~=0 &label==4 );
    case 8
        list =  find(class'==2 ~=0 &label==4 );
    case 9
        list =  find(class'==3 ~=0 &label==4 );
     case 10
        list =  find(FT(5,:)~=0 ~=0 &label==2 );
    case 11
        list = userlist;
        
        
end
index = 1;
set(handles.edit1, 'string',num2str(length(list)));
set(handles.edit2, 'string',num2str(index));
    process(data_dir,RECORDS,label,list(index),1);
    str = sprintf('ref = %d   class = %d ', label(list(index)) , class(list(index)));
  set(handles.text3, 'string',str);
    
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

set(hObject, 'String', { '1.Normal as Normal','2.Normal as AF ', '3.Normal as Other','4.AF As AF', '5.AF As Normal',...
    '6.AF as Other','7.Other as Other','8.Other as Normal', '9.Other as AF','10.Normal as PVC','UserDefine'});

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data_dir;
global RECORDS;
global label;
global list;
class=evalin('base','class');
% axes(handles.axes1);
cla;
global index;
index = index + 1;
if index > length(list) index = 1; end;

 process(data_dir,RECORDS,label,list(index),1);
set(handles.edit2, 'string',num2str(index));
    str = sprintf('ref = %d   class = %d ', label(list(index)) , class(list(index)));
  set(handles.text3, 'string',str);        
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index;
global data_dir;
global RECORDS;
global label;
global list;
class=evalin('base','class');
index = index - 1;
if index < 1 index = length(list); end;

  process(data_dir,RECORDS,label,list(index),1);
set(handles.edit2, 'string',num2str(index));
    str = sprintf('ref = %d   class = %d ', label(list(index)) , class(list(index)));
  set(handles.text3, 'string',str);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

global index;
global data_dir;
global RECORDS;
global label;
global list;
class=evalin('base','class');

key = get(gcf,'CurrentKey'); % 取得当前按键的名称，是return、space...
switch key
    case 'space'
       
    case 'leftarrow'
      index = index - 1;
    case 'rightarrow'     
      index = index + 1;


end


if index < 1 index = length(list); end;
if index > length(list) index = 1; end;

  process(data_dir,RECORDS,label,list(index),1);
set(handles.edit2, 'string',num2str(index));
    str = sprintf('ref = %d   class = %d ', label(list(index)) , class(list(index)));
  set(handles.text3, 'string',str);

% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
