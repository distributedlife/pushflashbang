def element_is_in_set? item, set
  set.each do |element|
    return true if element == item
  end

  return false
end