function sceneInfo=getSceneInfo(scenario, opt)
% fill all necessary information about the
% scene into the sceneInfo struct
%
% Required:
%   detfile         detections file (.idl or .xml)
%   frameNums       frame numbers (eg. frameNums=1:107)
%   frameRate       frame rate of the video sequence (default: 25)
%   imgFolder       image folder
%   imgFileFormat   format for images (eg. frame_%04d.jpg)
%   targetSize      approx. size of targets (default: 5 on image, 350 in 3d)
%
% Required for 3D Tracking only
%   trackingArea    tracking area
%   camFile         camera calibration file (.xml PETS format)
%
% Optional:
%   gtFile          file with ground truth bounding boxes (.xml CVML)
%   initSolFile     initial solution (.xml or .mat)
%   targetAR        aspect ratio of targets on image
%   bgMask          mask to bleach out the background
%   dataset         name of the dataset
%   sequence        name of the sequence
%   scenario        sequence number
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.


if nargin<2
    global opt
end
% opt=getConOptions;
% general folders
homefolder=getHomeFolder;
dbfolder=fullfile(filesep,'storage','databases'); if ispc, dbfolder=fullfile('D:','storage','databases'); end
% if exist('/gris','dir'), dbfolder=fullfile(filesep,'gris','takatuka_dbases'); end
if exist('/gris','dir'), dbfolder=fullfile(filesep,'gris','gris-f','home','aandriye','storage'); end

global TUDDet  %%% TEMPORARY !!!


sceneInfo.scenario=scenario;
% dataset name
switch(scenario)
    case {20,21}
        dataset='epfl';
    case {22,23,25,27,70,71,72,73,74,75,80,24,26,101,102,103,104,105,111,112,113,114,115}
        dataset='PETS2009';
    case {40,41,42,43}
        dataset='TUD';
    case {30,31,32,35,36,37}
        dataset='TUD10';
    case {50,51,52,53}
        dataset='ETH-Person';
    case {60,61,62}
        dataset='AVSS';
    case {48}
        dataset='UBC';
    case {90,91,92}
        dataset='DA-ELS';
    case {95,96}
        dataset='AVG';
    case 97
        dataset='PNNL';        
    case {191,192,193,194,195,196,197,198,199}
        dataset='PNNL';
    case intersect(scenario,301:399)
        dataset='PRML';
    otherwise
        error('unknown scenario');
end
sceneInfo.dataset=dataset;

% sequence name
switch(scenario)
    case 20
        seqname='terrace1';
    case 21
        seqname='terrace2';
    case {22,23}
        seqname='PETS2009-S2L1-c1';
    case {25,24,101,102,103,104,105}
        seqname='PETS2009-S2L2-c1';
    case 27
        seqname='PETS2009-S2L3-c1';
    case 31
        seqname='TUD10-ped1-c1';
    case 32
        seqname='TUD10-ped1-c2';
    case 36
        seqname='TUD10-ped1-c1';
    case 37
        seqname='TUD10-ped2-c2';
    case 40
        seqname='TUD-Campus';
    case 41
        seqname='TUD-Crossing';
    case {42,43}
        seqname='TUD-Stadtmitte';
    case 48
        seqname='Hockey';
    case {50,51,52,53}
        seqname=sprintf('seq%02d',scenario-50);
    case 60
        seqname='AB_Easy';
    case 61
        seqname='AB_Medium';
    case 62
        seqname='AB_Hard';
    case 70
        seqname='PETS2009-S1L1-1-c1';
    case 71
        seqname='PETS2009-S1L1-2-c1';
    case {72,26,111,112,113,114,115}
        seqname='PETS2009-S1L2-1-c1';
    case 73
        seqname='PETS2009-S1L2-2-c1';
    case 74
        seqname='PETS2009-S1L3-1-c1';
    case 75
        seqname='PETS2009-S1L3-2-c1';
    case 80
        seqname='PETS2009-S3MF1-c1';
    case {90,91,92,93,94}
        seqname=sprintf('s%02d',scenario-90);
    case {95,96}
        seqname='Towncenter';
    case 97
        seqname='ParkingLot';
    case {191,192,193,194,195,196,197,198,199}
        seqname='ParkingLot';
    case intersect(scenario,301:399)
        seqname='prml-test';
    otherwise
        
        error('unknown scenario');
end
sceneInfo.sequence=seqname;


