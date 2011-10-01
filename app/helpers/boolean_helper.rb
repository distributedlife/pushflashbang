module BooleanHelper
  def to_boolean value
    return [true, "true", 1, "1", "T", "t", "y"].include?(value.class == String ? value.downcase : value)
  end
end