require_relative '../../config/environment.rb'

def cli_legislators_or_bills_or_mostest
    puts "What would you like to know?"
    choices = {
        "more about bills" => 1,
        "more about legislators" => 2,
        "what are the highest and lowest of bill sponsorships?" => 3,
        "nevermind, I'm done" => 4
    }
    pick = $prompt.select("Tell me...", choices)

    case pick
    when 1
        puts "What bill do you want to know more about?(Start typing to filter choices)"
        cli_bills(choice_list_bills(Bill.all))

    when 2
        puts "What legislator do you want to know about? (Start typing to filter choices)"
        cli_legislators(choice_list_legislators(Legislator.all_but_lt_gov))

    when 3
        cli_superlative_sponsorships

    when 4 
        exit 
    end
end