%% frameNums
switch(scenario)
    case 20 % terrace1
        sceneInfo.frameNums=1:2000;
    case 21 % terrace2
        sceneInfo.frameNums=1:2000;
    case {22,23} % PETS 2009 S2 L1
        sceneInfo.frameNums=0:794;
%     case 24 % PETSMONO occlusion
%         sceneInfo.frameNums=0:794;
    case {25,24,101,102,103,104,105}
        sceneInfo.frameNums=0:435;
    case 27
        sceneInfo.frameNums=0:239;
    case {30,31,32,33} % TUD10 ped
        sceneInfo.frameNums=1:1400;
        %         sceneInfo.frameNums=1:300;
    case {35,36,37} % TUD10 ped2
        sceneInfo.frameNums=1:1999;
        %         sceneInfo.frameNums=1:199;
        %         sceneInfo.frameNums=1670:1680;
        %         sceneInfo.frameNums=760:770;
    case 40 % tud-campus
        sceneInfo.frameNums=90:160;
    case {41,44} % tud-crossing
        sceneInfo.frameNums=1:201;
    case {42,43} % tud-stadtmitte
        sceneInfo.frameNums=7022:7200;
        %         sceneInfo.frameNums=7022:7100;
    case 45 % eth central xing1
        sceneInfo.frameNums=1600:2200;
    case 46 % eth central xing1
        sceneInfo.frameNums=3300:3600;
    case 47 % eth central xing1
        sceneInfo.frameNums=7433:7811;
    case 48 % UBC Hockey
        sceneInfo.frameNums=700:800;
    case 50 % ETH Person seq0
        sceneInfo.frameNums=180:678;
    case 51 % ETH Person seq1
        sceneInfo.frameNums=0:998;
    case 52 % ETH Person seq2
        sceneInfo.frameNums=0:450;
    case 53 % ETH Person seq3
        sceneInfo.frameNums=100:453;
    case {60,61,62} % AVSS
        sceneInfo.frameNums=1:2000;
    case 70
        sceneInfo.frameNums=0:220;
    case 71
        sceneInfo.frameNums=0:240;
    case {72,26,111,112,113,114,115}
        sceneInfo.frameNums=0:200;
    case 73
        sceneInfo.frameNums=0:130;
    case 74
        sceneInfo.frameNums=0:90;
    case 75
        sceneInfo.frameNums=0:343;
    case 80
        sceneInfo.frameNums=1:107;
    case 81
        sceneInfo.frameNums=0:231;
    case 82
        sceneInfo.frameNums=0:108;
    case 83
        sceneInfo.frameNums=0:169;
    case 84
        sceneInfo.frameNums=0:92;
    case 85
        sceneInfo.frameNums=0:107;
    case 86
        sceneInfo.frameNums=0:184;
    case {95,96}
        sceneInfo.frameNums=1:250;
    case 97
        sceneInfo.frameNums=1:250;
        %     case 90
        %         sceneInfo.frameNums=1:593;
        %     case 91
        %         sceneInfo.frameNums=1:307;
        %     case 92
        %         sceneInfo.frameNums=1:420;
    case {101,131} % EnterExitCrossingPaths1 cor, front
        sceneInfo.frameNums=0:382;
    case {102,132} % EnterExitCrossingPaths2 cor, front
        sceneInfo.frameNums=0:484;
    case {103,133} % OneLeaveShop1 cor, front
        sceneInfo.frameNums=0:294;
    case {104,134} % OneLeaveShop2 cor, front
        sceneInfo.frameNums=0:1118;
    case {105,135} % OneLeaveShopReenter1 cor, front
        sceneInfo.frameNums=0:389;
    case {106,136} % OneLeaveShopReenter2 cor, front
        sceneInfo.frameNums=0:559;
    case {107,137} % OneShopOneWait1 cor, front
        sceneInfo.frameNums=0:1376;
    case {108,138} % OneShopOneWait2 cor, front
        sceneInfo.frameNums=0:1461;
    case {109,139} % OneStopEnter1 cor, front
        sceneInfo.frameNums=0:1499;
    case {110,140} % OneStopEnter2 cor, front
        sceneInfo.frameNums=0:2724;
    case {111,141} % OneStopMoveEnter1 cor, front
        sceneInfo.frameNums=0:1586;
    case {112,142} % OneStopMoveEnter2 cor, front
        sceneInfo.frameNums=0:2236;
    case {113,143} % OneStopMoveNoEnter1 cor, front
        sceneInfo.frameNums=0:1664;
    case {114,144} % OneStopMoveNoEnter2 cor, front
        sceneInfo.frameNums=0:1034;
    case {115,145} % OneStopNoEnter1 cor, front
        sceneInfo.frameNums=0:1664;
    case {116,146} % OneStopNoEnter2 cor, front
        sceneInfo.frameNums=0:1034;
    case {117,147} % ShopAssistant1 cor, front
        sceneInfo.frameNums=0:1674;
    case {118,148} % ShopAssistant2 cor, front
        sceneInfo.frameNums=0:3699;
    case {119,149} % ThreePastShop1 cor, front
        sceneInfo.frameNums=0:1649;
    case {120,150} % ThreePastShop2 cor, front
        sceneInfo.frameNums=0:1520;
    case {121,151} % TwoEnterShop1 cor, front
        sceneInfo.frameNums=0:1644;
    case {122,152} % TwoEnterShop2 cor, front
        sceneInfo.frameNums=0:1604;
    case {123,153} % TwoEnterShop3 cor, front
        sceneInfo.frameNums=0:1604;
    case {124,154} % TwoLeaveShop1 cor, front
        sceneInfo.frameNums=0:1342;
    case {125,155} % TwoLeaveShop2 cor, front
        sceneInfo.frameNums=0:599;
    case {126,156} % WalkByShop1 cor, front
        sceneInfo.frameNums=0:2359;
    case 160
        sceneInfo.frameNums=171:184;
    case {161,162}
        sceneInfo.frameNums=97:114;
    case {191,192,193,194}
        sceneInfo.frameNums=1:250;
    case {195,196,197,198,199}
        sceneInfo.frameNums=1:750;
    case {301}
