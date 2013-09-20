function track3d=howToTrack(scenario)

track3d=0;                  % set to 1 for track estimation on ground plane
allpets=[20,21,23,25,27,70,71,72,73,74,75,80,24,26,101,102,103,104,105,111,112,113,114,115];
allprml=301:399;
if ~isempty(intersect(scenario,allpets)) || ... % all PETS
        ~isempty(intersect(scenario,42)) || ... % TUD Stadtmitte
        ~isempty(intersect(scenario,allprml)) || ... % PRML
        ~isempty(intersect(scenario,[]))  % BAHNHOF        
    track3d=1;
end

end