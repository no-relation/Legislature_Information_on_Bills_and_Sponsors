require_relative 'config/environment.rb'

$prompt = TTY::Prompt.new

# * User is prompted for what they want:
def welcome_explainer
    print ColorizedString["Texas "].white.on_blue 
    puts ColorizedString["Legislature Bill Sponsor Explorer Revealer Explainer"].black.on_white
    print ColorizedString["(from "].white.on_blue 
    puts ColorizedString["Open States API v1)"].white.on_red
end

def user_prompt
    puts "What would you like to know?"
end

def name_and_party(legislator)
    party = nil
    if lege.party == "Democratic"
        party = "(D)"
    elsif lege.party == "Republican"
        party = "(R)"
    end
    "#{lege.full_name} #{party}"
end

def choice_list_legislators
    choices = {}
    Legislator.all_but_lt_gov.each do |lege|        
        # add 'legislator name' => 'legislator id' keyvalue pair to choices
        choices[name_and_party(lege)] = lege.id
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

def choice_list_bills
    choices = {}
    Bill.all.each do |bill|        
        # 'bill lege id':'bill title (truncated)' => 'bill index id' to choices
        # e.g. 'HB 21: Relating to public school...' => 1
        choices[title_truncate_and_ID(bill)] = bill.id
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
        cli_bills

    when 2
        cli_legislators

    when 3
        cli_superlative_sponsorships

    when 4 #exits program
        exit 
    end
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
cli_legislators_or_bills_or_mostest
# binding.pry
0
#         * breakdown of:
#             * legislator's bills
#             * whether they're the primary or cosponsor
#             * the subjects of those bills
#         * breakdown of;
#             * bill's sponsors
#             * most partisan or bipartisan
#             * a bill's subjects
#             * bill with the most subjects
#             * bills by subject
#             * subject that appears in the most bills