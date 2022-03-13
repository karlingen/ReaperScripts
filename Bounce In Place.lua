-- @version 1.0
-- @author karlingen
-- @description Bounce In Place
-- @website https://github.com/karlingen

function Act(id) reaper.Main_OnCommand(id, 0) end

function RunScript()
    local item = reaper.GetSelectedMediaItem(0, 0)
    if not item then return end
    UnselectAllItems()

    reaper.SetMediaItemSelected(item, true)
    ApplyTakeFX()

    -- Grab the media item state after the FX have been applied to it.
    local _, itemStateChunk = reaper.GetItemStateChunk(item, '', true)
    local mediaItemTrack = reaper.GetMediaItemTrack(item)
    local currentTrackId = reaper.CSurf_TrackToID(mediaItemTrack, false)

    local newTrack = reaper.GetSelectedTrack(0, 0)
    if not newTrack or mediaItemTrack == newTrack then
        reaper.InsertTrackAtIndex(currentTrackId, false)
        newTrack = reaper.CSurf_TrackFromID(currentTrackId + 1, false)
        reaper.TrackList_AdjustWindows(false)
    end

    -- Setup a new empty media item to track
    local newMediaItem = reaper.AddMediaItemToTrack(newTrack)

    -- Delete active take from the old track and mute the media item
    DeleteActiveTakeFromItems()
    MuteMediaItem()

    -- Copy the applied FX state to the new media item
    reaper.SetItemStateChunk(newMediaItem, itemStateChunk, true)

    UnselectAllItems()

    -- Select the new media item and keep only the active take
    reaper.SetMediaItemSelected(newMediaItem, true)

    CropToActiveTakeInItems()

    reaper.SetOnlyTrackSelected(newTrack)
    reaper.UpdateArrange()
end

function ApplyTakeFX()
    reaper.Main_OnCommand(40209, 0)
end

function UnselectAllItems()
    Act(40289)
end

function MuteMediaItem()
    Act(40719)
end

function CropToActiveTakeInItems()
    Act(40131)
end

function DeleteActiveTakeFromItems()
    Act(40129)
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)
RunScript()
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock('Bounce In Place', 0)
