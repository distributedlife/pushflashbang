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

SECONDS_IN_MINUTE = 60
MINUTES_IN_HOUR = 60
HOURS_IN_DAY = 24
DAYS_IN_MONTH = 30  #approx
DAYS_IN_YEAR = 365

SECONDS_IN_HOUR = MINUTES_IN_HOUR * SECONDS_IN_MINUTE
SECONDS_IN_DAY = SECONDS_IN_HOUR * HOURS_IN_DAY
SECONDS_IN_MONTH = SECONDS_IN_DAY * DAYS_IN_MONTH
SECONDS_IN_YEAR = SECONDS_IN_DAY * DAYS_IN_YEAR

unless CardTiming.count > 0
  CardTiming.create(:seconds => 5)                            # 5 seconds
  CardTiming.create(:seconds => 25)                           # 25 seconds
  CardTiming.create(:seconds => SECONDS_IN_MINUTE * 2)        # 2 minutes
  CardTiming.create(:seconds => SECONDS_IN_MINUTE * 10)       # 10 minutes
  CardTiming.create(:seconds => SECONDS_IN_HOUR)              # 1 hour
  CardTiming.create(:seconds => SECONDS_IN_HOUR * 5)          # 5 hours
  CardTiming.create(:seconds => SECONDS_IN_DAY)               # 1 day
  CardTiming.create(:seconds => SECONDS_IN_DAY * 5)           # 5 days
  CardTiming.create(:seconds => SECONDS_IN_DAY * 25)          # 25 days
  CardTiming.create(:seconds => SECONDS_IN_MONTH * 4)         # 4 months
  CardTiming.create(:seconds => SECONDS_IN_YEAR * 2)          # 2 years
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
  {"front" => "一", "back" => "1 / (floor, ceiling)", "chapter" => "1", "new" => "update"},
  {"front" => "二", "back" => "2", "chapter" => "1", "new" => "update"},
  {"front" => "三", "back" => "3", "chapter" => "1", "new" => "update"},
  {"front" => "四", "back" => "4", "chapter" => "1", "new" => "update"},
  {"front" => "五", "back" => "5", "chapter" => "1", "new" => "update"},
  {"front" => "六", "back" => "6", "chapter" => "1", "new" => "update"},
  {"front" => "七", "back" => "7 / (diced)", "chapter" => "1", "new" => "update"},
  {"front" => "八", "back" => "8", "chapter" => "1", "new" => "update"},
  {"front" => "九", "back" => "9 / (baseball)", "chapter" => "1", "new" => "update"},
  {"front" => "十", "back" => "10", "chapter" => "1", "new" => "update"},
  {"front" => "目", "back" => "eye", "chapter" => "1", "new" => "update"},
  {"front" => "月", "back" => "month / (moon, flesh, part of body)", "chapter" => "1", "new" => "update"},
  {"front" => "口", "back" => "mouth", "chapter" => "1", "new" => "update"},
  {"front" => "田", "back" => "rice field / (brains)", "chapter" => "1", "new" => "update"},
  {"front" => "日", "back" => "day / (sun, tonque wagging)", "chapter" => "1", "new" => "update"},
  #Lesson 2
  {"front" => "古", "back" => "ancient", "chapter" => "2", "new" => "update"},
  {"front" => "胡", "back" => "recklessly", "chapter" => "2", "new" => "update"},
  {"front" => "叶", "back" => "leaf", "chapter" => "2", "new" => "update"},
  {"front" => "吾", "back" => "I (literary)", "chapter" => "2", "new" => "update"},
  {"front" => "朋", "back" => "companion", "chapter" => "2", "new" => "update"},
  {"front" => "明", "back" => "bright", "chapter" => "2", "new" => "update"},
  {"front" => "唱", "back" => "sing", "chapter" => "2", "new" => "update"},
  {"front" => "晶", "back" => "sparkling", "chapter" => "2", "new" => "update"},
  {"front" => "品", "back" => "goods", "chapter" => "2", "new" => "update"},
  {"front" => "昌", "back" => "prosperous", "chapter" => "2", "new" => "update"},
  {"front" => "早", "back" => "early / (sunflower)", "chapter" => "2", "new" => "update"},
  {"front" => "旭", "back" => "rising sun", "chapter" => "2", "new" => "update"},
  {"front" => "世", "back" => "generation", "chapter" => "2", "new" => "update"},
  {"front" => "胃", "back" => "stomach", "chapter" => "2", "new" => "update"},
  {"front" => "旦", "back" => "daybreak", "chapter" => "2", "new" => "update"},
  {"front" => "凹", "back" => "concave", "chapter" => "2", "new" => "update"},
  {"front" => "凸", "back" => "convex", "chapter" => "2", "new" => "update"},
  #Lesson 3
  {"front" => "自", "back" => "oneself / (nose)", "chapter" => "3", "new" => "update"},
  {"front" => "白", "back" => "white", "chapter" => "3", "new" => "update"},
  {"front" => "百", "back" => "hundred", "chapter" => "3", "new" => "update"},
  {"front" => "皂", "back" => "soap", "chapter" => "3", "new" => "update"},
  {"front" => "旧", "back" => "old", "chapter" => "3", "new" => "update"},
  {"front" => "中", "back" => "middle [n/adj]", "chapter" => "3", "new" => "update"},
  {"front" => "千", "back" => "thousand", "chapter" => "3", "new" => "update"},
  {"front" => "舌", "back" => "tonque", "chapter" => "3", "new" => "update"},
  {"front" => "升", "back" => "litre", "chapter" => "3", "new" => "update"},
  {"front" => "丸", "back" => "pill / (bottle of pills)", "chapter" => "3", "new" => "update"},
  {"front" => "卜", "back" => "divination / (divining rod / magic wand)", "chapter" => "3", "new" => "update"},
  {"front" => "占", "back" => "tell fortunes", "chapter" => "3", "new" => "update"},
  {"front" => "上", "back" => "above", "chapter" => "3", "new" => "update"},
  {"front" => "下", "back" => "below", "chapter" => "3", "new" => "update"},
  {"front" => "卡", "back" => "card", "chapter" => "3", "new" => "update"},
  {"front" => "卓", "back" => "eminent", "chapter" => "3", "new" => "update"},
  {"front" => "朝", "back" => "dynasty", "chapter" => "3", "new" => "update"},
  {"front" => "嘲", "back" => "ridicule [v]", "chapter" => "3", "new" => "update"},
  #Lesson 4
  {"front" => "只", "back" => "only", "chapter" => "4", "new" => "update"},
  {"front" => "贝", "back" => "shellfish", "chapter" => "4", "new" => "update"},
  {"front" => "贴", "back" => "paste [v]", "chapter" => "4", "new" => "update"},
  {"front" => "贞", "back" => "chaste", "chapter" => "4", "new" => "update"},
  {"front" => "员", "back" => "employee", "chapter" => "4", "new" => "update"},
  {"front" => "儿", "back" => "youngster / (human legs)", "chapter" => "4", "new" => "update"},
  {"front" => "几", "back" => "how many? / (wind / small table)", "chapter" => "4", "new" => "update"},
  {"front" => "见", "back" => "see", "chapter" => "4", "new" => "update"},
  {"front" => "元", "back" => "beginning", "chapter" => "4", "new" => "update"},
  {"front" => "页", "back" => "page / (head)", "chapter" => "4", "new" => "update"},
  {"front" => "顽", "back" => "stubborn", "chapter" => "4", "new" => "update"},
  {"front" => "凡", "back" => "ordinary", "chapter" => "4", "new" => "update"},
  {"front" => "肌", "back" => "muscle", "chapter" => "4", "new" => "update"},
  {"front" => "负", "back" => "defeated [adj]", "chapter" => "4", "new" => "update"},
  {"front" => "万", "back" => "ten thousand", "chapter" => "4", "new" => "update"},
  {"front" => "匀", "back" => "uniform [adj]", "chapter" => "4", "new" => "update"},
  {"front" => "句", "back" => "sentence [n]", "chapter" => "4", "new" => "update"},
  {"front" => "旬", "back" => "decameron", "chapter" => "4", "new" => "update"},
  {"front" => "勺", "back" => "ladle", "chapter" => "4", "new" => "update"},
  {"front" => "的", "back" => "bull's eye", "chapter" => "4", "new" => "update"},
  {"front" => "首", "back" => "heads", "chapter" => "4", "new" => "update"},

  #Lesson 5
  {"front" => "直", "back" => "straight", "chapter" => "5", "new" => "update"},
  {"front" => "置", "back" => "setup", "chapter" => "5", "new" => "update"},
  {"front" => "具", "back" => "tool", "chapter" => "5", "new" => "update"},
  {"front" => "真", "back" => "true", "chapter" => "5", "new" => "update"},
  {"front" => "工", "back" => "work [n]", "chapter" => "5", "new" => "update"},
  {"front" => "左", "back" => "left [n/adj]", "chapter" => "5", "new" => "update"},
  {"front" => "右", "back" => "right [n/adj]", "chapter" => "5", "new" => "update"},
  {"front" => "有", "back" => "possess", "chapter" => "5", "new" => "update"},
  {"front" => "贿", "back" => "bribe [n]", "chapter" => "5", "new" => "update"},
  {"front" => "贡", "back" => "tribute", "chapter" => "5", "new" => "update"},
  {"front" => "项", "back" => "item", "chapter" => "5", "new" => "update"},
  {"front" => "刀", "back" => "sword (dagger / saber)", "chapter" => "5", "new" => "update"},
  {"front" => "仞", "back" => "blade", "chapter" => "5", "new" => "update"},
  {"front" => "切", "back" => "cut [v]", "chapter" => "5", "new" => "update"},
  {"front" => "召", "back" => "summon", "chapter" => "5", "new" => "update"},
  {"front" => "昭", "back" => "evident", "chapter" => "5", "new" => "update"},
  {"front" => "则", "back" => "rule [n]", "chapter" => "5", "new" => "update"},
  {"front" => "副", "back" => "vice-", "chapter" => "5", "new" => "update"},
  {"front" => "丁", "back" => "fourth (nail / spike)", "chapter" => "5", "new" => "update"},
  {"front" => "叮", "back" => "sting [v]", "chapter" => "5", "new" => "update"},
  {"front" => "可", "back" => "can [ad.v]", "chapter" => "5", "new" => "update"},
  {"front" => "哥", "back" => "older brother", "chapter" => "5", "new" => "update"},
  {"front" => "顶", "back" => "crest", "chapter" => "5", "new" => "update"}

  #Lesson 6
