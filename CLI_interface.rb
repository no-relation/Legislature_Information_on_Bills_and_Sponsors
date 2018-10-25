require_relative 'config/environment.rb'

$prompt = TTY::Prompt.new

# * User is prompted for what they want:
def welcome_explainer
    name = " Legislature Information on Bills and Sponsors "
    print ColorizedString["_/\\_"].white.on_blue 
    puts ColorizedString[name.center(name.length)].black.on_white
    print ColorizedString["\\/\\/"].white.on_blue 
    puts ColorizedString["(from Open States API v1)".center(name.length)].white.on_red
end

def user_prompt
    puts "What would you like to know?"
end

def name_and_party(legislator)
    party = nil
    if legislator.party == "Democratic"
        party = "(D)"
    elsif legislator.party == "Republican"
        party = "(R)"
    end
    "#{legislator.full_name} #{party}"
end


def choice_list_legislators(array_of_lege_objects)
    choices = {}
    array_of_lege_objects.each do |lege|
        if lege.chamber == "upper"       
            senate_or_house = "Senate"
        elsif lege.chamber == "lower"
            senate_or_house = "House"
        end
        # add 'legislator name' => 'legislator id' keyvalue pair to choices
        choices["Start over"] = "Start over"
        choices["#{name_and_party(lege)}, #{senate_or_house} Dist. #{lege.district}"] = lege
    end
    choices
end

def title_truncate_and_ID(bill)
    title_array = bill.title.split
    if title_array.length < 15
        truncated_title = title_array.join(" ")
    else
        truncated_title = "#{title_array[0..15].join(" ")}..."
    end
    "#{bill.lege_id}: #{truncated_title}"
end

def choice_list_bills(array_of_bill_objects)
    choices = {}
    array_of_bill_objects.each do |bill|
        # 'bill lege id':'bill title (truncated)' => 'bill index id' to choices
        # e.g. 'HB 21: Relating to public school...' => 1
        choices["Start over"] = "Start over"
        choices[title_truncate_and_ID(bill)] = bill
    end
    choices
end

def array_to_english(array)
    if array.length == 1
        return array[0]
    else
        first_part = array[0...-1].join(", ")
        first_part + " and #{array[-1]}"
    end
end

#         * "Bill with the most/least..."
#         * "Legislator with the most/least..."
def cli_legislators_or_bills_or_mostest
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

# * breakdown of;
# * most partisan or bipartisan
# * bill with the most subjects
# * bills by subject
# * subject that appears in the most bills
def cli_bills(choices)
    # pick a bill
    pick = $prompt.select("", choices, filter: true)
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
        choices = choice_list_legislators(pick.cosponsors)
        puts "Which cosponsor of #{pick.lege_id} would you like to know more about?"
        cli_legislators(choices)

    # * a bill's subjects
    when 3

    when 4
        cli_legislators_or_bills_or_mostest
    end
end

def cli_legislators(choices)
    # pick a legislator
    pick = $prompt.select("", choices, filter: true)
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
        choices = choice_list_bills(pick.bills_primary)
        puts "Which bill of #{pick.full_name} would you like to know more about?"
        cli_bills(choices)
    when 2
        choices = choice_list_bills(pick.bills_cosponsor)
        puts "Which bill that #{pick.full_name} cosponsored woud you like to know more about?"
        cli_bills(choices)
    # * the subjects of those bills
    when 3

    when 4
        cli_legislators_or_bills_or_mostest
    end
end

def cli_legislators_bills

end

def cli_superlative_sponsorships
    choices = {
        "bill(s) with most sponsorships" => 1, 
        "legislator(s) with most sponsorships" => 2, 
        "bill(s) with least sponsorships" => 3, 
        "legislator(s) with least sponsorships" => 4,
        "something else, take me back" => 5
    }
    pick = $prompt.select("I would like to know about...", choices)
    
    case pick
    when 1 #bill with most
        puts "Fetching data..."
        result = Bill.most_sponsors
        result.each do |number, bills|
            puts "#{bills.length} bills had #{number} sponsors."
            puts "Would you like to see them? (y/n)"
            reply = gets.chomp
            if reply == 'y'
                puts "Those bills are:"
                bills.each {|bill| puts title_truncate_and_ID(bill)}
            end
            cli_superlative_sponsorships
        end
        
    when 2 #legislator(s) with most
        puts "Fetching data..."
        result = Legislator.most_active
        result.each do |number, members|
            member_names = members.map {|member| member.full_name}
            puts "#{array_to_english(member_names)} sponsored or cosponsored #{number} bills."
        end

    when 3 #bill with least
        puts "Fetching data..."
        result = Bill.least_sponsors
        result.each do |number, bills|
            puts "#{bills.length} bills had #{number} sponsors."
            puts "Would you like to see them? (y/n)"
            reply = gets.chomp
            if reply == 'y'
                puts "Those bills are:"
                bills.each {|bill| puts title_truncate_and_ID(bill)}
            end
        end

    when 4 #legislator with least
        puts "Fetching data..."
        result = Legislator.least_active
        result.each do |number, members|
            member_names = members.map {|member| member.full_name}
            puts "#{array_to_english(member_names)} sponsored or cosponsored #{number} bills."
        end

    when 5 #next menu
        cli_legislators_or_bills_or_mostest
    end

end

welcome_explainer
user_prompt
# binding.pry
cli_legislators_or_bills_or_mostest
0
