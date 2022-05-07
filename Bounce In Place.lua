-- @version 1.0
-- @author karlingen
-- @description Bounce In Place
-- @website https://github.com/karlingen

function Act(id)
    reaper.Main_OnCommand(id, 0)
end

function RunScript()
    local item = reaper.GetSelectedMediaItem(0, 0)
    if not item then
        return
    end
    UnselectAllItems()

    reaper.SetMediaItemSelected(item, true)
    ApplyTakeFX()

    -- Grab the media item state after the FX have been applied to it.
    local _, itemStateChunk = reaper.GetItemStateChunk(item, "", true)
    local mediaItemTrack = reaper.GetMediaItemTrack(item)
    local currentVolume = reaper.GetMediaTrackInfo_Value(mediaItemTrack, "D_VOL")
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

    -- Set the name for the new track
    local trackName = reaper.GetTrackState(mediaItemTrack) .. " BIP"
    reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", trackName, true)

    CopyTrackValues(mediaItemTrack, newTrack)

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

function CopyTrackValues(FromTrack, ToTrack)
    trackInfoKeys = {
        "B_MUTE",
        "B_PHASE",
        "IP_TRACKNUMBER",
        "I_SOLO",
        "I_FXEN",
        "I_RECARM",
        "I_RECINPUT",
        "I_RECMODE",
        "I_RECMON",
        "I_RECMONITEMS",
        "I_AUTOMODE",
        "I_NCHAN",
        "I_SELECTED,",
        "I_WNDH",
        "I_TCPH",
        "I_TCPY",
        "I_MCPX",
        "I_MCPY",
        "I_MCPW",
        "I_MCPH",
        "I_FOLDERDEPTH",
        "I_FOLDERCOMPACT",
        "I_MIDIHWOUT",
        "I_PERFFLAGS",
        "I_CUSTOMCOLOR",
        "I_HEIGHTOVERRIDE",
        "B_HEIGHTLOCK",
        "D_VOL",
        "D_PAN",
        "D_WIDTH",
        "D_DUALPANL",
        "D_DUALPANR",
        "I_PANMODE",
        "D_PANLAW",
        "P_ENV",
        "B_SHOWINMIXER",
        "B_SHOWINTCP",
        "B_MAINSEND",
        "C_MAINSEND_OFFS",
        "B_FREEMODE",
        "C_BEATATTACHMODE",
        "F_MCP_FXSEND_SCALE",
        "F_MCP_SENDRGN_SCALE",
        "I_PLAY_OFFSET_FLAG",
        "D_PLAY_OFFSET"
    }

    for i = 1, #trackInfoKeys do
        local dictKey = trackInfoKeys[i]
        local theValue = reaper.GetMediaTrackInfo_Value(FromTrack, dictKey)
        reaper.SetMediaTrackInfo_Value(ToTrack, dictKey, theValue)
    end
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)
RunScript()
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock("Bounce In Place", 0)
