# Ghruul

_**G**it**H**ub **R**eleases **U**pdate **U**tility for **L**inux_

Small bash-based utility for installation and updates of Linux packages published on GitHub that makes use 
of the [latest release API](https://docs.github.com/de/rest/releases/releases?apiVersion=2022-11-28#get-the-latest-release).

Some packages are published via GitHub only or have a newer release version than elsewhere (distribution repositories, Flatpak etc.). 
This utility helps to install and update them in a convenient way, using the established software management tools of Linux distributions.

## Which package formats are supported

Currently, only `.deb`@`apt` and `.rpm`@`dnf` package installations are supported.

Additionally, you can add and apply a custom script to install/update the package if it is released in another format (see _"Custom scripts"_).

## Dependencies

`curl` and `jq` should be installed on your system.

## How to start

1. Create an initial **semicolon-separated** CSV file with relevant GitHub data (see `sample.csv` and the example entry below). You can place it in the `versions` directory whose contents are Git-ignored.
2. Run `./ghruul <path-to-csv-file>` (use `sudo` prefix if you run `apt` or `dnf` with it as well)

## For updates

Run `./ghruul <path-to-csv-file>` every time you want to update to the most current versions of packages.

After each update run you'll get a "clean" CSV (e.g., `sample.csv.clean`), which you can use again as a starting point.

## Example of CSV entry

Each entry of the Ghruul-compatible CSV consists of the relevant data of the repository that publishes its releases on GitHub. 

In order to describe an example entry, the [k9s repository](https://github.com/derailed/k9s) will be used. 
Following data is used to create an entry:

1. Should this package get an update? Possible values: `Y` or `N`
2. GitHub owner of the repository (here: `derailed`)
3. Name of the repository (here: `k9s`)
4. Installed version: **do not fill**, will be updated on first install
5. Type of the package (currently only `deb` or `npm` are supported)
6. Pattern to look for in the package file name to install (see _"How to define a file name pattern"_)
7. Custom script path (see _"Custom scripts"_)

So the final CSV entry in this case is:

    Y;derailed;k9s;--;deb;linux_amd64.deb;--

### How to define a file name pattern

The most simple way is to go to the GitHub overview of the repository and check the (latest) release assets there in order 
to check if the repository provides releases in the required format. Then you need to find the unique pattern in the filename 
that matches this asset only. Typically, the asset name ends with this pattern, 
e.g. `linux_amd64.deb` for the [k9s releases](https://github.com/derailed/k9s/releases).

## Custom scripts

In order to install the package that was published in the format other than the supported ones, you can write a custom script 
that downloads and installs or updates this package using other tools, such as `tar` or `unzip`. Ghruul will detect the 
non-supported format, inform you about the availability of a new version, and run the custom script.

An example of a custom script applied to the releases of the repository [yt-dlp](https://github.com/yt-dlp/yt-dlp) 
(that does not publish `deb` or `rpm` formats) is available in the directory `custom_scripts`.

## Problems & troubleshooting

First of all, you can set the `-debug` switch as the **last** argument to the Ghruul script, if you encounter update problems 
(e.g., `./ghruul sample.csv -debug`). This will provide you with the original API response for the most common problems, 
for example, if the required data from the GitHub API response was empty and/or did not contain the proper release format.

In most cases, running the Ghruul update script a little while later fixes all problems, such as when the GitHub 
API returns something unexpected, e.g., a URL, instead of the proper version string (this has happened on very rare occasions, 
at least with non-authenticated API requests).

Additionally, if you update way too often and/or too many packages you 
might also hit the [API request rate limits](https://docs.github.com/de/rest/using-the-rest-api/rate-limits-for-the-rest-api).
In the former case you will have to wait until the cooldown time is over, in the latter case you might consider reducing 
the number of packages to update, for example by separating them in different CSVs.