%         sceneInfo.frameNums=1:167;
%         sceneInfo.frameNums=1:23;
        sceneInfo.frameNums=1:108;
    case 302
        sceneInfo.frameNums=1:110;
    case 303
        sceneInfo.frameNums=1:206;
    case 311
        sceneInfo.frameNums=1:230;
    case 312
        sceneInfo.frameNums=1:160;
    case 313
        sceneInfo.frameNums=1:160;
    otherwise
        warning('unknown scenario getFrameNums');
end

%% frame rate
sceneInfo.frameRate=25;
switch(scenario)
    case {22,23,25,27,70,71,72,73,80,24,26,101,102,103,104,105,111,112,113,114,115} % PETS
        sceneInfo.frameRate=7;
    case {51,53} % ETH-Bahnhof and ETH-Sunnyday
        sceneInfo.frameRate=14;
    case 97
        sceneInfo.frameRate=10;
    case {191,192,193,194}
        sceneInfo.frameRate=10;
    case {195,196,197,198,199}
        sceneInfo.frameRate=30;
    case intersect(scenario,301:399)
        sceneInfo.frameRate=2;

end
%%

detfolder=fullfile(homefolder,'diss','detections','hog-hof-linsvm',dataset,seqname);
% detfolder=fullfile(homefolder,'diss','detections','swd-v2',dataset,seqname);
% detfolder=fullfile(dbfolder,'data-tud','det','',dataset,seqname);

