def element_is_in_set? item, set
  set.each do |element|
    return true if element == item
  end

  return false
end

def retryable tries = 100, wait = 0.1
  tries.times do
    return true if yield == true

    sleep wait
  end

  yield.should == true
end