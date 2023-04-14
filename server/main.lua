AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, v in pairs(Config.Jobs) do
            if next(v.trash) and v.trash.enable then
                MySQL.query("DELETE FROM stashitems WHERE stash = ?", { 'jobTrash_'..k})
            end
        end
    end
end)