%% detfile
switch(scenario)
    case 20
        sceneInfo.detfile='/home/aanton/diss/detections/hog-hof-linsvm/epfl/terrace1/c1/terrace1-c1-result-00000-05009-nms.xml';
    case 21
        sceneInfo.detfile='/home/aanton/diss/detections/hog-hof-linsvm/epfl/terrace2/c1/terrace1-c1-result-00000-04479-nms.xml';
    case 48
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'detections.mat');
    case 51
        sceneInfo.detfile=fullfile(detfolder,'test-result-nms-0.8.idl');
        sceneInfo.detfile=fullfile(detfolder,'pirsiavash.mat');
        sceneInfo.detfile=fullfile(homefolder,'diss/others/yangbo/ETH-Person/bahnhof_raw.avi.detection.mat');
    case 53
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'seq03-annot.idl');
        sceneInfo.detfile=fullfile(homefolder,'diss/others/yangbo/ETH-Person/sunnyday_raw.avi.detection.mat');
    case 62
        sceneInfo.detfile=fullfile(detfolder,['AVSS-' seqname sprintf('-result-00000-05059-nms.idl',length(sceneInfo.frameNums)-1)]);
    case {90,91,92}
        sceneInfo.detfile=fullfile(detfolder,'detections.mat');
    case 41
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/TUD/tud-crossing-detection.idl');
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/TUD/tud-crossing-single.idl');
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/TUD/tud-single.idl');
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data040913/resultsOnPaper/tud-crossing-single.idl'); 
%     case 42
%         sceneInfo.detfile='/home/aanton/visinf/projects/ongoing/vancura-bsc/Source/Detektor/Results/TUD/tud-stadtmitte/UpperBodyDetector_TUD-result-00000-00178-nms.idl'
%     case 25
%         sceneInfo.detfile='/home/aanton/visinf/projects/ongoing/vancura-bsc/Source/Tracking/occlusion/detections/PETS2009/Crowd_PETS09/S2/L2/Time_14-55/View_001/hog-sgdsvm/hoglbp.idl';
    case 24
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2-single.idl');
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_joint_d2_s6_bug_fix.idl'); 
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_joint_d2_s9_harder_nms_with_direction.idl'); 
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_joint_d2_s9_bbox_fix_with_direction.idl'); 
%             sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_integrateTracklets.mat'); 
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_integrateTracklets_with_direction.mat'); 
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_integrateTracklets_with_direction_newsig.mat'); 
%             sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_integrateTracklets_with_direction_nosig.mat'); 
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2_integrateTracklets_with_direction_nosig_gtori.mat'); 
    case 26
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1_L2_single_DPM.idl');
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1_L2_joint_d2_s6_bug_fix.idl');
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1_L2_joint_d2_s9_bbox_fix_with_directions.idl');
            sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1L2-tracklets.mat');
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1L2-tracklets_with_direction_nosig.mat');
    case {22,23,25,27,70,71,72,73,80,40,41,42}
        sceneInfo.detfile=fullfile(dbfolder,'data-tud','det',dataset,[seqname '-det.xml']);
    case 43
        sceneInfo.detfile=fullfile(homefolder,'diss/others/yangbo/TUD/TUD_Stadtmitte.avi.detection.mat');        
    case 95
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'TownCentre-output-HOGPedestrians.xml');
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'TownCentre-output-HOGHeads.xml');
    case 96
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'TownCentre-output-HOGHeads-heads.xml');
    case 97
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'Detection_PNNL_ParkingLot.xml');
    case 101
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2L2_tracklet_sigmoid_score.idl'); 
    case 111
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1L2_tracklet_sigmoid_score.idl'); 
    case 102
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2_L2-single.idl'); 
    case 112
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1_L2_single_DPM.idl'); 
    case 103
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2L2-joint-detector.idl'); 
    case 113
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1L2-joint-detector.idl'); 
    case 104
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S2L2-new-tracklet-detector.idl'); 
    case 105
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/Newmodel/PETSS2L2_LSSVM_VOC_DT_LOSS.idl'); 
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data/baseline-loop1/PETSS2L2-TESTING/Loop1-pattern1.idl'); 
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data/baseline-loop1/PETSS2L2-MINING/dpm_lsvm.idl'); 
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data/baseline-loop1/PETSS2L2-MINING/Loop1-pattern1.idl'); 
    case 114
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PETS2009/S1L2-new-tracklet-detector.idl'); 
    case 115
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/Newmodel/PETSS1L2_LSSVM_VOC_DT_LOSS.idl'); 
    case 191
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'Detection_PNNL_ParkingLot.xml');
    case 192
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PNNL/model_para_0_nms_1_para_0.5_pred_nms_2_para_0.5.idl'); 
    case 193
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/PNNL/partlot_joint_detection_hard_nms.idl'); 
    case 195
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data/baseline-loop1/Parkinglot/baseline.idl');
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data040913/PL/baseline-same-training-image.idl'); 
    case 196
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data/baseline-loop1/Parkinglot/Loop1-pattern1.idl');
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data040913/PL/joint-detector-1st-iteration.idl'); 
    case 197
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data/baseline-loop1/Parkinglot/Loop1-pattern2.idl');
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data040913/PL/joint-detector-2rd-iteration.idl'); 
    case 198
