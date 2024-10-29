# About us

This repository contains the material for the R user meet-up of [Amsterdam UMC](https://www.amsterdamumc.org/en/organization/amsterdam-umc.htm).

You can find out more and view the upcoming schedule [on our website](https://langtonhugh.github.io/rum_umc/).

# Contributing

If you want to add a new page for a session, navigate to `_posts`, copy a template folder from a previous session, and update the contents. Once you've created and written your `.Rmd` for the session, render/knit it, and then build the website in RStudio (i.e., `Build` tab, then `Build Website`). The website will deploy once you've pushed your changes or the pull request has been merged.

You can add your session material (e.g., data, R scripts) to the repository without building the website. Just navigate to `session_material` and deposit your scripts etc in the relevant folder, then push/pull request the changes.

The repository uses [renv](https://rstudio.github.io/renv/articles/renv.html) to manage package versions. 

