local hs = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    local status = "Unknown"
    for i, condition in ipairs(obj.status.conditions) do
      if condition.type == "Valid" and condition.status ~= "True" then
        status = "Degraded"
        hs.message = condition.message
      end
      if condition.type.Quota and condition.status ~= "True" then
        status = "Degraded"
        hs.message = condition.message
      end
      -- Only set to progressing if we are not already degraded
      if condition.type == "Capacity" and condition.status ~= "True" and status ~= "Degraded" then
        status = "Progressing"
        hs.message = condition.message
      end
      -- Only set to healthy if we are still unknown
      if condition.type == "AtTarget" and condition.status == "True" and status == "Unknown" then
        status = "Healthy"
        hs.message = condition.message
      end
    end
    hs.status = status
  else
    hs.status = "Progressing"
    hs.message = "Waiting for nodepool status conditions" 
  end
end

-- Default to progressing if no status yet
hs.status = "Progressing"
hs.message = "Waiting for nodepool status"
return hs