%         sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data/baseline-loop1/Parkinglot/baseline.idl');
        sceneInfo.detfile=fullfile(homefolder,'diss/others/siyu/data040913/PL/joint-detector-pre-deifned-pattern.idl'); 
    case 199
        sceneInfo.detfile=fullfile(dbfolder,dataset,seqname,'Detection_PNNL_ParkingLot.xml');
    case 301
        sceneInfo.detfile=fullfile(homefolder,'research','projects','irtracking','data','s1-easy.xml');
    case 302
        sceneInfo.detfile=fullfile(homefolder,'research','projects','irtracking','data','s1-medium.xml');
    case 303
        sceneInfo.detfile=fullfile(homefolder,'research','projects','irtracking','data','s1-hard.xml');
    case 311
        sceneInfo.detfile=fullfile(homefolder,'research','projects','irtracking','data','r1-easy.xml');
    case 312
        sceneInfo.detfile=fullfile(homefolder,'research','projects','irtracking','data','r1-medium.xml');
    case 313
        sceneInfo.detfile=fullfile(homefolder,'research','projects','irtracking','data','r1-hard.xml');
    case 399
        sceneInfo.detfile=fullfile(homefolder,'research','projects','irtracking','data','testanton.xml');
    otherwise
        sceneInfo.detfile=fullfile(detfolder,[seqname sprintf('-result-00000-%05d-nms.idl',length(sceneInfo.frameNums)-1)]);             
end

% TEMP PRML
if scenario>=301 && scenario<=399
    [pathstr, filename, ~]=fileparts(sceneInfo.detfile);
%     addpath('d:\prml\irtracking');
%     tmpdet=readData([pathstr filesep filename '.txt']);
%     tmpdet=load('d:\prml\irtracking\data\antonsynth.txt');
%     size(tmpdet)
    xDoc=xmlread(sceneInfo.detfile);
    allFrames=xDoc.getElementsByTagName('frame');    
    sceneInfo.frameNums=1:allFrames.getLength;
end
% sceneInfo.frameNums
% pause
% if scenario==41
%     sceneInfo.detfile=TUDDet;
%     
% end

fprintf('Detections file: %s\n',sceneInfo.detfile)
assert(exist(sceneInfo.detfile,'file')==2,'detection file does not exist')


%% img Folder
switch(scenario)
    case {20,21}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,'c1',filesep);
    case {22,23}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S2','L1','Time_12-34','View_001',filesep);
    case {25,24,101,102,103,104,105}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S2','L2','Time_14-55','View_001',filesep);
    case 27
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S2','L3','Time_14-41','View_001',filesep);
    case 31
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'ped1','c1',filesep);
    case 32
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'ped1','c2',filesep);
    case 36
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'ped2','c1',filesep);
    case 37
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'ped2','c2',filesep);
    case 40
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'tud-campus-sequence',filesep);
    case 41
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'tud-crossing-sequence',filesep);
    case {42,43}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'tud-stadtmitte',filesep);
    case 48
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,filesep);
    case {50,51,52,53}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,'left',filesep);
    case {60,61,62}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,filesep);
    case 70
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S1','L1','Time_13-57','View_001',filesep);
    case 71
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S1','L1','Time_13-59','View_001',filesep);
    case {72,26,111,112,113,114,115}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S1','L2','Time_14-06','View_001',filesep);
    case 73
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S1','L2','Time_14-31','View_001',filesep);
    case 80
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,'Crowd_PETS09','S3','Multiple_Flow','Time_12-43','View_001',filesep); % 80
    case {90,91,92,93}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,filesep);
    case {95,96}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,filesep);
    case 97
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,filesep,'frames',filesep);
    case {191,192,193,194}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,filesep,'frames',filesep);
    case {195,196,197,198,199}
        sceneInfo.imgFolder=fullfile(dbfolder,dataset,seqname,filesep,'allframes',filesep);
    case intersect(scenario,301:399)
        sceneInfo.imgFolder=fullfile(homefolder,'research','projects','irtracking','data','img',filesep);
    otherwise
        error('unknown scenario image Folder');
end
assert(exist(sceneInfo.imgFolder,'dir')==7,'imgfolder does not exist')

% image extension
imgExt='.jpg';
switch(scenario)
    case {20,21,40,41,42,43,44,50,51,52,53}
        imgExt='.png';
    case {97,191,192,193,194,195,196,197,198,199}
        imgExt='.png';
end
sceneInfo.imgFileFormat='frame_%04d';

