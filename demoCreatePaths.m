%% demo create synthetic data
global scenario gtInfo
createPaths;
scenario=399;
sceneInfo=getSceneInfo(scenario);
displayGroundTruth(sceneInfo,gtInfo);
viewLocations('data/testanton.txt');