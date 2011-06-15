def add_cards_to_forward_deck deck, cards
  cards.each do |card|
    next if card["new"].nil?
    next if card["new"] == "no"

    exists = Card.where(:front => card["front"], :deck_id => deck.id)

    if card["new"] == "yes"
      unless exists.empty?
        raise "card #{card["front"]} already exists in deck #{deck["name"]}"
      end

      card = Card.new(:front => card["front"], :back => card["back"], :pronunciation => card["pronunciation"], :chapter => card["chapter"])
      card.deck = deck
      card.save!

      puts "#{card["front"]} created in deck #{deck["name"]}"
    elsif card["new"] == "update"
      if exists.empty?
        raise "trying to update card  #{card["front"]} that does not exist in deck #{deck["name"]}"
      end

      exists.first.back = card["back"]
      exists.first.pronunciation = card["pronunciation"]
      exists.first.chapter = card["chapter"]
      exists.first.save!

      puts "#{card["front"]} updated in deck #{deck["name"]}"
    end
  end
end

def add_cards_to_reverse_deck deck, cards
  cards.each do |card|
    next if card["new"].nil?
    next if card["new"] == "no"

    exists = Card.where(:front => card["back"], :deck_id => deck.id)

    if card["new"] == "yes"
      unless exists.empty?
        raise "card #{card["back"]} already exists in deck #{deck["name"]}"
      end

      card = Card.new(:front => card["back"], :back => card["front"], :pronunciation => card["pronunciation"], :chapter => card["chapter"])
      card.deck = deck
      card.save!

      puts "#{card["back"]} created in deck #{deck["name"]}"
    elsif card["new"] == "update"
      if exists.empty?
        raise "trying to update card  #{card["back"]} that does not exist in deck #{deck["name"]}"
      end

      exists.first.back = card["front"]
      exists.first.pronunciation = card["pronunciation"]
      exists.first.chapter = card["chapter"]
      exists.first.save!

      puts "#{card["back"]} updated in deck #{deck["name"]}"
    end
  end
end

unless CardTiming.count > 0
  CardTiming.create(:seconds => 5)                                       # 5 seconds
  CardTiming.create(:seconds => 25)                                      # 25 seconds
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_MINUTE * 2)        # 2 minutes
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_MINUTE * 10)       # 10 minutes
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_HOUR)              # 1 hour
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_HOUR * 5)          # 5 hours
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_DAY)               # 1 day
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_DAY * 5)           # 5 days
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_DAY * 25)          # 25 days
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_MONTH * 4)         # 4 months
  CardTiming.create(:seconds => CardTiming::SECONDS_IN_YEAR * 2)          # 2 years
end


user = User.where(:email => 'ryan.boucher@distributedlife.com')
if user.empty?
  user = User.create(:email => 'ryan.boucher@distributedlife.com', :password => 'FSG2342edkj!', :confrim_password => 'FSG2342edkj!')
else
  user = user.first
end

def get_or_create_deck name, user_id, shared, supports_written_answer, pronunciation_side
  deck = Deck.where(:name => name, :user_id => user_id)

  if deck.empty?
    deck = Deck.new(:name => name, :shared => shared, :supports_written_answer => supports_written_answer, :pronunciation_side => pronunciation_side)
    deck.user = user
    deck.save!

    puts "created deck #{name}"
  else
    deck = deck.first

    puts "found deck #{name}"
  end

  deck
end

  #Lesson 6