switch(scenario)
    case 40
        sceneInfo.imgFileFormat='DaSide0811-seq6-%03d';
    case 41
        sceneInfo.imgFileFormat='DaSide0811-seq7-%03d';
    case {42,43}
        sceneInfo.imgFileFormat='DaMultiview-seq%04d';
    case 48
        sceneInfo.imgFileFormat='h%04d';
    case {50,51,52,53}
        sceneInfo.imgFileFormat='image_%08d_0';
    case {90,91,92,93}
        sceneInfo.imgFileFormat='%05d';
    case {97,191,192,193,194}       
        sceneInfo.imgFileFormat='%08d';
    case intersect(scenario,301:399)
        sceneInfo.imgFileFormat='frame_%05d';
end

% append file extension
sceneInfo.imgFileFormat=[sceneInfo.imgFileFormat imgExt];

% if no frame nums, determine from images
if ~isfield(sceneInfo,'frameNums')
    imglisting=dir([sceneInfo.imgFolder '*' imgExt]);
    sceneInfo.frameNums=1:length(imglisting);
end

% image dimensions
[sceneInfo.imgHeight, sceneInfo.imgWidth, ~]= ...
    size(imread([sceneInfo.imgFolder sprintf(sceneInfo.imgFileFormat,sceneInfo.frameNums(1))]));




%% tracking area
% if we are tracking on the ground plane
% we need to explicitly secify the tracking area
% otherwise image = tracking area


if opt.track3d
    switch(scenario)
        case {20,21}
            sceneInfo.trackingArea=[-2000 6000 0 9000];
        case {22,23,25,27,70,71,72,73,80,24,26,101,102,103,104,105,111,112,113,114,115}
            sceneInfo.trackingArea=[-14069.6, 4981.3, -14274.0, 1733.5];
        case {30,31,32}
            sceneInfo.trackingArea=[-197    6708   -2021    6870];
        case {35,36,37}
            sceneInfo.trackingArea=[-3438    5271   -2018    7376];
        case 40
            sceneInfo.trackingArea=[-0150 0506   28   1081];
        case 41
            sceneInfo.trackingArea=[-19, 12939, -48, 10053];
        case {42,43}
            sceneInfo.trackingArea=[-19, 12939, -48, 10053];
        case 51 % ETH Bahnhof
            sceneInfo.trackingArea=[-10000 10000 -500 120000];
        case intersect(scenario,301:399) % PRML
            sceneInfo.trackingArea=[0 8000 0 14000];
        otherwise
            error('Definition of tracking area needed for 3d tracking');
    end
    
else
    sceneInfo.trackingArea=[1 sceneInfo.imgWidth 1 sceneInfo.imgHeight];   % tracking area
end

%% camera
cameraconffile=[];
if opt.track3d
    cam=1;
    switch(scenario)
        case {20,21} %terrace
            cameraconffile=sprintf('%s/epfl/terrace-tsai-c%i.xml',dbfolder,cam);
        case {22, 23,25,27,70,71,72,73,74,75,80,81,82,83,84,85,86,24,26,101,102,103,104,105,111,112,113,114,115} %PETS2009
            cameraconffile=fullfile(dbfolder,dataset,'View_001.xml');
%         case 24
%             cameraconffile=sprintf('%sPETS2009/View_001.xml',dbfolder);
        case 30
            cameraconffile=sprintf('%sTUD10/ped1/c%i-calib.xml',dbfolder,cam);
        case 31
            cameraconffile=fullfile(dbfolder,dataset,'ped1/c1-calib.xml');
        case 32
            cameraconffile=fullfile(dbfolder,dataset,'ped1/c2-calib.xml');
        case 36
            cameraconffile=fullfile(dbfolder,dataset,'ped2/c1-calib.xml');
        case 37
            cameraconffile=fullfile(dbfolder,dataset,'ped2/c2-calib.xml');
        case 40
            cameraconffile=fullfile(dbfolder,dataset,'tud-campus-calib.xml');
        case {41,44}
            cameraconffile=fullfile(dbfolder,dataset,'tud-crossing-calib.xml');
        case {42,43}
            cameraconffile=fullfile(dbfolder,dataset,'tud-stadtmitte-calib.xml');
        case {45,46,47}
            cameraconffile=sprintf('%sETH-Central/pedxing-seq1-calib.xml',dbfolder);
        case 51
            cameraconffile=sprintf('%s/ETH-Person/seq01/left/calib/camPar.mat',dbfolder);
        case {60,61,62}
            cameraconffile=sprintf('%sAVSS/AB_calib.xml',dbfolder);
        case intersect(scenario,101:126)
            cameraconffile=sprintf('%sCAVIAR/CAVIAR-cor.xml',dbfolder);
        case intersect(scenario,131:156)
            cameraconffile=sprintf('%sCAVIAR/CAVIAR-front.xml',dbfolder);
        case intersect(scenario,160:163) %%% !!! FIX !!!
            cameraconffile=sprintf('%sCAVIAR/CAVIAR-front.xml',dbfolder);
        case intersect(scenario,301:399)
            cameraconffile=fullfile(homefolder,'research','projects','irtracking','data','cam.xml');    
        otherwise
            error('unknown scenario');
    end
