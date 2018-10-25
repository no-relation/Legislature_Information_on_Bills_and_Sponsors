require_relative '../../config/environment.rb'

$prompt = TTY::Prompt.new

def cli_subjects(choices)
    # Implement later if needed
    # pick = $prompt.select("", choices, filter: true, per_page: 10)
    # if pick == "Start over"
    #     cli_legislators_or_bills_or_mostest
    # end

    # subj_choices = {
    #     "What bills include #{pick}?" => 1,
    # }
    # end

    pick = $prompt.select("", choices, filter: true, per_page: 10)
    bills_by_subject = Bill.all.select do |bill|
        binding.pry
        bill.subjects.include?(pick)
    end

    puts "#{pick} appears in #{bills_by_subject.length} bills"
    reply = $prompt.no?("Would you like to see them?")
    if !reply
        cli_bills(choice_list_bills(bills_by_subject))
    else
        cli_legislators_or_bills_or_mostest
    end
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

def choice_list_subjects(array_of_subjects)
    choices = {}
    array_of_subjects.each do |subject|
        choices["Start over"] = "Start over"
        choices[subject] = subject
    end
end

def array_to_english(array)
    if array.length == 1
        return array[0]
    else
        first_part = array[0...-1].join(", ")
        first_part + " and #{array[-1]}"
    end
end
