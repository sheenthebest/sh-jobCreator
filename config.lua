Config = Config or {}
Config.FuelExport = 'LegacyFuel' -- or cc-fuel etc....

Config.Jobs = {} -- all jobs are added in 'jobs' folder

--[[ 
    HOW TO ADD JOB 
    
    1. Add job to your qb-core/shared/jobs.lua
    2. Create lua file with job name in 'jobs' folder
    3. Rename job name on line 1 (Config.Jobs['job_name']) and edit the file to ur liking
]]