end
sceneInfo.camFile=cameraconffile;

if ~isempty(sceneInfo.camFile)
    sceneInfo.camPar=parseCameraParameters(sceneInfo.camFile);
    %%
end


%% target size
sceneInfo.targetSize=20;                % target 'radius'
sceneInfo.targetSize=sceneInfo.imgWidth/30;
if scenario==41, sceneInfo.targetSize=10; end
if scenario==97, sceneInfo.targetSize=20; end
if scenario>190 && scenario<199, sceneInfo.targetSize=20; end
if scenario>300 && scenario<310, sceneInfo.targetSize=50; end
if opt.track3d, sceneInfo.targetSize=350; end
if opt.track3d && ~isempty(intersect(scenario,301:399)), sceneInfo.targetSize=1400; end

%% target aspect ratio
sceneInfo.targetAR=1/3;
switch(scenario)
    case 48 % Hockey
        sceneInfo.targetAR=1;
    case {90,91,92} % aerial
        sceneInfo.targetAR=1;
    case 96 % TownCenter heads
        sceneInfo.targetAR=1;
    case {195,196,197,198}
        sceneInfo=rmfield(sceneInfo,'targetAR');
    case intersect(scenario,301:399) % PRML
        sceneInfo.targetAR=1;
end


%% ground truth
sceneInfo.gtFile='';
switch(scenario)
    case 20
        sceneInfo.gtFile='/home/aanton/storage/databases/epfl/terrace1/GT_New.mat';
    case {22,23,25,27,70,71,72,73,80,48,24,26,101,102,103,104,105,111,112,113,114,115}
        sceneInfo.gtFile=fullfile(dbfolder,'data-tud','gt',dataset,[seqname '.mat']);
    case 31
        sceneInfo.gtFile=fullfile(dbfolder,dataset,'ped1','c1','GT2d_full_new.mat');
    case 32
        sceneInfo.gtFile=fullfile(dbfolder,dataset,'ped1','c2','GT2d_full_new.mat');
    case {40,41}
        sceneInfo.gtFile=fullfile(dbfolder,'data-tud','gt',dataset,[seqname '-interp.mat']);
%         sceneInfo.gtFile=fullfile(dbfolder,'data-tud','gt',dataset,[seqname '-orig.xml']);
    case {42,43}
        sceneInfo.gtFile=fullfile(dbfolder,'data-tud','gt',dataset,[seqname '.mat']);        
%         sceneInfo.gtFile=fullfile('/home/aanton/storage/databases/TUD/tud-stadtmitte/cvpr10_tud_stadtmitte.xml');  % michas orig
%                 sceneInfo.gtFile=fullfile(homefolder,'diss/others/yangbo/TUD/TUD_Stadtmitte.avi.gt.mat');        % Yang
%     case 48
%         sceneInfo.gtFile=fullfile('/home/aanton/storage/databases/UBC/Hockey/GT2d_full.xml');
    case 51
        sceneInfo.gtFile=fullfile(homefolder,'/diss/others/yangbo/ETH-Person/bahnhof_raw.avi.gt.mat');
    case 53
        sceneInfo.gtFile=fullfile(homefolder,'/diss/others/yangbo/ETH-Person/sunnyday_raw.avi.tracking.gt.mat');
    case {50,51,52,53} % ETH-Person
        sceneInfo.gtFile=fullfile(dbfolder,dataset,seqname,'GT2d_assc.mat');        
    case 62
        sceneInfo.gtFile=fullfile(dbfolder,'data-tud','gt',dataset,'AB_Hard','GT2d_new.mat');
    case 97
        sceneInfo.gtFile=fullfile(dbfolder,dataset,seqname,'GT_PNNL_ParkingLot.mat');
    case {191,192,193,194}
        sceneInfo.gtFile=fullfile(dbfolder,dataset,seqname,'siyu-gt_anno_all_id.mat');
    case {195,196,197,198,199}