#  {"back" => "second", "front" => "乙", "chapter" => "6", "new" => "new"},
#  {"back" => "fly", "front" => "飞", "chapter" => "6", "new" => "new"},
#  {"back" => "child", "front" => "子", "chapter" => "6", "new" => "new"},
#  {"back" => "cavity", "front" => "孔", "chapter" => "6", "new" => "new"},
#  {"back" => "roar", "front" => "吼", "chapter" => "6", "new" => "new"},
#  {"back" => "chaos", "front" => "乱", "chapter" => "6", "new" => "new"},
#  {"back" => "(-ed)", "front" => "了", "chapter" => "6", "new" => "new"},
#  {"back" => "female", "front" => "女", "chapter" => "6", "new" => "new"},
#  {"back" => "good", "front" => "好", "chapter" => "6", "new" => "new"},
#  {"back" => "be like", "front" => "如", "chapter" => "6", "new" => "new"},
#  {"back" => "mother", "front" => "母", "chapter" => "6", "new" => "new"},
#  {"back" => "pierce", "front" => "贯", "chapter" => "6", "new" => "new"},
#  {"back" => "elder brother", "front" => "兄", "chapter" => "6", "new" => "new"},
#  {"back" => "overcome", "front" => "克", "chapter" => "6", "new" => "new"},
  #Lesson 7
#  {"back" => "small", "front" => "小", "chapter" => "7", "new" => "new"},
#  {"back" => "few", "front" => "少", "chapter" => "7", "new" => "new"},
#  {"back" => "noisy", "front" => "吵", "chapter" => "7", "new" => "new"},
#  {"back" => "grandchild", "front" => "孙", "chapter" => "7", "new" => "new"},
#  {"back" => "large", "front" => "大", "chapter" => "7", "new" => "new"},
#  {"back" => "tip", "front" => "尖", "chapter" => "7", "new" => "new"},
#  {"back" => "evening", "front" => "夕", "chapter" => "7", "new" => "new"},
#  {"back" => "many", "front" => "多", "chapter" => "7", "new" => "new"},
#  {"back" => "enough", "front" => "够", "chapter" => "7", "new" => "new"},
#  {"back" => "outside", "front" => "外", "chapter" => "7", "new" => "new"},
#  {"back" => "name", "front" => "名", "chapter" => "7", "new" => "new"},
#  {"back" => "silk gauze", "front" => "罗", "chapter" => "7", "new" => "new"},
#  {"back" => "factory", "front" => "厂", "chapter" => "7", "new" => "new"},
#  {"back" => "hall", "front" => "厅", "chapter" => "7", "new" => "new"},
#  {"back" => "stern", "front" => "历", "chapter" => "7", "new" => "new"},
#  {"back" => "thick", "front" => "厚", "chapter" => "7", "new" => "new"},
#  {"back" => "stone", "front" => "石", "chapter" => "7", "new" => "new"},
#  {"back" => "gravel", "front" => "砂", "chapter" => "7", "new" => "new"},
#  {"back" => "wonderful", "front" => "秒", "chapter" => "7", "new" => "new"},
#  {"back" => "resemble", "front" => "肖", "chapter" => "7", "new" => "new"},
#  {"back" => "peel", "front" => "削", "chapter" => "7", "new" => "new"},
#  {"back" => "ray", "front" => "光", "chapter" => "7", "new" => "new"},
#  {"back" => "overly", "front" => "太", "chapter" => "7", "new" => "new"},
#  {"back" => "economise", "front" => "省", "chapter" => "7", "new" => "new"},
#  {"back" => "strange", "front" => "奇", "chapter" => "7", "new" => "new"},
  #Lesson 8
