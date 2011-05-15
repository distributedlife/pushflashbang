def add_cards_to_forward_deck deck, cards
  cards.each do |card|
    next if card["new"].nil?
    next if card["new"] == "no"

    exists = Card.where(:front => card["front"], :deck_id => deck.id)

    if card["new"] == "yes"
      card = Card.new(:front => card["front"], :back => card["back"], :pronunciation => card["pronunciation"], :chapter => card["chapter"])
      card.deck = forward_deck
      card.save!

      puts "#{card["front"]} created in deck #{deck["name"]}"
    else
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
      card = Card.new(:front => card["back"], :back => card["front"], :pronunciation => card["pronunciation"], :chapter => card["chapter"])
      card.deck = reverse_deck
      card.save!

      puts "#{card["front"]} created in deck #{deck["name"]}"
    else
      exists.first.back = card["front"]
      exists.first.pronunciation = card["pronunciation"]
      exists.first.chapter = card["chapter"]
      exists.first.save!

      puts "#{card["front"]} updated in deck #{deck["name"]}"
    end
  end
end

unless CardTiming.count > 0
  CardTiming.create(:seconds => 5)                                       # 5 seconds
  CardTiming.create(:seconds => 25)                                      # 25 seconds
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_MINUTE * 2)        # 2 minutes
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_MINUTE * 10)       # 10 minutes
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_HOUR)              # 1 hour
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_HOUR * 5)          # 5 hours
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_DAY)               # 1 day
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_DAY * 5)           # 5 days
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_DAY * 25)          # 25 days
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_MONTH * 4)         # 4 months
  CardTiming.create(:seconds => CardTiming.SECONDS_IN_YEAR * 2)          # 2 years
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

forward_deck = get_or_create_deck 'Simplified Hanzi to English (reading)', user.id, true, false, 'front'
reverse_deck = get_or_create_deck 'English to Simplified Hanzi (writing)', user.id, true, false, 'front'


cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1 / (floor, ceiling)", "chapter" => "1", "new" => "no"},
  {"front" => "二", "back" => "2", "chapter" => "1", "new" => "no"},
  {"front" => "三", "back" => "3", "chapter" => "1", "new" => "no"},
  {"front" => "四", "back" => "4", "chapter" => "1", "new" => "no"},
  {"front" => "五", "back" => "5", "chapter" => "1", "new" => "no"},
  {"front" => "六", "back" => "6", "chapter" => "1", "new" => "no"},
  {"front" => "七", "back" => "7 / (diced)", "chapter" => "1", "new" => "no"},
  {"front" => "八", "back" => "8", "chapter" => "1", "new" => "no"},
  {"front" => "九", "back" => "9 / (baseball)", "chapter" => "1", "new" => "no"},
  {"front" => "十", "back" => "10", "chapter" => "1", "new" => "no"},
  {"front" => "目", "back" => "eye", "chapter" => "1", "new" => "no"},
  {"front" => "月", "back" => "month / (moon, flesh, part of body)", "chapter" => "1", "new" => "no"},
  {"front" => "口", "back" => "mouth", "chapter" => "1", "new" => "no"},
  {"front" => "田", "back" => "rice field / (brains)", "chapter" => "1", "new" => "no"},
  {"front" => "日", "back" => "day / (sun, tonque wagging)", "chapter" => "1", "new" => "no"},
  #Lesson 2
  {"front" => "古", "back" => "ancient", "chapter" => "2", "new" => "no"},
  {"front" => "胡", "back" => "recklessly", "chapter" => "2", "new" => "no"},
  {"front" => "叶", "back" => "leaf", "chapter" => "2", "new" => "no"},
  {"front" => "吾", "back" => "I (literary)", "chapter" => "2", "new" => "no"},
  {"front" => "朋", "back" => "companion", "chapter" => "2", "new" => "no"},
  {"front" => "明", "back" => "bright", "chapter" => "2", "new" => "no"},
  {"front" => "唱", "back" => "sing", "chapter" => "2", "new" => "no"},
  {"front" => "晶", "back" => "sparkling", "chapter" => "2", "new" => "no"},
  {"front" => "品", "back" => "goods", "chapter" => "2", "new" => "no"},
  {"front" => "昌", "back" => "prosperous", "chapter" => "2", "new" => "no"},
  {"front" => "早", "back" => "early / (sunflower)", "chapter" => "2", "new" => "no"},
  {"front" => "旭", "back" => "rising sun", "chapter" => "2", "new" => "no"},
  {"front" => "世", "back" => "generation", "chapter" => "2", "new" => "no"},
  {"front" => "胃", "back" => "stomach", "chapter" => "2", "new" => "no"},
  {"front" => "旦", "back" => "daybreak", "chapter" => "2", "new" => "no"},
  {"front" => "凹", "back" => "concave", "chapter" => "2", "new" => "no"},
  {"front" => "凸", "back" => "convex", "chapter" => "2", "new" => "no"},
  #Lesson 3
  {"front" => "自", "back" => "oneself / (nose)", "chapter" => "3", "new" => "no"},
  {"front" => "白", "back" => "white", "chapter" => "3", "new" => "no"},
  {"front" => "百", "back" => "hundred", "chapter" => "3", "new" => "no"},
  {"front" => "皂", "back" => "soap", "chapter" => "3", "new" => "no"},
  {"front" => "旧", "back" => "old", "chapter" => "3", "new" => "no"},
  {"front" => "中", "back" => "middle [n/adj]", "chapter" => "3", "new" => "no"},
  {"front" => "千", "back" => "thousand", "chapter" => "3", "new" => "no"},
  {"front" => "舌", "back" => "tonque", "chapter" => "3", "new" => "no"},
  {"front" => "升", "back" => "litre", "chapter" => "3", "new" => "no"},
  {"front" => "丸", "back" => "pill / (bottle of pills)", "chapter" => "3", "new" => "no"},
  {"front" => "卜", "back" => "divination / (divining rod / magic wand)", "chapter" => "3", "new" => "no"},
  {"front" => "占", "back" => "tell fortunes", "chapter" => "3", "new" => "no"},
  {"front" => "上", "back" => "above", "chapter" => "3", "new" => "no"},
  {"front" => "下", "back" => "below", "chapter" => "3", "new" => "no"},
  {"front" => "卡", "back" => "card", "chapter" => "3", "new" => "no"},
  {"front" => "卓", "back" => "eminent", "chapter" => "3", "new" => "no"},
  {"front" => "朝", "back" => "dynasty", "chapter" => "3", "new" => "no"},
  {"front" => "嘲", "back" => "ridicule [v]", "chapter" => "3", "new" => "no"},
  #Lesson 4
  {"front" => "只", "back" => "only", "chapter" => "4", "new" => "no"},
  {"front" => "贝", "back" => "shellfish", "chapter" => "4", "new" => "no"},
  {"front" => "贴", "back" => "paste [v]", "chapter" => "4", "new" => "no"},
  {"front" => "贞", "back" => "chaste", "chapter" => "4", "new" => "no"},
  {"front" => "员", "back" => "employee", "chapter" => "4", "new" => "no"},
  {"front" => "儿", "back" => "youngster / (human legs)", "chapter" => "4", "new" => "no"},
  {"front" => "几", "back" => "how many? / (wind / small table)", "chapter" => "4", "new" => "no"},
  {"front" => "见", "back" => "see", "chapter" => "4", "new" => "no"},
  {"front" => "元", "back" => "beginning", "chapter" => "4", "new" => "no"},
  {"front" => "页", "back" => "page / (head)", "chapter" => "4", "new" => "no"},
  {"front" => "顽", "back" => "stubborn", "chapter" => "4", "new" => "no"},
  {"front" => "凡", "back" => "ordinary", "chapter" => "4", "new" => "no"},
  {"front" => "肌", "back" => "muscle", "chapter" => "4", "new" => "no"},
  {"front" => "负", "back" => "defeated [adj]", "chapter" => "4", "new" => "no"},
  {"front" => "万", "back" => "ten thousand", "chapter" => "4", "new" => "no"},
  {"front" => "匀", "back" => "uniform [adj]", "chapter" => "4", "new" => "no"},
  {"front" => "句", "back" => "sentence [n]", "chapter" => "4", "new" => "no"},
  {"front" => "旬", "back" => "decameron", "chapter" => "4", "new" => "no"},
  {"front" => "勺", "back" => "ladle", "chapter" => "4", "new" => "no"},
  {"front" => "的", "back" => "bull's eye", "chapter" => "4", "new" => "no"},
  {"front" => "首", "back" => "heads", "chapter" => "4", "new" => "no"},

  #Lesson 5
  {"front" => "直", "back" => "straight", "chapter" => "5", "new" => "no"},
  {"front" => "置", "back" => "setup", "chapter" => "5", "new" => "no"},
  {"front" => "具", "back" => "tool", "chapter" => "5", "new" => "no"},
  {"front" => "真", "back" => "true", "chapter" => "5", "new" => "no"},
  {"front" => "工", "back" => "work [n]", "chapter" => "5", "new" => "no"},
  {"front" => "左", "back" => "left [n/adj]", "chapter" => "5", "new" => "no"},
  {"front" => "右", "back" => "right [n/adj]", "chapter" => "5", "new" => "no"},
  {"front" => "有", "back" => "possess", "chapter" => "5", "new" => "no"},
  {"front" => "贿", "back" => "bribe [n]", "chapter" => "5", "new" => "no"},
  {"front" => "贡", "back" => "tribute", "chapter" => "5", "new" => "no"},
  {"front" => "项", "back" => "item", "chapter" => "5", "new" => "no"},
  {"front" => "刀", "back" => "sword (dagger / saber)", "chapter" => "5", "new" => "no"},
  {"front" => "仞", "back" => "blade", "chapter" => "5", "new" => "no"},
  {"front" => "切", "back" => "cut [v]", "chapter" => "5", "new" => "no"},
  {"front" => "召", "back" => "summon", "chapter" => "5", "new" => "no"},
  {"front" => "昭", "back" => "evident", "chapter" => "5", "new" => "no"},
  {"front" => "则", "back" => "rule [n]", "chapter" => "5", "new" => "no"},
  {"front" => "副", "back" => "vice-", "chapter" => "5", "new" => "no"},
  {"front" => "丁", "back" => "fourth (nail / spike)", "chapter" => "5", "new" => "no"},
  {"front" => "叮", "back" => "sting [v]", "chapter" => "5", "new" => "no"},
  {"front" => "可", "back" => "can [ad.v]", "chapter" => "5", "new" => "no"},
  {"front" => "哥", "back" => "older brother", "chapter" => "5", "new" => "no"},
  {"front" => "顶", "back" => "crest", "chapter" => "5", "new" => "no"}

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
  ]
  
