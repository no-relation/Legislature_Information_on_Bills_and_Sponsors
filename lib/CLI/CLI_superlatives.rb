require_relative '../../config/environment.rb'

def bills_sponsor_count(results)
    results.each do |number, bills|
        if number == 1
            num_of_sponsors = "1 sponsor"
        else
            num_of_sponsors = "#{number} sponsors"
        end
        if bills.length == 1
            num_of_bills = "1 bill"
        else
            num_of_bills = "#{bills.length} bills"
        end

        puts "#{num_of_bills} had #{num_of_sponsors}."
        would_you_like_to_see(bills, :bill)
        # reply = $prompt.no?("Would you like to see them?")
        # if !reply
        #     cli_bills(choice_list_bills(bills))
        # else
        #     cli_superlative_sponsorships
        # end
    end
end

def legislators_bill_count(results)
    results.each do |number, members|
        if number == 1
            num_of_bills = "1 bill"
        else
            num_of_bills = "#{number} bills"
        end
        if members.length == 1
            num_of_sponsors = "1 legislator"
        else
            num_of_sponsors = "#{members.length} legislators"
        end
        puts "#{num_of_sponsors} have sponsored or cosponsored #{num_of_bills}."            
        would_you_like_to_see(members, :lege)
        
    end
end

def most_dem_or_repub(result, party)
    result_ratio = nil
    result_bills = nil
    result.each { |k,v| 
        result_ratio = k
        result_bills = v }

    party_count = 0
    total_count = 0
    result_ratio.each { |x,y| 
        party_count = x
        total_count = y }

    puts "#{result_bills.length} bills are the most #{party}, with #{party_count} sponsoring out of #{total_count} sponsors."
    would_you_like_to_see(result_bills, :bill)
end

def would_you_like_to_see(results, bill_or_lege)
    reply = $prompt.no?("Would you like to see them?")
    if !reply # why is this backwards?!
        if bill_or_lege == :lege
            cli_legislators(choice_list_legislators(results))
        elsif bill_or_lege == :bill
            cli_bills(choice_list_bills(results))
        end
    else 
        cli_superlative_sponsorships
    end
end 

def cli_superlative_sponsorships
    choices = {
        "bill(s) with most sponsorships" => 1, 
        "legislator(s) with most sponsorships" => 2, 
        "bill(s) with least sponsorships" => 3, 
        "legislator(s) with least sponsorships" => 4,
        "bill with the most Democratic sponsors" => 5,
        "bill with the most Republican sponsors" => 6,
        "most bipartisan bill(s)" => 7,
        # "bill with the most subjects" => 8,
        # "subject with the most bills" => 9
        "something else, take me back" => bye
    }
    pick = $prompt.select("I would like to know about the...", choices, per_page: 10)
    
    case pick
    when 1 #bill with most
        puts "Fetching data..."
        result = Bill.most_sponsors
        
        bills_sponsor_count(result)

    when 2 #legislator(s) with most
        puts "Fetching data..."
        result = Legislator.most_active
        legislators_bill_count(result)

    when 3 #bill with least
        puts "Fetching data..."
        result = Bill.least_sponsors
        bills_sponsor_count(result)

    when 4 #legislator with least
        puts "Fetching data..."
        result = Legislator.least_active
        legislators_bill_count(result)

    when 5 # most Dem
        puts "Fetching data..."
        result = Bill.most_relative_dem
        binding.pry
        most_dem_or_repub(result, "Democratic")

    when 6 # most Repub
        puts "Fetching data..."
        result = Bill.most_relative_repub
        most_dem_or_repub(result, "Republican")

    when 7 # most bipartisan
        puts "Fetching data..."
        result = Bill.bipartisan_is_50_50
        puts "#{result.length} bills have equal Democratic and Republican sponsors."
        would_you_like_to_see(result, :bill)
        
    when bye
        cli_legislators_or_bills_or_mostest
    end

end