require_relative '../../config/environment.rb'

def cli_legislators(choices)
    # pick a legislator
    pick = $prompt.select("", choices, filter: true, per_page: 10)
    if pick == "Start over"
        cli_legislators_or_bills_or_mostest
    end

    lege_choices = {
        "What bills did #{pick.full_name} sponsor?" => 1,
        "What bills did #{pick.full_name} cosponsor?" => 2,
        "What are the subjects of the bills that #{pick.full_name} sponsored or cosponsored?" => 3,
        "Start over" => 4
    }
    selection = $prompt.select("What would you like to know about #{pick.full_name}?", lege_choices)

    case selection
    # * legislator's bills
    # * whether they're the primary or cosponsor
    when 1
        if pick.bills_primary.length == 0
            puts "#{pick.full_name} didn't sponsor any bills"
            cli_legislators_or_bills_or_mostest
        end

        choices = choice_list_bills(pick.bills_primary)
        puts "Which bill of #{pick.full_name} would you like to know more about?"
        cli_bills(choices)
    when 2
        choices = choice_list_bills(pick.bills_cosponsor)
        puts "Which bill that #{pick.full_name} cosponsored woud you like to know more about?"
        cli_bills(choices)
    # * the subjects of those bills
    when 3
        choices = choice_list_subjects(pick.subjects)
        puts "What subjects of #{pick.full_name} would you like to know more about?"
        cli_subjects(choices)

    when 4
        cli_legislators_or_bills_or_mostest
    end
end