#  {"back" => "stream", "front" => "川", "chapter" => "8", "new" => "new"},
#  {"back" => "state", "front" => "州", "chapter" => "8", "new" => "new"},
#  {"back" => "obey", "front" => "顺", "chapter" => "8", "new" => "new"},
#  {"back" => "water", "front" => "水", "chapter" => "8", "new" => "new"},
#  {"back" => "eternity", "front" => "永", "chapter" => "8", "new" => "new"},
#  {"back" => "blood vessels", "front" => "脉", "chapter" => "8", "new" => "new"},
#  {"back" => "request", "front" => "求", "chapter" => "8", "new" => "new"},
#  {"back" => "spring", "front" => "泉", "chapter" => "8", "new" => "new"},
#  {"back" => "flatlands", "front" => "原", "chapter" => "8", "new" => "new"},
#  {"back" => "swim", "front" => "泳", "chapter" => "8", "new" => "new"},
#  {"back" => "continent", "front" => "洲", "chapter" => "8", "new" => "new"},
#  {"back" => "marsh", "front" => "沼", "chapter" => "8", "new" => "new"},
#  {"back" => "sand", "front" => "沙", "chapter" => "8", "new" => "new"},
#  {"back" => "Yangtze", "front" => "江", "chapter" => "8", "new" => "new"},
#  {"back" => "juice", "front" => "汁", "chapter" => "8", "new" => "new"},
#  {"back" => "tide", "front" => "潮", "chapter" => "8", "new" => "new"},
#  {"back" => "source", "front" => "源", "chapter" => "8", "new" => "new"},
#  {"back" => "extinguish", "front" => "消", "chapter" => "8", "new" => "new"},
#  {"back" => "river", "front" => "河", "chapter" => "8", "new" => "new"},
#  {"back" => "fish", "front" => "鱼", "chapter" => "8", "new" => "new"},
#  {"back" => "fishing", "front" => "渔", "chapter" => "8", "new" => "new"},
#  {"back" => "lake", "front" => "湖", "chapter" => "8", "new" => "new"},
#  {"back" => "fathom", "front" => "测", "chapter" => "8", "new" => "new"},
#  {"back" => "soil", "front" => "土", "chapter" => "8", "new" => "new"},
#  {"back" => "equal", "front" => "均", "chapter" => "8", "new" => "new"},
#  {"back" => "belly", "front" => "肚", "chapter" => "8", "new" => "new"},
#  {"back" => "dust", "front" => "尘", "chapter" => "8", "new" => "new"},
#  {"back" => "fill in", "front" => "填", "chapter" => "8", "new" => "new"},
#  {"back" => "spit", "front" => "吐", "chapter" => "8", "new" => "new"},
#  {"back" => "pressure", "front" => "压", "chapter" => "8", "new" => "new"},
#  {"back" => "waaah!", "front" => "哇", "chapter" => "8", "new" => "new"},
#  {"back" => "Chinese inch", "front" => "寸", "chapter" => "8", "new" => "new"},
#  {"back" => "seal", "front" => "封", "chapter" => "8", "new" => "new"},
#  {"back" => "time", "front" => "时", "chapter" => "8", "new" => "new"},
#  {"back" => "Buddhist temple", "front" => "寺", "chapter" => "8", "new" => "new"},
#  {"back" => "fire", "front" => "火", "chapter" => "8", "new" => "new"},
#  {"back" => "destroy", "front" => "灭", "chapter" => "8", "new" => "new"},
#  {"back" => "ashes", "front" => "灰", "chapter" => "8", "new" => "new"},
#  {"back" => "vexed", "front" => "烦", "chapter" => "8", "new" => "new"},
#  {"back" => "inflammation", "front" => "炎", "chapter" => "8", "new" => "new"},
#  {"back" => "thin", "front" => "淡", "chapter" => "8", "new" => "new"},
#  {"back" => "lamp", "front" => "灯", "chapter" => "8", "new" => "new"},
#  {"back" => "spot", "front" => "点", "chapter" => "8", "new" => "new"},
#  {"back" => "illuminate", "front" => "照", "chapter" => "8", "new" => "new"},
  #Lesson 9
