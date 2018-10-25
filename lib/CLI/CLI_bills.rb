require_relative '../../config/environment.rb'

def cli_bills(choices)
    # pick a bill
    pick = $prompt.select("", choices, filter: true, per_page: 10)
    if pick == "Start over"
        cli_legislators_or_bills_or_mostest
    end

    bill_choices = {
        "Who were primary sponsors of #{pick.lege_id}?" => 1,
        "Who consponsored #{pick.lege_id}?" => 2,
        "What were the subjects of #{pick.lege_id}?" => 3,
        "Start over" => 4
    }
    selection = $prompt.select("What would you like to know about #{pick.lege_id}?", bill_choices)

    case selection
    # * bill's sponsors
    when 1
        choices = choice_list_legislators(pick.primary_sponsors)
        puts "Which sponsor of #{pick.lege_id} would you like to know more about?"
        cli_legislators(choices)
    when 2
        if pick.cosponsors.length == 0
            puts "There are no cosponsors for #{pick.lege_id}"
            choices = choice_list_legislators(pick.primary_sponsors)
            puts "Which sponsor of #{pick.lege_id} would you like to know more about?"
            cli_legislators(choices)    
        end

        choices = choice_list_legislators(pick.cosponsors)
        puts "Which cosponsor of #{pick.lege_id} would you like to know more about?"
        cli_legislators(choices)

    # * a bill's subjects
    when 3
        choices = choice_list_subjects(pick.subjects)
        puts "What subjects of #{pick.lege_id} would you like to know more about?"
        cli_subjects(choices)

    when 4
        cli_legislators_or_bills_or_mostest
    end
end
