# qb-jobCreator

DESCRIPTION
    Script that allows you to create unlimited locations for duty points, stashes, trashes, armories, garages, blips and zones
    Everything for certain job

FEATURES
    - All showed labels working only through floating 3DTexts at the moment
    - Blips visible only for jobs (only blip locations)
    - Trashes getting deleted every server or script restart
    - Completely editable content for armories like in qb-policejob cfg
    - You can spawn vehicles with certain vehicle settings (liveries, extras...)
    - Zones 
        - This thing is mostly for developers that want to create additional functions/events for job
        - I left little example
    
 

HOW TO ADD JOB 
    
    1. Add job to your qb-core/shared/jobs.lua
    2. Create lua file with job name in 'jobs' folder
    3. Rename job name on line 1 to match actual name of job (Config.Jobs['job_name']) and edit the file to your liking