#  {"back" => "second", "front" => "乙", "chapter" => "1", "new" => "update"},
#  {"back" => "fly", "front" => "飞", "chapter" => "1", "new" => "update"},
#  {"back" => "child", "front" => "子", "chapter" => "1", "new" => "update"},
#  {"back" => "cavity", "front" => "孔", "chapter" => "1", "new" => "update"},
#  {"back" => "roar", "front" => "吼", "chapter" => "1", "new" => "update"},
#  {"back" => "chaos", "front" => "乱", "chapter" => "1", "new" => "update"},
#  {"back" => "(-ed)", "front" => "了", "chapter" => "1", "new" => "update"},
#  {"back" => "woman", "front" => "奴(left only）", "chapter" => "1", "new" => "update"},
#  {"back" => "good", "front" => "好", "chapter" => "1", "new" => "update"},
#  {"back" => "be like", "front" => "如", "chapter" => "1", "new" => "update"},
#  {"back" => "mother", "front" => "母", "chapter" => "1", "new" => "update"},
#  {"back" => "pierce", "front" => "贯", "chapter" => "1", "new" => "update"},
#  {"back" => "elder brother", "front" => "兄", "chapter" => "1", "new" => "update"},
#  {"back" => "overcome", "front" => "克", "chapter" => "1", "new" => "update"},
#  {"back" => "small", "front" => "小", "chapter" => "1", "new" => "update"},
#  {"back" => "few", "front" => "少", "chapter" => "1", "new" => "update"},
#  {"back" => "noisy", "front" => "吵", "chapter" => "1", "new" => "update"},
#  {"back" => "grandchild", "front" => "孙", "chapter" => "1", "new" => "update"},
#  {"back" => "large", "front" => "大", "chapter" => "1", "new" => "update"},
#  {"back" => "tip", "front" => "尖", "chapter" => "1", "new" => "update"},
#  {"back" => "evening", "front" => "夕", "chapter" => "1", "new" => "update"},
#  {"back" => "many", "front" => "多", "chapter" => "1", "new" => "update"},
#  {"back" => "enough", "front" => "够", "chapter" => "1", "new" => "update"},
#  {"back" => "outside", "front" => "外", "chapter" => "1", "new" => "update"},
#  {"back" => "name", "front" => "名", "chapter" => "1", "new" => "update"},
#  {"back" => "silk gauze", "front" => "罗", "chapter" => "1", "new" => "update"},
#  {"back" => "factory", "front" => "厂", "chapter" => "1", "new" => "update"},
#  {"back" => "hall", "front" => "厅", "chapter" => "1", "new" => "update"},
#  {"back" => "stern", "front" => "历", "chapter" => "1", "new" => "update"},
#  {"back" => "thick", "front" => "厚", "chapter" => "1", "new" => "update"},
#  {"back" => "stone", "front" => "石", "chapter" => "1", "new" => "update"},
#  {"back" => "gravel", "front" => "砂", "chapter" => "1", "new" => "update"},
#  {"back" => "wonderful", "front" => "秒", "chapter" => "1", "new" => "update"},
#  {"back" => "resemble", "front" => "肖", "chapter" => "1", "new" => "update"},
#  {"back" => "peel", "front" => "削", "chapter" => "1", "new" => "update"},
#  {"back" => "ray", "front" => "光", "chapter" => "1", "new" => "update"},
#  {"back" => "overly", "front" => "太", "chapter" => "1", "new" => "update"},
#  {"back" => "economise", "front" => "省", "chapter" => "1", "new" => "update"},
#  {"back" => "strange", "front" => "奇", "chapter" => "1", "new" => "update"},
#  {"back" => "stream", "front" => "川", "chapter" => "1", "new" => "update"},
#  {"back" => "state", "front" => "州", "chapter" => "1", "new" => "update"},
#  {"back" => "obey", "front" => "顺", "chapter" => "1", "new" => "update"},
#  {"back" => "water", "front" => "水", "chapter" => "1", "new" => "update"},
#  {"back" => "eternity", "front" => "永", "chapter" => "1", "new" => "update"},
#  {"back" => "blood vessels", "front" => "脉", "chapter" => "1", "new" => "update"},
#  {"back" => "request", "front" => "求", "chapter" => "1", "new" => "update"},
#  {"back" => "spring", "front" => "泉", "chapter" => "1", "new" => "update"},
#  {"back" => "flatlands", "front" => "原", "chapter" => "1", "new" => "update"},
#  {"back" => "swim", "front" => "泳", "chapter" => "1", "new" => "update"},
#  {"back" => "continent", "front" => "洲", "chapter" => "1", "new" => "update"},
#  {"back" => "marsh", "front" => "沼", "chapter" => "1", "new" => "update"},
#  {"back" => "sand", "front" => "沙", "chapter" => "1", "new" => "update"},
#  {"back" => "Yangtze", "front" => "江", "chapter" => "1", "new" => "update"},
#  {"back" => "juice", "front" => "汁", "chapter" => "1", "new" => "update"},
#  {"back" => "tide", "front" => "潮", "chapter" => "1", "new" => "update"},
#  {"back" => "source", "front" => "源", "chapter" => "1", "new" => "update"},
#  {"back" => "extinguish", "front" => "消", "chapter" => "1", "new" => "update"},
#  {"back" => "river", "front" => "河", "chapter" => "1", "new" => "update"},
#  {"back" => "fish", "front" => "鱼", "chapter" => "1", "new" => "update"},
#  {"back" => "fishing", "front" => "渔", "chapter" => "1", "new" => "update"},
#  {"back" => "lake", "front" => "湖", "chapter" => "1", "new" => "update"},
#  {"back" => "fathom", "front" => "测", "chapter" => "1", "new" => "update"},
#  {"back" => "soil", "front" => "土", "chapter" => "1", "new" => "update"},
#  {"back" => "equal", "front" => "均", "chapter" => "1", "new" => "update"},
#  {"back" => "belly", "front" => "肚", "chapter" => "1", "new" => "update"},
#  {"back" => "dust", "front" => "尘", "chapter" => "1", "new" => "update"},
#  {"back" => "fill in", "front" => "填", "chapter" => "1", "new" => "update"},
#  {"back" => "spit", "front" => "吐", "chapter" => "1", "new" => "update"},
#  {"back" => "pressure", "front" => "压", "chapter" => "1", "new" => "update"},
#  {"back" => "waaah!", "front" => "哇", "chapter" => "1", "new" => "update"},
#  {"back" => "Chinese inch", "front" => "寸", "chapter" => "1", "new" => "update"},
#  {"back" => "seal", "front" => "封", "chapter" => "1", "new" => "update"},
#  {"back" => "time", "front" => "时", "chapter" => "1", "new" => "update"},
#  {"back" => "Buddhist temple", "front" => "寺", "chapter" => "1", "new" => "update"},
#  {"back" => "fire", "front" => "火", "chapter" => "1", "new" => "update"},
#  {"back" => "destroy", "front" => "灭", "chapter" => "1", "new" => "update"},
#  {"back" => "ashes", "front" => "灰", "chapter" => "1", "new" => "update"},
#  {"back" => "vexed", "front" => "烦", "chapter" => "1", "new" => "update"},
#  {"back" => "inflammation", "front" => "炎", "chapter" => "1", "new" => "update"},
#  {"back" => "thin", "front" => "淡", "chapter" => "1", "new" => "update"},
#  {"back" => "lamp", "front" => "灯", "chapter" => "1", "new" => "update"},
#  {"back" => "spot", "front" => "点", "chapter" => "1", "new" => "update"},
#  {"back" => "illuminate", "front" => "照", "chapter" => "1", "new" => "update"},
#  {"back" => "li (about 500m)", "front" => "里", "chapter" => "1", "new" => "update"},
#  {"back" => "quantity", "front" => "量", "chapter" => "1", "new" => "update"},
#  {"back" => "bury", "front" => "埋", "chapter" => "1", "new" => "update"},
#  {"back" => "black", "front" => "黑", "chapter" => "1", "new" => "update"},
#  {"back" => "black ink", "front" => "墨", "chapter" => "1", "new" => "update"},
#  {"back" => "risk", "front" => "冒", "chapter" => "1", "new" => "update"},
#  {"back" => "same", "front" => "同", "chapter" => "1", "new" => "update"},
#  {"back" => "cave", "front" => "洞", "chapter" => "1", "new" => "update"},
#  {"back" => "lovely", "front" => "丽", "chapter" => "1", "new" => "update"},
#  {"back" => "orientation", "front" => "向", "chapter" => "1", "new" => "update"},
#  {"back" => "echo", "front" => "响", "chapter" => "1", "new" => "update"},
#  {"back" => "esteem", "front" => "尚", "chapter" => "1", "new" => "update"},
#  {"back" => "character", "front" => "字", "chapter" => "1", "new" => "update"},
#  {"back" => "guard", "front" => "守", "chapter" => "1", "new" => "update"},
#  {"back" => "finish", "front" => "完", "chapter" => "1", "new" => "update"},
#  {"back" => "disaster", "front" => "灾", "chapter" => "1", "new" => "update"},
#  {"back" => "proclaim", "front" => "宣", "chapter" => "1", "new" => "update"},
#  {"back" => "nighttime", "front" => "宵", "chapter" => "1", "new" => "update"},
#  {"back" => "peaceful", "front" => "安", "chapter" => "1", "new" => "update"},
#  {"back" => "banquet", "front" => "宴", "chapter" => "1", "new" => "update"},
#  {"back" => "mail", "front" => "寄", "chapter" => "1", "new" => "update"},
#  {"back" => "wealthy", "front" => "富", "chapter" => "1", "new" => "update"},
#  {"back" => "store up", "front" => "贮", "chapter" => "1", "new" => "update"},
#  {"back" => "tree", "front" => "木", "chapter" => "1", "new" => "update"},
#  {"back" => "woods", "front" => "林", "chapter" => "1", "new" => "update"},
#  {"back" => "forest", "front" => "森", "chapter" => "1", "new" => "update"},
#  {"back" => "dreams", "front" => "梦", "chapter" => "1", "new" => "update"},
#  {"back" => "machine", "front" => "机", "chapter" => "1", "new" => "update"},
#  {"back" => "plant", "front" => "值", "chapter" => "1", "new" => "update"},
#  {"back" => "apricot", "front" => "杏", "chapter" => "1", "new" => "update"},
#  {"back" => "dim-witted", "front" => "呆", "chapter" => "1", "new" => "update"},
#  {"back" => "withered", "front" => "枯", "chapter" => "1", "new" => "update"},
#  {"back" => "village", "front" => "忖", "chapter" => "1", "new" => "update"},
#  {"back" => "one another", "front" => "相", "chapter" => "1", "new" => "update"},
#  {"back" => "notebook", "front" => "本", "chapter" => "1", "new" => "update"},
#  {"back" => "case", "front" => "案", "chapter" => "1", "new" => "update"},
#  {"back" => "not yet", "front" => "未", "chapter" => "1", "new" => "update"},
#  {"back" => "last", "front" => "末", "chapter" => "1", "new" => "update"},
#  {"back" => "foam", "front" => "沫", "chapter" => "1", "new" => "update"},
#  {"back" => "flavour", "front" => "味", "chapter" => "1", "new" => "update"},
#  {"back" => "younger sister", "front" => "妹", "chapter" => "1", "new" => "update"},
#  {"back" => "investigate", "front" => "查", "chapter" => "1", "new" => "update"},
#  {"back" => "sediment", "front" => "渣", "chapter" => "1", "new" => "update"},
#  {"back" => "dye", "front" => "染", "chapter" => "1", "new" => "update"},
#  {"back" => "plum", "front" => "李", "chapter" => "1", "new" => "update"},
#  {"back" => "table", "front" => "桌", "chapter" => "1", "new" => "update"},
#  {"back" => "miscellaneous", "front" => "杂", "chapter" => "1", "new" => "update"},
#  {"back" => "as if", "front" => "若", "chapter" => "1", "new" => "update"},
#  {"back" => "grass", "front" => "草", "chapter" => "1", "new" => "update"},
#  {"back" => "technique", "front" => "艺", "chapter" => "1", "new" => "update"},
#  {"back" => "suffering", "front" => "苦", "chapter" => "1", "new" => "update"},
#  {"back" => "wide", "front" => "宽", "chapter" => "1", "new" => "update"},
#  {"back" => "nobody", "front" => "莫", "chapter" => "1", "new" => "update"},
#  {"back" => "imitate", "front" => "摸", "chapter" => "1", "new" => "update"},
#  {"back" => "desert", "front" => "漠", "chapter" => "1", "new" => "update"},
#  {"back" => "grave", "front" => "幕", "chapter" => "1", "new" => "update"},
#  {"back" => "seedling", "front" => "苗", "chapter" => "1", "new" => "update"},
#  {"back" => "aim", "front" => "瞄", "chapter" => "1", "new" => "update"},
#  {"back" => "portent", "front" => "兆", "chapter" => "1", "new" => "update"},
#  {"back" => "peach", "front" => "桃", "chapter" => "1", "new" => "update"},
#  {"back" => "pooch", "front" => "犬", "chapter" => "1", "new" => "update"},
#  {"back" => "remarkable", "front" => "尤", "chapter" => "1", "new" => "update"},
#  {"back" => "detest", "front" => "厌", "chapter" => "1", "new" => "update"},
#  {"back" => "state of affairs", "front" => "状", "chapter" => "1", "new" => "update"},
#  {"back" => "put on makeup", "front" => "妆", "chapter" => "1", "new" => "update"},
#  {"back" => "general (military rank)", "front" => "将", "chapter" => "1", "new" => "update"},
#  {"back" => "seize", "front" => "获", "chapter" => "1", "new" => "update"},
#  {"back" => "silent", "front" => "默", "chapter" => "1", "new" => "update"},
#  {"back" => "sort of thing", "front" => "然", "chapter" => "1", "new" => "update"},
#  {"back" => "cry", "front" => "哭", "chapter" => "1", "new" => "update"},
#  {"back" => "utensil", "front" => "器", "chapter" => "1", "new" => "update"},
#  {"back" => "stinking (with drop）臭", "chapter" => "1", "new" => "update"},
#  {"back" => "dog", "front" => "狗", "chapter" => "1", "new" => "update"},
#  {"back" => "cow", "front" => "牛", "chapter" => "1", "new" => "update"},
#  {"back" => "special", "front" => "特", "chapter" => "1", "new" => "update"},
#  {"back" => "declare", "front" => "告", "chapter" => "1", "new" => "update"},
#  {"back" => "vast", "front" => "浩", "chapter" => "1", "new" => "update"},
#  {"back" => "before", "front" => "先", "chapter" => "1", "new" => "update"},
#  {"back" => "wash", "front" => "洗", "chapter" => "1", "new" => "update"},
#  {"back" => "individual", "front" => "个", "chapter" => "1", "new" => "update"},
#  {"back" => "introduce", "front" => "介", "chapter" => "1", "new" => "update"},
#  {"back" => "world", "front" => "界", "chapter" => "1", "new" => "update"},
#  {"back" => "tea", "front" => "茶", "chapter" => "1", "new" => "update"},
#  {"back" => "fit", "front" => "合", "chapter" => "1", "new" => "update"},
#  {"back" => "ha!", "front" => "哈", "chapter" => "1", "new" => "update"},
#  {"back" => "pagoda", "front" => "塔", "chapter" => "1", "new" => "update"},
#  {"back" => "king", "front" => "王", "chapter" => "1", "new" => "update"},
#  {"back" => "jade", "front" => "玉", "chapter" => "1", "new" => "update"},
#  {"back" => "treasure", "front" => "宝", "chapter" => "1", "new" => "update"},
#  {"back" => "ball", "front" => "球", "chapter" => "1", "new" => "update"},
#  {"back" => "present", "front" => "现", "chapter" => "1", "new" => "update"},
#  {"back" => "play", "front" => "玩", "chapter" => "1", "new" => "update"},
#  {"back" => "crazy", "front" => "狂", "chapter" => "1", "new" => "update"},
#  {"back" => "emperor", "front" => "皇", "chapter" => "1", "new" => "update"},
#  {"back" => "resplendent", "front" => "煌", "chapter" => "1", "new" => "update"},
#  {"back" => "submit", "front" => "呈", "chapter" => "1", "new" => "update"},
#  {"back" => "whole", "front" => "全", "chapter" => "1", "new" => "update"},
#  {"back" => "logic", "front" => "理", "chapter" => "1", "new" => "update"},
#  {"back" => "lord", "front" => "主", "chapter" => "1", "new" => "update"},
#  {"back" => "pour", "front" => "住", "chapter" => "1", "new" => "update"},
#  {"back" => "gold", "front" => "金", "chapter" => "1", "new" => "update"},
#  {"back" => "bell", "front" => "钟", "chapter" => "1", "new" => "update"},
#  {"back" => "copper", "front" => "铜", "chapter" => "1", "new" => "update"},
#  {"back" => "go fishing", "front" => "钓", "chapter" => "1", "new" => "update"},
#  {"back" => "needle", "front" => "针", "chapter" => "1", "new" => "update"},
#  {"back" => "nail", "front" => "钉", "chapter" => "1", "new" => "update"},
#  {"back" => "inscription", "front" => "铭", "chapter" => "1", "new" => "update"},
#  {"back" => "at ease", "front" => "镇", "chapter" => "1", "new" => "update"},
#  {"back" => "way", "front" => "道", "chapter" => "1", "new" => "update"},
#  {"back" => "reach", "front" => "达", "chapter" => "1", "new" => "update"},
#  {"back" => "distant", "front" => "远", "chapter" => "1", "new" => "update"},
#  {"back" => "suitable (less one drop) 适", "chapter" => "1", "new" => "update"},
#  {"back" => "cross", "front" => "过", "chapter" => "1", "new" => "update"},
#  {"back" => "stride", "front" => "迈", "chapter" => "1", "new" => "update"},
#  {"back" => "speedy", "front" => "讯", "chapter" => "1", "new" => "update"},
#  {"back" => "create", "front" => "造", "chapter" => "1", "new" => "update"},
#  {"back" => "escape", "front" => "逃", "chapter" => "1", "new" => "update"},
#  {"back" => "patrol", "front" => "巡", "chapter" => "1", "new" => "update"},
#  {"back" => "choose", "front" => "选", "chapter" => "1", "new" => "update"},
#  {"back" => "modest", "front" => "逊", "chapter" => "1", "new" => "update"},
#  {"back" => "stroll", "front" => "逛", "chapter" => "1", "new" => "update"},
#  {"back" => "car", "front" => "车", "chapter" => "1", "new" => "update"},
#  {"back" => "one after another", "front" => "连", "chapter" => "1", "new" => "update"},
#  {"back" => "lotus", "front" => "莲", "chapter" => "1", "new" => "update"},
#  {"back" => "in front", "front" => "前", "chapter" => "1", "new" => "update"},
#  {"back" => "shears", "front" => "剪", "chapter" => "1", "new" => "update"},
#  {"back" => "transport", "front" => "输", "chapter" => "1", "new" => "update"},
#  {"back" => "exceed", "front" => "谕", "chapter" => "1", "new" => "update"},
#  {"back" => "strip", "front" => "条", "chapter" => "1", "new" => "update"},
#  {"back" => "location", "front" => "处", "chapter" => "1", "new" => "update"},
#  {"back" => "each", "front" => "各", "chapter" => "1", "new" => "update"},
#  {"back" => "pattern", "front" => "格", "chapter" => "1", "new" => "update"},
#  {"back" => "abbreviation", "front" => "略", "chapter" => "1", "new" => "update"},
#  {"back" => "guest", "front" => "客", "chapter" => "1", "new" => "update"},
#  {"back" => "forehead", "front" => "额", "chapter" => "1", "new" => "update"},
#  {"back" => "summer", "front" => "夏", "chapter" => "1", "new" => "update"},
#  {"back" => "L.A.", "front" => "洛", "chapter" => "1", "new" => "update"},
#  {"back" => "fall", "front" => "落", "chapter" => "1", "new" => "update"},
#  {"back" => "prepare", "front" => "备", "chapter" => "1", "new" => "update"}
  ]
  
