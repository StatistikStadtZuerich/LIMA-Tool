# lima-golem

Shiny app for [LIMA](https://www.stadt-zuerich.ch/prd/de/index/statistik/publikationen-angebote/datenbanken-anwendungen/liegenschaftenpreise.html) tool (Abfragetool Liegenschaftenmarkt).

The data from the LIMA (LIegenschaftenMArkt) tool on the Website of [Statistik Stadt Zürich](https://www.stadt-zuerich.ch/prd/de/index/statistik.html) are based on notification changes of ownership from the land registry offices. All sales of developed land in the territory of the city of Zurich are taken into account. The data is obtained from the Open Data portal of the city of Zurich and is available [here](https://data.stadt-zuerich.ch/dataset?tags=lima).

By using the this application you agree to the [disclaimer](https://www.stadt-zuerich.ch/prd/de/index/statistik/publikationen-angebote/datenbanken-anwendungen/liegenschaftenpreise/disclaimer.html). 

## Price series and grouping

Three different price series are available with the LIMA tool:

- Price per square meter of land area
- Price per square meter of land area minus insurance value (=approximate value for land price)

Three groups are displayed for each of the price series:

- Whole properties: sales of whole parcels (excluding co-ownership and condominium ownership)
- Condominium ownership
- All sales (whole properties, condominiums, co-ownership shares)

## Approximate value for land price

Since there is hardly any undeveloped land left in Zurich, the pure land price cannot be determined directly from the real estate transfer prices. For the sale of developed properties, the land price most closely corresponds to the sales price per square meter of land area minus the insurance value for entire properties (i.e. without including transactions in condominium and co-ownership).

The purpose of substracting the building insurance value from the purchase price is to determine the theoretical land value, as the residual of the total price minus the building value, effectively the market value of the land. However, it must be remembered that the insurance value does not correspond to the current structural value of the building, but to the cost of reconstruction (new value of an identical building and not the current value reduced by age depreciation).

Since the new value is higher than the current value and thus the deduction for the building value tends to be too high when calculating the residual value, the residual values shown are likely to tend to be lower than the effective land price. They are therefore only an approximation of the land price and should be interpreted with caution. Further information in the [disclaimer](https://www.stadt-zuerich.ch/prd/de/index/statistik/publikationen-angebote/datenbanken-anwendungen/liegenschaftenpreise/disclaimer.html).

## New building and zoning regulations (BZO) as of 2019

With the revision of the building and zoning regulations (BZO) in 2016, the BZO 1999 was replaced. In the change of ownership, the prices from 2019 refer to the BZO 2016. The prices up to 2018 refer to the BZO 1999.

While the various mixed zones (core zones, neighborhood preservation zones, center zones) in the BZO 2016 are still largely comparable with the BZO 1999, the designations of the residential zones changed fundamentally. In the revision, it was determined that an additional floor is permitted in the residential zones to compensate for the previously permitted basement. Thus, former W3 zones became new W4 zones, W4 became W5, and W5 became W6. This means that, for example, the W4 zone now includes areas that were designated W3 until 2018, but are comparable under building law. Or conversely, W3 before 2018 is not comparable to W3 after 2018, but to W4 after 2018. The presentation of the query results in query 1 of LIMA refers to this change.

## Zone types
For LIMA, only changes in ownership zones with possible residential use are taken into account. Sales in working zones (Arbeitszonen), free zones (Freihaltungszonen) and outside building zones are excluded.
- Z = Center zones
- K = Core zones
- Q = Neighborhood preservation zone
- W2 = Residential zone 2
- W3 = Residential zone 3
- W4 = Residential zone 4
- W5 = Residential zone 5
- W6 = Residential zone 6

## Building types
For the second app of LIMA, changes in ownership in residential and mixed zones ('Wohn- und Mischzone'), in the indistrial zones (Indistrie- und Gewerbezone) as well as other zones ('Übriges Gebiet') are considered.
- EFH = Einfamilienhäuser
- MFH = Mehrfamilienhäuser
- WGR = Wohnhäuser mit Geschäftsräumen
- UWH = Übrige Wohnhäuser
- NUB = Nutzbauten in Wohn- und Mischzonen
- UNB = Unbebaut in Wohn- und Mischzonen


## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://cmp-sdlc.stzh.ch/OE-7035/ssz-da/shinyapps/lima-golem.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://cmp-sdlc.stzh.ch/OE-7035/ssz-da/shinyapps/lima-golem/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Automatically merge when pipeline succeeds](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thank you to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README
Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
