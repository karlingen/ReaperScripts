-- @version 1.0
-- @author karlingen
-- @description Toggle MetricAB
-- @website https://github.com/karlingen

function RunScript()  
  local fxName = "ADPTR MetricAB"

  -- The "Toggle" parameter number
  local fxParamIndex = 0
  local masterTrack = reaper.GetMasterTrack(0)

  -- The Monitor FX chain is considered to be the input fx chain of the master track, 
  -- so adding "|0x1000000" after the fx index gets the fx from the Monitor FX.
  local metricAB = reaper.TrackFX_AddByName(masterTrack, fxName, 1, 0)|0x1000000
  local toggleState = reaper.TrackFX_GetParamNormalized(masterTrack, metricAB, fxParamIndex)

  if toggleState == 0 then
    toggleState = 1
  else
    toggleState = 0
  end

  reaper.TrackFX_SetParamNormalized(masterTrack, metricAB, fxParamIndex, toggleState)
end

RunScript()