add_cards_to_forward_deck forward_deck, cards
add_cards_to_reverse_deck reverse_deck, cards


forward_deck = get_or_create_deck 'ACCS - Twers (reading practice)', user.id, true, false, 'front'
reverse_deck = get_or_create_deck 'ACCS - Twers (writing practice)', user.id, true, false, 'front'
typing_deck = get_or_create_deck 'ACCS - Twers (typing practice)', user.id, true, true, 'back'


cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1", "pronunciation" => "yī", "chapter" => "1", "new" => "update"},
  {"front" => "二", "back" => "2", "pronunciation" => "èr", "chapter" => "1", "new" => "update"},
  {"front" => "三", "back" => "3", "pronunciation" => "sān", "chapter" => "1", "new" => "update"},
  {"front" => "四", "back" => "4", "pronunciation" => "sì", "chapter" => "1", "new" => "update"},
  {"front" => "五", "back" => "5", "pronunciation" => "wŭ", "chapter" => "1", "new" => "update"},
  {"front" => "六", "back" => "6", "pronunciation" => "liù", "chapter" => "1", "new" => "update"},
  {"front" => "七", "back" => "7", "pronunciation" => "qī", "chapter" => "1", "new" => "update"},
  {"front" => "八", "back" => "8", "pronunciation" => "bā", "chapter" => "1", "new" => "update"},
  {"front" => "九", "back" => "9", "pronunciation" => "jiŭ", "chapter" => "1", "new" => "update"},
  {"front" => "十", "back" => "10", "pronunciation" => "shí", "chapter" => "1", "new" => "update"},
  {"front" => "女", "back" => "female", "pronunciation" => "nǚ", "chapter" => "1", "new" => "update"},
  {"front" => "安", "back" => "peace", "pronunciation" => "ān", "chapter" => "1", "new" => "update"},
  {"front" => "子", "back" => "child", "pronunciation" => "zǐ", "chapter" => "1", "new" => "update"},
  {"front" => "好", "back" => "good", "pronunciation" => "hăo", "chapter" => "1", "new" => "update"},
  {"front" => "人", "back" => "Man / mankind", "pronunciation" => "rén", "chapter" => "1", "new" => "update"},
  {"front" => "大", "back" => "big", "pronunciation" => "dà", "chapter" => "1", "new" => "update"},
  {"front" => "太", "back" => "excessive", "pronunciation" => "tài", "chapter" => "1", "new" => "update"},
  {"front" => "天", "back" => "sky", "pronunciation" => "tiān", "chapter" => "1", "new" => "update"},
  {"front" => "日", "back" => "sun", "pronunciation" => "rì", "chapter" => "1", "new" => "update"},
  {"front" => "月", "back" => "moon", "pronunciation" => "yuè", "chapter" => "1", "new" => "update"},
  {"front" => "明", "back" => "bright", "pronunciation" => "míng", "chapter" => "1", "new" => "update"},
  {"front" => "白", "back" => "clear", "pronunciation" => "bái", "chapter" => "1", "new" => "update"},
  {"front" => "明白", "back" => "understand", "pronunciation" => "míng bái", "chapter" => "1", "new" => "update"},
  {"front" => "晶", "back" => "crystal", "pronunciation" => "jīng", "chapter" => "1", "new" => "update"},
  {"front" => "旦", "back" => "dawn", "pronunciation" => "dàn", "chapter" => "1", "new" => "update"},
  {"front" => "字", "back" => "word", "pronunciation" => "zì", "chapter" => "1", "new" => "update"},
  {"front" => "早", "back" => "early", "pronunciation" => "zăo", "chapter" => "1", "new" => "update"},
  {"front" => "百", "back" => "hundred", "pronunciation" => "băi", "chapter" => "1", "new" => "update"},
  {"front" => "千", "back" => "thousand", "pronunciation" => "qiān", "chapter" => "1", "new" => "update"},
  {"front" => "万", "back" => "ten thousand", "pronunciation" => "wàn", "chapter" => "1", "new" => "update"},
  {"front" => "亿", "back" => "hundred million", "pronunciation" => "yì", "chapter" => "1", "new" => "update"},
  {"front" => "女人", "back" => "woman", "pronunciation" => "nǚ rén", "chapter" => "1", "new" => "update"},
  {"front" => "早安", "back" => "good morning", "pronunciation" => "zăo ān", "chapter" => "1", "new" => "update"},
  {"front" => "大人", "back" => "adult / big man", "pronunciation" => "dà rén", "chapter" => "1", "new" => "update"},
  {"front" => "太太", "back" => "Mrs", "pronunciation" => "tài tài", "chapter" => "1", "new" => "update"},
  {"front" => "白天", "back" => "daytime", "pronunciation" => "bái tiān", "chapter" => "1", "new" => "update"},
  {"front" => "明天", "back" => "tomorrow", "pronunciation" => "míng tiān", "chapter" => "1", "new" => "update"},
  {"front" => "天天", "back" => "everyday", "pronunciation" => "tiān tiān", "chapter" => "1", "new" => "update"},
  {"front" => "太大", "back" => "too big", "pronunciation" => "tài dà", "chapter" => "1", "new" => "update"},
  {"front" => "好人", "back" => "good person", "pronunciation" => "hăo rén", "chapter" => "1", "new" => "update"},
  {"front" => "零", "back" => "zero", "pronunciation" => "lìng", "chapter" => "1", "new" => "update"},
  #Lesson 2
  {"front" => "小", "back" => "small", "pronunciation" => "xiăo", "chapter" => "2", "new" => "update"},
  {"front" => "也", "back" => "also[adv]", "pronunciation" => "yĕ", "chapter" => "2", "new" => "update"},
  {"front" => "他", "back" => "he/him", "pronunciation" => "tā", "chapter" => "2", "new" => "update"},
  {"front" => "她", "back" => "she/her", "pronunciation" => "tā", "chapter" => "2", "new" => "update"},
  {"front" => "心", "back" => "heart", "pronunciation" => "xīn", "chapter" => "2", "new" => "update"},
  {"front" => "目", "back" => "eyes", "pronunciation" => "mù", "chapter" => "2", "new" => "update"},
  {"front" => "见", "back" => "see[v]", "pronunciation" => "jiàn", "chapter" => "2", "new" => "update"},
  {"front" => "门", "back" => "door", "pronunciation" => "mén", "chapter" => "2", "new" => "update"},
  {"front" => "们", "back" => "plural", "pronunciation" => "men", "chapter" => "2", "new" => "update"},
  {"front" => "人们", "back" => "people", "pronunciation" => "rén men", "chapter" => "2", "new" => "update"},
  {"front" => "手", "back" => "hand", "pronunciation" => "shǒu", "chapter" => "2", "new" => "update"},
  {"front" => "戈", "back" => "spear", "pronunciation" => "gē", "chapter" => "2", "new" => "update"},
  {"front" => "我", "back" => "I/me[pron]", "pronunciation" => "wǒ", "chapter" => "2", "new" => "update"},
  {"front" => "看", "back" => "look", "pronunciation" => "kàn", "chapter" => "2", "new" => "update"},
  {"front" => "你", "back" => "you", "pronunciation" => "nǐ", "chapter" => "2", "new" => "update"},
  {"front" => "不", "back" => "not[adj]", "pronunciation" => "bù", "chapter" => "2", "new" => "update"},
  {"front" => "了", "back" => "[a modal participle]", "pronunciation" => "le", "chapter" => "2", "new" => "update"},
  {"front" => "吗", "back" => "[an interrogative participle]", "pronunciation" => "ma", "chapter" => "2", "new" => "update"},
  {"front" => "很", "back" => "very[adv]", "pronunciation" => "hěn", "chapter" => "2", "new" => "update"},
  {"front" => "小心", "back" => "be careful", "pronunciation" => "xiăo xīn", "chapter" => "2", "new" => "update"},
  {"front" => "谢谢", "back" => "thank you[v]", "pronunciation" => "xiè xie", "chapter" => "2", "new" => "update"},
  {"front" => "问好", "back" => "to greet[v]; greeting[n]", "pronunciation" => "wèn hòu", "chapter" => "2", "new" => "update"},
  {"front" => "你好", "back" => "hello", "pronunciation" => "nǐ hǎo", "chapter" => "2", "new" => "update"},
  {"front" => "好久", "back" => "long time[adj]", "pronunciation" => "hǎo jiŭ", "chapter" => "2", "new" => "update"},
  {"front" => "心目", "back" => "mood, memory", "pronunciation" => "xīn mù", "chapter" => "2", "new" => "update"},
  {"front" => "安心", "back" => "feel at ease / not worried", "pronunciation" => "ān xīn", "chapter" => "2", "new" => "update"},
  {"front" => "好心人", "back" => "kind-hearted person", "pronunciation" => "hǎo xīn rén", "chapter" => "2", "new" => "update"},
  {"front" => "看见", "back" => "see", "pronunciation" => "kàn jiàn", "chapter" => "2", "new" => "update"},
  {"front" => "明天见", "back" => "see you tomorrow", "pronunciation" => "míng tiān jiàn", "chapter" => "2", "new" => "update"},
  {"front" => "太小", "back" => "too small", "pronunciation" => "tāi xiăo", "chapter" => "2", "new" => "update"},
  {"front" => "你们", "back" => "all of you", "pronunciation" => "nǐ men", "chapter" => "2", "new" => "update"},
  {"front" => "他们", "back" => "they / them", "pronunciation" => "tā men", "chapter" => "2", "new" => "update"},
  {"front" => "她们", "back" => "(female) they", "pronunciation" => "tā men", "chapter" => "2", "new" => "update"},
  {"front" => "我们", "back" => "we / us", "pronunciation" => "wǒ men", "chapter" => "2", "new" => "update"},
  {"front" => "你早", "back" => "good mornǐng", "pronunciation" => "nǐ zǎo", "chapter" => "2", "new" => "update"},
  {"front" => "你们好", "back" => "how do you do, hello", "pronunciation" => "nǐ men hǎo", "chapter" => "2", "new" => "update"},
  {"front" => "您好", "back" => "how do you do, hello (polite)", "pronunciation" => "nǐn hǎo", "chapter" => "2", "new" => "update"},
  {"front" => "好久不见了", "back" => "Long time no see", "pronunciation" => "hǎo jiǔ bú jiàn le", "chapter" => "2", "new" => "update"},
  {"front" => "你好吗？", "back" => "How are you?", "pronunciation" => "nǐ hǎo ma?", "chapter" => "2", "new" => "update"},
  {"front" => "我很好", "back" => "I am fine", "pronunciation" => "Wǒ hěn hǎo", "chapter" => "2", "new" => "update"},
  {"front" => "我也很好", "back" => "I'm also fine", "pronunciation" => "Wǒ yě hěn hǎo", "chapter" => "2", "new" => "update"},
  {"front" => "你太太好吗", "back" => "How is your wife?", "pronunciation" => "nǐ tāi tāi hǎo ma?", "chapter" => "2", "new" => "update"},
  {"front" => "她也很好", "back" => "She is also fine", "pronunciation" => "tā yě hěn hǎo", "chapter" => "2", "new" => "update"},

  #Lesson 3
  {"front" => "开", "back" => "opens", "pronunciation" => "kāi", "chapter" => "3", "new" => "update"},
  {"front" => "口", "back" => "mouth", "pronunciation" => "kǒu", "chapter" => "3", "new" => "update"},
  {"front" => "叫", "back" => "to call", "pronunciation" => "jiào [v]", "chapter" => "3", "new" => "update"},
  {"front" => "马", "back" => "horse", "pronunciation" => "mǎ", "chapter" => "3", "new" => "update"},
  {"front" => "闯", "back" => "rush", "pronunciation" => "chuǎng", "chapter" => "3", "new" => "update"},
  {"front" => "问", "back" => "to ask[v]", "pronunciation" => "wèn", "chapter" => "3", "new" => "update"},
  {"front" => "妈", "back" => "mother", "pronunciation" => "mā", "chapter" => "3", "new" => "update"},
  {"front" => "唱", "back" => "sings", "pronunciation" => "chàng", "chapter" => "3", "new" => "update"},
  {"front" => "门口", "back" => "passage way", "pronunciation" => "mén kǒu", "chapter" => "3", "new" => "update"},
  {"front" => "大门", "back" => "front door", "pronunciation" => "dà mén", "chapter" => "3", "new" => "update"},
  {"front" => "开门", "back" => "open the door", "pronunciation" => "kāi mén", "chapter" => "3", "new" => "update"},
  {"front" => "开口", "back" => "open one's mouth to speak", "pronunciation" => "kāi kǒu", "chapter" => "3", "new" => "update"},
  {"front" => "开心", "back" => "feel happy", "pronunciation" => "kāi xīn", "chapter" => "3", "new" => "update"},
  {"front" => "请问", "back" => "excuse me， may I ask", "pronunciation" => "qǐng wèn", "chapter" => "3", "new" => "update"},
  {"front" => "问题", "back" => "question  / problem", "pronunciation" => "wèn tí", "chapter" => "3", "new" => "update"},
  {"front" => "吗上", "back" => "at once", "pronunciation" => "mǎ shàng", "chapter" => "3", "new" => "update"},
  {"front" => "妈妈", "back" => "mother", "pronunciation" => "māma", "chapter" => "3", "new" => "update"},
  {"front" => "大妈", "back" => "aunty", "pronunciation" => "dà mā", "chapter" => "3", "new" => "update"},
  {"front" => "人口", "back" => "population", "pronunciation" => "rén kǒu", "chapter" => "3", "new" => "update"},
  {"front" => "入口", "back" => "entrance", "pronunciation" => "rù kǒu", "chapter" => "3", "new" => "update"},
  {"front" => "出口", "back" => "exit;export", "pronunciation" => "chū kǒu", "chapter" => "3", "new" => "update"},
  {"front" => "进口", "back" => "entrance;import", "pronunciation" => "jìn kǒu", "chapter" => "3", "new" => "update"},
  {"front" => "姓名", "back" => "fullname [n.]", "pronunciation" => "xìng míng", "chapter" => "3", "new" => "update"},
  {"front" => "贵姓", "back" => "Your honourable surname", "pronunciation" => "guì xìng", "chapter" => "3", "new" => "update"},
  {"front" => "姓", "back" => "surname[v;n]", "pronunciation" => "xìng", "chapter" => "3", "new" => "update"},
  {"front" => "什么", "back" => "what[pron]", "pronunciation" => "shén me", "chapter" => "3", "new" => "update"},
  {"front" => "名字", "back" => "name[n]", "pronunciation" => "míng zi", "chapter" => "3", "new" => "update"},
  {"front" => "见到", "back" => "to see; to have seen", "pronunciation" => "jiàn dào", "chapter" => "3", "new" => "update"},
  {"front" => "您", "back" => "you(polite)", "pronunciation" => "nín", "chapter" => "3", "new" => "update"},
  {"front" => "高兴", "back" => "happy glad[adj]", "pronunciation" => "gāo xìng", "chapter" => "3", "new" => "update"},
  {"front" => "请问， 您贵姓", "back" => "Excuse me, may I know your surname?", "pronunciation" => "qǐng wèn, nín guì xìng", "chapter" => "3", "new" => "update"},
  {"front" => "我姓...， 叫...", "back" => "My surname is ..., my given name is ...", "pronunciation" => "míng, wǒ xìng ?, jiào ?", "chapter" => "3", "new" => "no"},
  {"front" => "您叫什么名字", "back" => "What is your name?", "pronunciation" => "nín jiào shén me míng zi", "chapter" => "3", "new" => "update"},
  {"front" => "我叫。。。", "back" => "My name is...", "pronunciation" => "wǒ jiào...", "chapter" => "3", "new" => "update"},
  {"front" => "见到您， 我很高兴。", "back" => "I am pleased to meet you.", "pronunciation" => "jiàn dào nín, wǒ hěn gāo xìng", "chapter" => "3", "new" => "update"},
  {"front" => "见到您， 我也很高兴。", "back" => "I am also please to meet you.", "pronunciation" => "jiàn dào nín, wǒ yě hěn gāo xìng", "chapter" => "3", "new" => "update"}

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