# -*- encoding : utf-8 -*-
module ArrayHelper
  def get_first array
    return array.first unless array.empty?

    nil
  end
end
