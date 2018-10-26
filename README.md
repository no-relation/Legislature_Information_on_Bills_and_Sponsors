# Texas
# **L**egislature 
# **I**nformation on 
# **B**ills and 
# **S**ponsors

Texas Legislature Information on Bills and Sponsors, or Texas LIBS, is a CLI application to access information about the 85th Texas Legislative special session. You can access bills by title, number or subject, or legislator who is primary- or co-sponsor.

To install, just download the repo into the folder of your choice and in the command line enter ```ruby bin/run.rb```.

From the first page, you can use arrow keys to choose options: bills, legislators, or various superlatives (which bills have the most sponsors? Which bills have the least? Which legislators have the most or least sponsorships? And so on.)

<img src="https://github.com/no-relation/Legislature_Information_on_Bills_and_Sponsors/blob/master/Screenshots/Welcome.png?raw=true" alt="intro menu" width="500" height="200">


When presented with a list of bills or legislators, you can start typing to filter the search down if you're looking for something specific, for example to see if a particular word appears in a bill title or if you only remember your state rep as "Joan Somebody."

Once you choose a legislator, you will see various options like "What bills did he sponsor? What are the subjects of the bills he sponsored?", and similarly you will get options for bills like "Who were primary sponsors? What were the subjects?".

To quit, navigate to the "Start over" option, and choose "nevermind I'm done".

Our data is from an openstates.org API.

<img src="https://github.com/no-relation/Legislature_Information_on_Bills_and_Sponsors/blob/master/Screenshots/more%20about%20bills.png?raw=true" alt="more about bills" width="500" height="300">

<img src="https://github.com/no-relation/Legislature_Information_on_Bills_and_Sponsors/blob/master/Screenshots/bills%20options.png?raw=true" alt="bill options" width="500" height="150">

<img src="https://github.com/no-relation/Legislature_Information_on_Bills_and_Sponsors/blob/master/Screenshots/more%20about%20legislators.png?raw=true" alt="more about legislators" width="500" height="200">

<img src="https://github.com/no-relation/Legislature_Information_on_Bills_and_Sponsors/blob/master/Screenshots/legislators%20options.png?raw=true" alt="legislator options" width="500" height="150">

<img src="https://github.com/no-relation/Legislature_Information_on_Bills_and_Sponsors/blob/master/Screenshots/rabbithole.png?raw=true" alt="more options" width="500" height="300">


---

openstates.org API, building database including legislators, bills, and votes (joining class)

Possible queries: what bills did this legislator vote for, who voted for this bill, what bills had 

Todo:
* write final README
* record demo video
* ~~seed database with API data~~
* build CLI interface
    * ~~User is prompted for what they want:~~
        * ~~"Bill with the most/least..."~~
        * ~~"Legislator with the most/least..."~~
        * breakdown of:
            * ~~legislator's bills~~
            * ~~whether they're the primary or cosponsor~~
            * ~~the subjects of those bills~~
        * breakdown of;
            * ~~bill's sponsors~~
            * ~~most partisan or bipartisan~~
            * ~~a bill's subjects~~
            * bill with the most subjects
            * ~~bills by subject~~
            * subject that appears in the most bills

* Hannah & Eddie : building out model methods
    * Legislator (Eddie)
        * ~~#bills~~
        * ~~#bills_primary (legislators who were primary sponsor)~~
        * ~~#bills_cosponsor~~
        * ~~.most_active~~
        * ~~.least_active~~
        * ~~.dems~~
        * ~~.reps~~
        * ~~#bill_subjects~~
        
    * Bill (Hannah)
        * ~~#sponsors~~
        * ~~#sponsors_primary~~
        * #sponsors_co (nah, forget it)
        * ~~.most_bipartisan (array of equal dem/rep sponsors)~~
        * ~~.most_dem (array of most dem)~~
        * ~~.most_rep (array of most rep)~~



* ~~Eddie: building out seeds file for importing data~~


Links:
* http://docs.openstates.org/en/latest/api/index.html
* METHOD = `metadata/tx?apikey=`, `?state=tx&apikey=` `bills`, 
* https://openstates.org/api/v1/METHOD/?apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5
* bills API: https://openstates.org/api/v1/bills/?state=tx&search_window=session&type=bill&apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5
* bill detail API: https://openstates.org/api/v1/bills/<BILL_ID>/?apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5
* legislators API: https://openstates.org/api/v1/legislators/?state=tx&apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5
* https://learn.co/tracks/web-development-immersive-2-0-module-one/project-mode/projects/module-one-final-project-guidelines
* [TTY:Prompt README](https://github.com/piotrmurach/tty-prompt#ttyprompt-)
* giffy gif https://flatiron-school.slack.com/files/UD5EL5LAF/FDK3DFTG9/image.png