%         sceneInfo.gtFile=fullfile(dbfolder,dataset,seqname,'siyu-gt_anno_all_id_all.mat');
        sceneInfo.gtFile=fullfile(dbfolder,dataset,seqname,'pnnlgt_full.mat');
%         sceneInfo.gtFile=fullfile(dbfolder,dataset,seqname,'GT_PNNL_ParkingLot_1-750.mat');
%         sceneInfo.gtFile=fullfile(dbfolder,dataset,seqname,'GT_PNNL_ParkingLot.mat');
    case 301
        sceneInfo.gtFile=fullfile(homefolder,'research','projects','irtracking','data','s1-easy_gt.xml');        
    case 302
        sceneInfo.gtFile=fullfile(homefolder,'research','projects','irtracking','data','s1-medium_gt.xml');
    case 303
        sceneInfo.gtFile=fullfile(homefolder,'research','projects','irtracking','data','s1-hard_gt.xml');
    case 311
        sceneInfo.gtFile=fullfile(homefolder,'research','projects','irtracking','data','r1-easy_gt.mat');        
    case 312
        sceneInfo.gtFile=fullfile(homefolder,'research','projects','irtracking','data','r1-medium_gt.mat');
    case 313
        sceneInfo.gtFile=fullfile(homefolder,'research','projects','irtracking','data','r1-hard_gt.mat');
    case 399
        sceneInfo.gtFile=fullfile(homefolder,'research','projects','irtracking','data','testanton_gt.xml');        
    otherwise
        warning('ground truth?');
end

fprintf('GT File: %s\n',sceneInfo.gtFile);

global gtInfo
sceneInfo.gtAvailable=0;
if ~isempty(sceneInfo.gtFile)
    sceneInfo.gtAvailable=1;
    % first determine the type
    [pathtogt, gtfile, fileext]=fileparts(sceneInfo.gtFile);
    
    if strcmpi(fileext,'.xml') % CVML
        gtInfo=parseGT(sceneInfo.gtFile);
    elseif strcmpi(fileext,'.mat')
        % check for the var gtInfo
        fileInfo=who('-file',sceneInfo.gtFile);
        varExists=0; cnt=0;
        while ~varExists && cnt<length(fileInfo)
            cnt=cnt+1;
            varExists=strcmp(fileInfo(cnt),'gtInfo');
        end
        
        if varExists
            load(sceneInfo.gtFile,'gtInfo');
        else
            warning('specified file does not contain correct ground truth');
            sceneInfo.gtAvailable=0;
        end
    end
    
    if opt.track3d
        if ~isfield(gtInfo,'Xgp') || ~isfield(gtInfo,'Ygp')
            [gtInfo.Xgp, gtInfo.Ygp]=projectToGroundPlane(gtInfo.X, gtInfo.Y, sceneInfo);
        end
    end
    gtInfo.Xi=gtInfo.X; gtInfo.Yi=gtInfo.Y;
    
    if opt.remOcc
        gtInfo=removeOccluded(gtInfo);
    end
    
        if strcmpi(fileext,'.xml'),     save(fullfile(pathtogt,[gtfile '.mat']),'gtInfo'); end
end

%% cut GT to tracking area
if  sceneInfo.gtAvailable && opt.track3d && opt.cutToTA
    gtInfo=cutGTToTrackingArea(gtInfo,sceneInfo);
end

%% check
if opt.track3d
    if ~isfield(sceneInfo,'trackingArea')
        error('tracking area [minx maxx miny maxy] required for 3d tracking');
    elseif ~isfield(sceneInfo,'camFile')
        error('camera parameters required for 3d tracking. Provide camera calibration or siwtch to 2d tracking');
    end
end

%% camera viewing angle
% even if we have camera and ground truth
% try estimating perspective
% sceneInfo.htobj=estimateTargetsSize(sceneInfo);

%% background mask
switch(scenario)
    case {22,23,25,27,70,71,72,73,80,81,82,83,84,85,42,43,24,26,101,102,103,104,105,111,112,113,114,115}
        sceneInfo.bgMask=fullfile(dbfolder,dataset,'bgmask.mat');
end

sceneInfo.scenario=scenario;

end