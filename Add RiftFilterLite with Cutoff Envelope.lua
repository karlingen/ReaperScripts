-- @version 1.0
-- @author karlingen
-- @description Add Cutoff Envelope for RiftFilterLite
-- @website https://github.com/karlingen

function RunScript()
    local fxName = "Rift Filter Lite"
    local selectedTracks = reaper.CountSelectedTracks(0)
    for i = 0, selectedTracks - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        local fxNumber = reaper.TrackFX_AddByName(track, fxName, false, 1)
        local cutoffParamIndex = 1
        local trackEnvelope = reaper.GetFXEnvelope(track, fxNumber, cutoffParamIndex, 1)
    end

    reaper.TrackList_AdjustWindows(false)
end

RunScript()
