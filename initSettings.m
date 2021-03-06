function settings = initSettings()
%Functions initializes and saves settings. Settings can be edited inside of
%the function, updated from the command line or updated using a dedicated
%GUI - "setSettings".  
%
%All settings are described inside function code.
%
%settings = initSettings()
%
%   Inputs: none
%
%   Outputs:
%       settings     - Receiver settings (a structure). 接收机设置（结构体）

%--------------------------------------------------------------------------
%                           SoftGNSS v3.0
% 
% Copyright (C) Darius Plausinaitis
% Written by Darius Plausinaitis
%--------------------------------------------------------------------------
%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or (at your option) any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program; if not, write to the Free Software
%Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
%USA.
%--------------------------------------------------------------------------

% CVS record:
% $Id: initSettings.m,v 1.9.2.31 2006/08/18 11:41:57 dpl Exp $

%% Processing settings ====================================================
% Number of milliseconds to be processed used 36000 + any transients (see
% below - in Nav parameters) to ensure nav subframes are provided
%
settings.msToProcess        = 1000;        %[ms]需要处理的毫秒数

% Number of channels to be used for signal processing
settings.numberOfChannels   = 1;    %通道数（即卫星个数）

settings.PRN = 18;

% Move the starting point of processing. Can be used to start the signal
% processing at any point in the data record (e.g. for long records). fseek
% function is used to move the file read point, therefore advance is byte
% based only. 
%移动数据处理的开始点。能在数据记录中的任何一点开始信号处理。
%fseek函数移动文件的读取点
settings.skipNumberOfBytes     = 0;  %跳过的字节数

%% Raw signal file name and other parameter ========原始信号文件名和其它参数=======================
% This is a "default" name of the data file (signal record) to be used in
% the post-processing mode

% Data type used to store one sample
settings.dataType           = 'int8';   %存储一个采样的数据类型

% Intermediate, sampling and code frequencies
settings.IF1                 = 9.548e6 %1.42e6 %4.123968e6;      %[Hz]   %L1中频
settings.samplingFreq       = 38.192e6 %5.714e6 %16.367667e6;     %[Hz] %采样频率比
settings.codeFreqBasis      = 1.023e6;      %[Hz]   %码元的基频
settings.IF2                 = 14.548e6 %1.42e6 %4.123968e6;      %[Hz]   %L2中频
% Define number of chips in a code period
settings.codeLength         = 1023;     %一个码元周期的“片”数
%每个CA码周期的采样数，整数倍不好38192
settings.samplesPerCode = round(settings.samplingFreq /(settings.codeFreqBasis/settings.codeLength));  %一个码元有多少个采样点

%% Acquisition settings ==============捕获设置=====================================
% Skips acquisition in the script postProcessing.m if set to 1
%如果设置为1
settings.skipAcquisition    = 0;
% List of satellites to look for. Some satellites can be excluded to speed
% up acquisition    %所搜寻的卫星列表，可以排除一些卫星以加快捕获
%settings.acqSatelliteList   = 1:32;         %[PRN numbers]  %捕获的卫星列表
% Band around IF to search for satellite signal. Depends on max Doppler
%由最大多普勒频率决定
settings.acqSearchBand      = 10;           %[kHz]
% Threshold for the signal presence decision rule
settings.acqThreshold       = 2.5;  %判决阈值

%% Tracking loops settings =============跟踪环路设置===================================
% Code tracking loop parameters     码跟踪环路参数
settings.dllDampingRatio         = 0.7;
settings.dllNoiseBandwidth       = 2;       %[Hz]
settings.dllCorrelatorSpacing    = 0.5;     %[chips]

% Carrier tracking loop parameters  载波跟踪环参数
settings.pllDampingRatio         = 0.7;
settings.pllNoiseBandwidth       = 25;      %[Hz]

% Period for calculating pseudoranges and position
settings.navSolPeriod       = 20;          %[ms]


settings.K_step = 0;                     %FLL转向PLL时间
%% Plot settings ==========================================================
% Enable/disable plotting of the tracking results for each channel
settings.plotTracking       = 1;            % 0 - Off
                                            % 1 - On

                                            
%% Constants ==============================================================

settings.c                  = 299792458;    % The speed of light, [m/s]
settings.startOffset        = 0;       %[ms] Initial sign. travel time