#  {"back" => "li (about 500m)", "front" => "里", "chapter" => "9", "new" => "new"},
#  {"back" => "quantity", "front" => "量", "chapter" => "9", "new" => "new"},
#  {"back" => "bury", "front" => "埋", "chapter" => "9", "new" => "new"},
#  {"back" => "black", "front" => "黑", "chapter" => "9", "new" => "new"},
#  {"back" => "black ink", "front" => "墨", "chapter" => "9", "new" => "new"},
#  {"back" => "risk", "front" => "冒", "chapter" => "9", "new" => "new"},
#  {"back" => "same", "front" => "同", "chapter" => "9", "new" => "new"},
#  {"back" => "cave", "front" => "洞", "chapter" => "9", "new" => "new"},
#  {"back" => "lovely", "front" => "丽", "chapter" => "9", "new" => "new"},
#  {"back" => "orientation", "front" => "向", "chapter" => "9", "new" => "new"},
#  {"back" => "echo", "front" => "响", "chapter" => "9", "new" => "new"},
#  {"back" => "esteem", "front" => "尚", "chapter" => "9", "new" => "new"},
#  {"back" => "character", "front" => "字", "chapter" => "9", "new" => "new"},
#  {"back" => "guard", "front" => "守", "chapter" => "9", "new" => "new"},
#  {"back" => "finish", "front" => "完", "chapter" => "9", "new" => "new"},
#  {"back" => "disaster", "front" => "灾", "chapter" => "9", "new" => "new"},
#  {"back" => "proclaim", "front" => "宣", "chapter" => "9", "new" => "new"},
#  {"back" => "nighttime", "front" => "宵", "chapter" => "9", "new" => "new"},
#  {"back" => "peaceful", "front" => "安", "chapter" => "9", "new" => "new"},
#  {"back" => "banquet", "front" => "宴", "chapter" => "9", "new" => "new"},
#  {"back" => "mail", "front" => "寄", "chapter" => "9", "new" => "new"},
#  {"back" => "wealthy", "front" => "富", "chapter" => "9", "new" => "new"},
#  {"back" => "store up", "front" => "贮", "chapter" => "9", "new" => "new"},
  #Lesson 10
#  {"back" => "tree", "front" => "木", "chapter" => "10", "new" => "new"},
#  {"back" => "woods", "front" => "林", "chapter" => "10", "new" => "new"},
#  {"back" => "forest", "front" => "森", "chapter" => "10", "new" => "new"},
#  {"back" => "dreams", "front" => "梦", "chapter" => "10", "new" => "new"},
#  {"back" => "machine", "front" => "机", "chapter" => "10", "new" => "new"},
#  {"back" => "plant", "front" => "值", "chapter" => "10", "new" => "new"},
#  {"back" => "apricot", "front" => "杏", "chapter" => "10", "new" => "new"},
#  {"back" => "dim-witted", "front" => "呆", "chapter" => "10", "new" => "new"},
#  {"back" => "withered", "front" => "枯", "chapter" => "10", "new" => "new"},
#  {"back" => "village", "front" => "忖", "chapter" => "10", "new" => "new"},
#  {"back" => "one another", "front" => "相", "chapter" => "10", "new" => "new"},
#  {"back" => "notebook", "front" => "本", "chapter" => "10", "new" => "new"},
#  {"back" => "case", "front" => "案", "chapter" => "10", "new" => "new"},
#  {"back" => "not yet", "front" => "未", "chapter" => "10", "new" => "new"},
#  {"back" => "last", "front" => "末", "chapter" => "10", "new" => "new"},
#  {"back" => "foam", "front" => "沫", "chapter" => "10", "new" => "new"},
#  {"back" => "flavour", "front" => "味", "chapter" => "10", "new" => "new"},
#  {"back" => "younger sister", "front" => "妹", "chapter" => "10", "new" => "new"},
#  {"back" => "investigate", "front" => "查", "chapter" => "10", "new" => "new"},
#  {"back" => "sediment", "front" => "渣", "chapter" => "10", "new" => "new"},
#  {"back" => "dye", "front" => "染", "chapter" => "10", "new" => "new"},
#  {"back" => "plum", "front" => "李", "chapter" => "10", "new" => "new"},
#  {"back" => "table", "front" => "桌", "chapter" => "10", "new" => "new"},
#  {"back" => "miscellaneous", "front" => "杂", "chapter" => "10", "new" => "new"},
#  {"back" => "as if", "front" => "若", "chapter" => "10", "new" => "new"},
#  {"back" => "grass", "front" => "草", "chapter" => "10", "new" => "new"},
#  {"back" => "technique", "front" => "艺", "chapter" => "10", "new" => "new"},
#  {"back" => "suffering", "front" => "苦", "chapter" => "10", "new" => "new"},
#  {"back" => "wide", "front" => "宽", "chapter" => "10", "new" => "new"},
#  {"back" => "nobody", "front" => "莫", "chapter" => "10", "new" => "new"},
#  {"back" => "imitate", "front" => "摸", "chapter" => "10", "new" => "new"},
#  {"back" => "desert", "front" => "漠", "chapter" => "10", "new" => "new"},
#  {"back" => "grave", "front" => "幕", "chapter" => "10", "new" => "new"},
#  {"back" => "seedling", "front" => "苗", "chapter" => "10", "new" => "new"},
#  {"back" => "aim", "front" => "瞄", "chapter" => "10", "new" => "new"},
  #Lesson 11
