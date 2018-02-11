require "./data_extraction"

transactions = parse_input_file("input-data.txt")
$itemSet, $misHash = parse_parameter_file("parameter-file.txt")

def sort_items_with_mis(transactions)
  @item_list = $misHash.keys
  sorted_item_list = @item_list.sort {|a,b| $misHash[a] <=> $misHash[b]}
  return sorted_item_list
end

def init_pass(sorted_item_list, transactions)
  @support_count = Hash.new 0
  no_of_transactions = transactions.length

  for item_set in transactions
    item_set.each do |item|
      @support_count[item.to_i] += 1
    end
  end

  @init_pass_list = []

  for i in 0..sorted_item_list.length
    puts
    if (@support_count[sorted_item_list[i]].fdiv(no_of_transactions)) >= $misHash[sorted_item_list[i]]
      @init_pass_list.push(sorted_item_list[i])
      break
    end
  end

  for j in i+1..sorted_item_list.length

    if (@support_count[sorted_item_list[j]].fdiv(no_of_transactions)) >= $misHash[sorted_item_list[i]]
      @init_pass_list.push(sorted_item_list[j])
    end
  end

  return @init_pass_list
end

def freq_one_item_sets(transactions)
  no_of_transactions = transactions.length
  freq_one_item = []
  for l in @init_pass_list
    if (@support_count[l].fdiv(no_of_transactions)) >= $misHash[l]
      freq_one_item.push(l)
    end
  end
  if( (freq_one_item & $must_have).length >= 1)
    return freq_one_item
  end

  return []
end


sorted_mis_list = sort_items_with_mis(transactions)
init_pass(sorted_mis_list, transactions)
freq_one_item_sets(transactions)