add_cards_to_forward_deck forward_deck, cards
add_cards_to_reverse_deck reverse_deck, cards


forward_deck = get_or_create_deck 'ACCS - Twers (reading practice)', user.id, true, false, 'front'
reverse_deck = get_or_create_deck 'ACCS - Twers (writing practice)', user.id, true, false, 'front'
typing_deck = get_or_create_deck 'ACCS - Twers (typing practice)', user.id, true, true, 'back'


cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1", "pronunciation" => "yī", "chapter" => "1", "new" => "no"},
  {"front" => "二", "back" => "2", "pronunciation" => "èr", "chapter" => "1", "new" => "no"},
  {"front" => "三", "back" => "3", "pronunciation" => "sān", "chapter" => "1", "new" => "no"},
  {"front" => "四", "back" => "4", "pronunciation" => "sì", "chapter" => "1", "new" => "no"},
  {"front" => "五", "back" => "5", "pronunciation" => "wŭ", "chapter" => "1", "new" => "no"},
  {"front" => "六", "back" => "6", "pronunciation" => "liù", "chapter" => "1", "new" => "no"},
  {"front" => "七", "back" => "7", "pronunciation" => "qī", "chapter" => "1", "new" => "no"},
  {"front" => "八", "back" => "8", "pronunciation" => "bā", "chapter" => "1", "new" => "no"},
  {"front" => "九", "back" => "9", "pronunciation" => "jiŭ", "chapter" => "1", "new" => "no"},
  {"front" => "十", "back" => "10", "pronunciation" => "shí", "chapter" => "1", "new" => "no"},
  {"front" => "女", "back" => "female", "pronunciation" => "nǚ", "chapter" => "1", "new" => "no"},
  {"front" => "安", "back" => "peace", "pronunciation" => "ān", "chapter" => "1", "new" => "no"},
  {"front" => "子", "back" => "child", "pronunciation" => "zǐ", "chapter" => "1", "new" => "no"},
  {"front" => "好", "back" => "good", "pronunciation" => "hăo", "chapter" => "1", "new" => "no"},
  {"front" => "人", "back" => "Man / mankind", "pronunciation" => "rén", "chapter" => "1", "new" => "no"},
  {"front" => "大", "back" => "big", "pronunciation" => "dà", "chapter" => "1", "new" => "no"},
  {"front" => "太", "back" => "excessive", "pronunciation" => "tài", "chapter" => "1", "new" => "no"},
  {"front" => "天", "back" => "sky", "pronunciation" => "tiān", "chapter" => "1", "new" => "no"},
  {"front" => "日", "back" => "sun", "pronunciation" => "rì", "chapter" => "1", "new" => "no"},
  {"front" => "月", "back" => "moon", "pronunciation" => "yuè", "chapter" => "1", "new" => "no"},
  {"front" => "明", "back" => "bright", "pronunciation" => "míng", "chapter" => "1", "new" => "no"},
  {"front" => "白", "back" => "clear", "pronunciation" => "bái", "chapter" => "1", "new" => "no"},
  {"front" => "明白", "back" => "understand", "pronunciation" => "míng bái", "chapter" => "1", "new" => "no"},
  {"front" => "晶", "back" => "crystal", "pronunciation" => "jīng", "chapter" => "1", "new" => "no"},
  {"front" => "旦", "back" => "dawn", "pronunciation" => "dàn", "chapter" => "1", "new" => "no"},
  {"front" => "字", "back" => "word", "pronunciation" => "zì", "chapter" => "1", "new" => "no"},
  {"front" => "早", "back" => "early", "pronunciation" => "zăo", "chapter" => "1", "new" => "no"},
  {"front" => "百", "back" => "hundred", "pronunciation" => "băi", "chapter" => "1", "new" => "no"},
  {"front" => "千", "back" => "thousand", "pronunciation" => "qiān", "chapter" => "1", "new" => "no"},
  {"front" => "万", "back" => "ten thousand", "pronunciation" => "wàn", "chapter" => "1", "new" => "no"},
  {"front" => "亿", "back" => "hundred million", "pronunciation" => "yì", "chapter" => "1", "new" => "no"},
  {"front" => "女人", "back" => "woman", "pronunciation" => "nǚ rén", "chapter" => "1", "new" => "no"},
  {"front" => "早安", "back" => "good morning", "pronunciation" => "zăo ān", "chapter" => "1", "new" => "no"},
  {"front" => "大人", "back" => "adult / big man", "pronunciation" => "dà rén", "chapter" => "1", "new" => "no"},
  {"front" => "太太", "back" => "Mrs", "pronunciation" => "tài tài", "chapter" => "1", "new" => "no"},
  {"front" => "白天", "back" => "daytime", "pronunciation" => "bái tiān", "chapter" => "1", "new" => "no"},
  {"front" => "明天", "back" => "tomorrow", "pronunciation" => "míng tiān", "chapter" => "1", "new" => "no"},
  {"front" => "天天", "back" => "everyday", "pronunciation" => "tiān tiān", "chapter" => "1", "new" => "no"},
  {"front" => "太大", "back" => "too big", "pronunciation" => "tài dà", "chapter" => "1", "new" => "no"},
  {"front" => "好人", "back" => "good person", "pronunciation" => "hăo rén", "chapter" => "1", "new" => "no"},
  {"front" => "零", "back" => "zero", "pronunciation" => "lìng", "chapter" => "1", "new" => "no"},
  #Lesson 2
  {"front" => "小", "back" => "small", "pronunciation" => "xiăo", "chapter" => "2", "new" => "no"},
  {"front" => "也", "back" => "also[adv]", "pronunciation" => "yĕ", "chapter" => "2", "new" => "no"},
  {"front" => "他", "back" => "he/him", "pronunciation" => "tā", "chapter" => "2", "new" => "no"},
  {"front" => "她", "back" => "she/her", "pronunciation" => "tā", "chapter" => "2", "new" => "no"},
  {"front" => "心", "back" => "heart", "pronunciation" => "xīn", "chapter" => "2", "new" => "no"},
  {"front" => "目", "back" => "eyes", "pronunciation" => "mù", "chapter" => "2", "new" => "no"},
  {"front" => "见", "back" => "see[v]", "pronunciation" => "jiàn", "chapter" => "2", "new" => "no"},
  {"front" => "门", "back" => "door", "pronunciation" => "mén", "chapter" => "2", "new" => "no"},
  {"front" => "们", "back" => "plural", "pronunciation" => "men", "chapter" => "2", "new" => "no"},
  {"front" => "人们", "back" => "people", "pronunciation" => "rén men", "chapter" => "2", "new" => "no"},
  {"front" => "手", "back" => "hand", "pronunciation" => "shǒu", "chapter" => "2", "new" => "no"},
  {"front" => "戈", "back" => "spear", "pronunciation" => "gē", "chapter" => "2", "new" => "no"},
  {"front" => "我", "back" => "I/me[pron]", "pronunciation" => "wǒ", "chapter" => "2", "new" => "no"},
  {"front" => "看", "back" => "look", "pronunciation" => "kàn", "chapter" => "2", "new" => "no"},
  {"front" => "你", "back" => "you", "pronunciation" => "nǐ", "chapter" => "2", "new" => "no"},
  {"front" => "不", "back" => "not[adj]", "pronunciation" => "bù", "chapter" => "2", "new" => "no"},
  {"front" => "了", "back" => "[a modal participle]", "pronunciation" => "le", "chapter" => "2", "new" => "no"},
  {"front" => "吗", "back" => "[an interrogative participle]", "pronunciation" => "ma", "chapter" => "2", "new" => "no"},
  {"front" => "很", "back" => "very[adv]", "pronunciation" => "hěn", "chapter" => "2", "new" => "no"},
  {"front" => "小心", "back" => "be careful", "pronunciation" => "xiăo xīn", "chapter" => "2", "new" => "no"},
  {"front" => "谢谢", "back" => "thank you[v]", "pronunciation" => "xiè xie", "chapter" => "2", "new" => "no"},
  {"front" => "问好", "back" => "to greet[v]; greeting[n]", "pronunciation" => "wèn hòu", "chapter" => "2", "new" => "no"},
  {"front" => "你好", "back" => "hello", "pronunciation" => "nǐ hǎo", "chapter" => "2", "new" => "no"},
  {"front" => "好久", "back" => "long time[adj]", "pronunciation" => "hǎo jiŭ", "chapter" => "2", "new" => "no"},
  {"front" => "心目", "back" => "mood, memory", "pronunciation" => "xīn mù", "chapter" => "2", "new" => "no"},
  {"front" => "安心", "back" => "feel at ease / not worried", "pronunciation" => "ān xīn", "chapter" => "2", "new" => "no"},
  {"front" => "好心人", "back" => "kind-hearted person", "pronunciation" => "hǎo xīn rén", "chapter" => "2", "new" => "no"},
  {"front" => "看见", "back" => "see", "pronunciation" => "kàn jiàn", "chapter" => "2", "new" => "no"},
  {"front" => "明天见", "back" => "see you tomorrow", "pronunciation" => "míng tiān jiàn", "chapter" => "2", "new" => "no"},
  {"front" => "太小", "back" => "too small", "pronunciation" => "tāi xiăo", "chapter" => "2", "new" => "no"},
  {"front" => "你们", "back" => "all of you", "pronunciation" => "nǐ men", "chapter" => "2", "new" => "no"},
  {"front" => "他们", "back" => "they / them", "pronunciation" => "tā men", "chapter" => "2", "new" => "no"},
  {"front" => "她们", "back" => "(female) they", "pronunciation" => "tā men", "chapter" => "2", "new" => "no"},
  {"front" => "我们", "back" => "we / us", "pronunciation" => "wǒ men", "chapter" => "2", "new" => "no"},
  {"front" => "你早", "back" => "good mornǐng", "pronunciation" => "nǐ zǎo", "chapter" => "2", "new" => "no"},
  {"front" => "你们好", "back" => "how do you do, hello", "pronunciation" => "nǐ men hǎo", "chapter" => "2", "new" => "no"},
  {"front" => "您好", "back" => "how do you do, hello (polite)", "pronunciation" => "nǐn hǎo", "chapter" => "2", "new" => "no"},
  {"front" => "好久不见了", "back" => "Long time no see", "pronunciation" => "hǎo jiǔ bú jiàn le", "chapter" => "2", "new" => "no"},
  {"front" => "你好吗？", "back" => "How are you?", "pronunciation" => "nǐ hǎo ma?", "chapter" => "2", "new" => "no"},
  {"front" => "我很好", "back" => "I am fine", "pronunciation" => "Wǒ hěn hǎo", "chapter" => "2", "new" => "no"},
  {"front" => "我也很好", "back" => "I'm also fine", "pronunciation" => "Wǒ yě hěn hǎo", "chapter" => "2", "new" => "no"},
  {"front" => "你太太好吗", "back" => "How is your wife?", "pronunciation" => "nǐ tāi tāi hǎo ma?", "chapter" => "2", "new" => "no"},
  {"front" => "她也很好", "back" => "She is also fine", "pronunciation" => "tā yě hěn hǎo", "chapter" => "2", "new" => "no"},

  #Lesson 3
  {"front" => "开", "back" => "opens", "pronunciation" => "kāi", "chapter" => "3", "new" => "no"},
  {"front" => "口", "back" => "mouth", "pronunciation" => "kǒu", "chapter" => "3", "new" => "no"},
  {"front" => "叫", "back" => "to call", "pronunciation" => "jiào [v]", "chapter" => "3", "new" => "no"},
  {"front" => "马", "back" => "horse", "pronunciation" => "mǎ", "chapter" => "3", "new" => "no"},
  {"front" => "闯", "back" => "rush", "pronunciation" => "chuǎng", "chapter" => "3", "new" => "no"},
  {"front" => "问", "back" => "to ask[v]", "pronunciation" => "wèn", "chapter" => "3", "new" => "no"},
  {"front" => "妈", "back" => "mother", "pronunciation" => "mā", "chapter" => "3", "new" => "no"},
  {"front" => "唱", "back" => "sings", "pronunciation" => "chàng", "chapter" => "3", "new" => "no"},
  {"front" => "门口", "back" => "passage way", "pronunciation" => "mén kǒu", "chapter" => "3", "new" => "no"},
  {"front" => "大门", "back" => "front door", "pronunciation" => "dà mén", "chapter" => "3", "new" => "no"},
  {"front" => "开门", "back" => "open the door", "pronunciation" => "kāi mén", "chapter" => "3", "new" => "no"},
  {"front" => "开口", "back" => "open one's mouth to speak", "pronunciation" => "kāi kǒu", "chapter" => "3", "new" => "no"},
  {"front" => "开心", "back" => "feel happy", "pronunciation" => "kāi xīn", "chapter" => "3", "new" => "no"},
  {"front" => "请问", "back" => "excuse me， may I ask", "pronunciation" => "qǐng wèn", "chapter" => "3", "new" => "no"},
  {"front" => "问题", "back" => "question  / problem", "pronunciation" => "wèn tí", "chapter" => "3", "new" => "no"},
  {"front" => "吗上", "back" => "at once", "pronunciation" => "mǎ shàng", "chapter" => "3", "new" => "no"},
  {"front" => "妈妈", "back" => "mother", "pronunciation" => "māma", "chapter" => "3", "new" => "no"},
  {"front" => "大妈", "back" => "aunty", "pronunciation" => "dà mā", "chapter" => "3", "new" => "no"},
  {"front" => "人口", "back" => "population", "pronunciation" => "rén kǒu", "chapter" => "3", "new" => "no"},
  {"front" => "入口", "back" => "entrance", "pronunciation" => "rù kǒu", "chapter" => "3", "new" => "no"},
  {"front" => "出口", "back" => "exit;export", "pronunciation" => "chū kǒu", "chapter" => "3", "new" => "no"},
  {"front" => "进口", "back" => "entrance;import", "pronunciation" => "jìn kǒu", "chapter" => "3", "new" => "no"},
  {"front" => "姓名", "back" => "fullname [n.]", "pronunciation" => "xìng míng", "chapter" => "3", "new" => "no"},
  {"front" => "贵姓", "back" => "Your honourable surname", "pronunciation" => "guì xìng", "chapter" => "3", "new" => "no"},
  {"front" => "姓", "back" => "surname[v;n]", "pronunciation" => "xìng", "chapter" => "3", "new" => "no"},
  {"front" => "什么", "back" => "what[pron]", "pronunciation" => "shén me", "chapter" => "3", "new" => "no"},
  {"front" => "名字", "back" => "name[n]", "pronunciation" => "míng zi", "chapter" => "3", "new" => "no"},
  {"front" => "见到", "back" => "to see; to have seen", "pronunciation" => "jiàn dào", "chapter" => "3", "new" => "no"},
  {"front" => "您", "back" => "you(polite)", "pronunciation" => "nín", "chapter" => "3", "new" => "no"},
  {"front" => "高兴", "back" => "happy glad[adj]", "pronunciation" => "gāo xìng", "chapter" => "3", "new" => "no"},
  {"front" => "请问， 您贵姓", "back" => "Excuse me, may I know your surname?", "pronunciation" => "qǐng wèn, nín guì xìng", "chapter" => "3", "new" => "no"},
  {"front" => "我姓...， 叫...", "back" => "My surname is ..., my given name is ...", "pronunciation" => "míng, wǒ xìng ?, jiào ?", "chapter" => "3", "new" => "no"},
  {"front" => "您叫什么名字", "back" => "What is your name?", "pronunciation" => "nín jiào shén me míng zi", "chapter" => "3", "new" => "no"},
  {"front" => "我叫。。。", "back" => "My name is...", "pronunciation" => "wǒ jiào...", "chapter" => "3", "new" => "no"},
  {"front" => "见到您， 我很高兴。", "back" => "I am pleased to meet you.", "pronunciation" => "jiàn dào nín, wǒ hěn gāo xìng", "chapter" => "3", "new" => "no"},
  {"front" => "见到您， 我也很高兴。", "back" => "I am also please to meet you.", "pronunciation" => "jiàn dào nín, wǒ yě hěn gāo xìng", "chapter" => "3", "new" => "no"}

  #lesson 4
  #lesson 5
  #lesson 6
  #lesson 7
  #lesson 8
  #lesson 9
  #lesson 10
  ]


add_cards_to_forward_deck forward_deck, cards
add_cards_to_reverse_deck reverse_deck, cards
add_cards_to_reverse_deck typing_deck, cards