#Texas Bill Sponsorships

openstates.org API, building database including legislators, bills, and votes (joining class)

Possible queries: what bills did this legislator vote for, who voted for this bill, what bills had 

Todo:
* ~~seed database with API data~~
* build CLI interface
    * ~~User is prompted for what they want:~~
        * ~~"Bill with the most/least..."~~
        * ~~"Legislator with the most/least..."~~
        * breakdown of:
            * ~~legislator's bills~~
            * ~~whether they're the primary or cosponsor~~
            * the subjects of those bills
        * breakdown of;
            * bill's sponsors
            * most partisan or bipartisan
            * a bill's subjects
            * bill with the most subjects
            * bills by subject
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
        * .most_bipartisan (array of equal dem/rep sponsors)
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
* giffy gif https://flatiron-school.slack.com/files/UD5EL5LAF/FDK3DFTG9/image.png