#  {"back" => "portent", "front" => "兆", "chapter" => "11", "new" => "new"},
#  {"back" => "peach", "front" => "桃", "chapter" => "11", "new" => "new"},
#  {"back" => "pooch", "front" => "犬", "chapter" => "11", "new" => "new"},
#  {"back" => "remarkable", "front" => "尤", "chapter" => "11", "new" => "new"},
#  {"back" => "detest", "front" => "厌", "chapter" => "11", "new" => "new"},
#  {"back" => "state of affairs", "front" => "状", "chapter" => "11", "new" => "new"},
#  {"back" => "put on makeup", "front" => "妆", "chapter" => "11", "new" => "new"},
#  {"back" => "general (military rank)", "front" => "将", "chapter" => "11", "new" => "new"},
#  {"back" => "seize", "front" => "获", "chapter" => "11", "new" => "new"},
#  {"back" => "silent", "front" => "默", "chapter" => "11", "new" => "new"},
#  {"back" => "sort of thing", "front" => "然", "chapter" => "11", "new" => "new"},
#  {"back" => "cry", "front" => "哭", "chapter" => "11", "new" => "new"},
#  {"back" => "utensil", "front" => "器", "chapter" => "11", "new" => "new"},
#  {"back" => "stinking (with drop）臭", "chapter" => "11", "new" => "new"},
#  {"back" => "dog", "front" => "狗", "chapter" => "11", "new" => "new"},
#  {"back" => "cow", "front" => "牛", "chapter" => "11", "new" => "new"},
#  {"back" => "special", "front" => "特", "chapter" => "11", "new" => "new"},
#  {"back" => "declare", "front" => "告", "chapter" => "11", "new" => "new"},
#  {"back" => "vast", "front" => "浩", "chapter" => "11", "new" => "new"},
#  {"back" => "before", "front" => "先", "chapter" => "11", "new" => "new"},
#  {"back" => "wash", "front" => "洗", "chapter" => "11", "new" => "new"},
  #Lesson 12
#  {"back" => "individual", "front" => "个", "chapter" => "12", "new" => "new"},
#  {"back" => "introduce", "front" => "介", "chapter" => "12", "new" => "new"},
#  {"back" => "world", "front" => "界", "chapter" => "12", "new" => "new"},
#  {"back" => "tea", "front" => "茶", "chapter" => "12", "new" => "new"},
#  {"back" => "fit", "front" => "合", "chapter" => "12", "new" => "new"},
#  {"back" => "ha!", "front" => "哈", "chapter" => "12", "new" => "new"},
#  {"back" => "pagoda", "front" => "塔", "chapter" => "12", "new" => "new"},
#  {"back" => "king", "front" => "王", "chapter" => "12", "new" => "new"},
#  {"back" => "jade", "front" => "玉", "chapter" => "12", "new" => "new"},
#  {"back" => "treasure", "front" => "宝", "chapter" => "12", "new" => "new"},
#  {"back" => "ball", "front" => "球", "chapter" => "12", "new" => "new"},
#  {"back" => "present", "front" => "现", "chapter" => "12", "new" => "new"},
#  {"back" => "play", "front" => "玩", "chapter" => "12", "new" => "new"},
#  {"back" => "crazy", "front" => "狂", "chapter" => "12", "new" => "new"},
#  {"back" => "emperor", "front" => "皇", "chapter" => "12", "new" => "new"},
#  {"back" => "resplendent", "front" => "煌", "chapter" => "12", "new" => "new"},
#  {"back" => "submit", "front" => "呈", "chapter" => "12", "new" => "new"},
#  {"back" => "whole", "front" => "全", "chapter" => "12", "new" => "new"},
#  {"back" => "logic", "front" => "理", "chapter" => "12", "new" => "new"},
#  {"back" => "lord", "front" => "主", "chapter" => "12", "new" => "new"},
#  {"back" => "pour", "front" => "住", "chapter" => "12", "new" => "new"},
#  {"back" => "gold", "front" => "金", "chapter" => "12", "new" => "new"},
#  {"back" => "bell", "front" => "钟", "chapter" => "12", "new" => "new"},
#  {"back" => "copper", "front" => "铜", "chapter" => "12", "new" => "new"},
#  {"back" => "go fishing", "front" => "钓", "chapter" => "12", "new" => "new"},
#  {"back" => "needle", "front" => "针", "chapter" => "12", "new" => "new"},
#  {"back" => "nail", "front" => "钉", "chapter" => "12", "new" => "new"},
#  {"back" => "inscription", "front" => "铭", "chapter" => "12", "new" => "new"},
#  {"back" => "at ease", "front" => "镇", "chapter" => "12", "new" => "new"},
  #Lesson 13
