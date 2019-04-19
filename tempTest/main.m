clc
clear
%% 初始化设置 ========================================================
settings = initSettings();

%% 输入要测试的距离,并计算出延迟的要延迟的时间 =========================
distenses = input('输入要测试的距离数组，单位为 (m):');       %输入待测试数据
delay_times = distenses/settings.c;                        %计算延时的时间


for delay_point_index = 1:length(delay_times)
%% 产生伪码，并调制 ===================================================    
    w_code=cacode(settings.PRN,settings);                   % 产生伪随机码
    %对CA码进行采样，采样的同时已经做了伪码的延时
    samplecacodes = makeCaTable(delay_times(delay_point_index),...
        settings.PRN,settings.codeLength,settings.codeFreqBasis ,settings.samplingFreq,settings);
    spread_code= [samplecacodes samplecacodes];            

    
    t = (0:(length(spread_code) - 1))/settings.samplingFreq + delay_times(delay_point_index);   % 产生时间
    sendeddataL1=spread_code.*cos(2*pi*settings.IF1.*t);         %L1,搭载伪码 
    sendeddataL2=cos(2*pi*settings.IF2.*t);                      %L2,不搭载伪码
    sendeddata = sendeddataL1 + sendeddataL2;
    data= awgn(sendeddata, -20);                                 % 加噪声

    
%% 捕获，获取伪码的大概起始点和载波的频率 ==============================    
    acqResult = acquisition(data,settings);

%% 跟踪，分别对 L1 , L2 进行跟踪 ======================================
    trackResult1 = tracking(1,acqResult,settings,data);         %对L1进行跟踪
    trackResult2 = tracking2(1,acqResult,settings,data);        %对L2进行跟踪
    
%% 利用跟踪的结果来计算测距结果，并计算误差 ============================

    %计算结果，并把结果存入到finalDistances中
    finalDistances = calculatePseudoranges(...
                trackResult1, ...
                trackResult2,...
               settings);

    %输出伪码测距的相关计算       
    fprintf("真实距离 %f m , 伪码测得距离 %f m，绝对误差为 %f m，相对误差为 %f 。 \n",...
        distenses(delay_point_index),finalDistances.pseudorange1 , ...
        distenses(delay_point_index) - finalDistances.pseudorange1 ,...
        (distenses(delay_point_index) - finalDistances.pseudorange1)/distenses(delay_point_index)...
    );

    %输出双频伪码测距的相关计算
    fprintf("真实距离 %f m, 双频伪码测得距离 %f m，绝对误差为 %f m, 相对误差为 %f .\n",...
        distenses(delay_point_index),finalDistances.pseudorange2 , ...
        distenses(delay_point_index) - finalDistances.pseudorange2 , ...
         (distenses(delay_point_index) - finalDistances.pseudorange2)/distenses(delay_point_index) ...
    );
    
    a = 1;  %test
end