#  {"back" => "way", "front" => "道", "chapter" => "13", "new" => "new"},
#  {"back" => "reach", "front" => "达", "chapter" => "13", "new" => "new"},
#  {"back" => "distant", "front" => "远", "chapter" => "13", "new" => "new"},
#  {"back" => "suitable (less one drop) 适", "chapter" => "13", "new" => "new"},
#  {"back" => "cross", "front" => "过", "chapter" => "13", "new" => "new"},
#  {"back" => "stride", "front" => "迈", "chapter" => "13", "new" => "new"},
#  {"back" => "speedy", "front" => "讯", "chapter" => "13", "new" => "new"},
#  {"back" => "create", "front" => "造", "chapter" => "13", "new" => "new"},
#  {"back" => "escape", "front" => "逃", "chapter" => "13", "new" => "new"},
#  {"back" => "patrol", "front" => "巡", "chapter" => "13", "new" => "new"},
#  {"back" => "choose", "front" => "选", "chapter" => "13", "new" => "new"},
#  {"back" => "modest", "front" => "逊", "chapter" => "13", "new" => "new"},
#  {"back" => "stroll", "front" => "逛", "chapter" => "13", "new" => "new"},
#  {"back" => "car", "front" => "车", "chapter" => "13", "new" => "new"},
#  {"back" => "one after another", "front" => "连", "chapter" => "13", "new" => "new"},
#  {"back" => "lotus", "front" => "莲", "chapter" => "13", "new" => "new"},
#  {"back" => "in front", "front" => "前", "chapter" => "13", "new" => "new"},
#  {"back" => "shears", "front" => "剪", "chapter" => "13", "new" => "new"},
#  {"back" => "transport", "front" => "输", "chapter" => "13", "new" => "new"},
#  {"back" => "exceed", "front" => "谕", "chapter" => "13", "new" => "new"},
#  {"back" => "strip", "front" => "条", "chapter" => "13", "new" => "new"},
#  {"back" => "location", "front" => "处", "chapter" => "13", "new" => "new"},
#  {"back" => "each", "front" => "各", "chapter" => "13", "new" => "new"},
#  {"back" => "pattern", "front" => "格", "chapter" => "13", "new" => "new"},
#  {"back" => "abbreviation", "front" => "略", "chapter" => "13", "new" => "new"},
#  {"back" => "guest", "front" => "客", "chapter" => "13", "new" => "new"},
#  {"back" => "forehead", "front" => "额", "chapter" => "13", "new" => "new"},
#  {"back" => "summer", "front" => "夏", "chapter" => "13", "new" => "new"},
#  {"back" => "L.A.", "front" => "洛", "chapter" => "13", "new" => "new"},
#  {"back" => "fall", "front" => "落", "chapter" => "13", "new" => "new"},
#  {"back" => "prepare", "front" => "备", "chapter" => "13", "new" => "new"}
  
  
#āáǎàa
#ēéěèe
#īíǐìi
#ōóǒòo
#ūúǔùuǚ