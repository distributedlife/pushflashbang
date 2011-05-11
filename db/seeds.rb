# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

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

forward_deck = Deck.where(:name => 'Simplified Hanzi to English (reading)', :user_id => user.id)
reverse_deck = Deck.where(:name => 'English to Simplified Hanzi (writing)', :user_id => user.id)
if forward_deck.empty?
  forward_deck = Deck.new(:name => 'Simplified Hanzi to English (reading)', :shared => true)
  forward_deck.user = user
  forward_deck.save!
else
  forward_deck = forward_deck.first
end
if reverse_deck.empty?
  reverse_deck = Deck.new(:name => 'English to Simplified Hanzi (writing)', :shared => true)
  reverse_deck.user = user
  reverse_deck.save!
else
  reverse_deck = reverse_deck.first
end

cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1 / (floor, ceiling)"},
  {"front" => "二", "back" => "2"},
  {"front" => "三", "back" => "3"},
  {"front" => "四", "back" => "4"},
  {"front" => "五", "back" => "5"},
  {"front" => "六", "back" => "6"},
  {"front" => "七", "back" => "7 / (diced)"},
  {"front" => "八", "back" => "8"},
  {"front" => "九", "back" => "9 / (baseball)"},
  {"front" => "十", "back" => "10"},
  {"front" => "目", "back" => "eye"},
  {"front" => "月", "back" => "month / (moon, flesh, part of body)"},
  {"front" => "口", "back" => "mouth"},
  {"front" => "田", "back" => "rice field / (brains)"},
  {"front" => "日", "back" => "day / (sun, tonque wagging)"},
  #Lesson 2
  {"front" => "古", "back" => "ancient"},
  {"front" => "胡", "back" => "recklessly"},
  {"front" => "叶", "back" => "leaf"},
  {"front" => "吾", "back" => "I (literary)"},
  {"front" => "朋", "back" => "companion"},
  {"front" => "明", "back" => "bright"},
  {"front" => "唱", "back" => "sing"},
  {"front" => "晶", "back" => "sparkling"},
  {"front" => "品", "back" => "goods"},
  {"front" => "昌", "back" => "prosperous"},
  {"front" => "早", "back" => "early / (sunflower)"},
  {"front" => "旭", "back" => "rising sun"},
  {"front" => "世", "back" => "generation"},
  {"front" => "胃", "back" => "stomach"},
  {"front" => "旦", "back" => "daybreak"},
  {"front" => "凹", "back" => "concave"},
  {"front" => "凸", "back" => "convex"},
  #Lesson 3
  {"front" => "自", "back" => "oneself / (nose)"},
  {"front" => "白", "back" => "white"},
  {"front" => "百", "back" => "hundred"},
  {"front" => "皂", "back" => "soap"},
  {"front" => "旧", "back" => "old"},
  {"front" => "中", "back" => "middle [n/adj]"},
  {"front" => "千", "back" => "thousand"},
  {"front" => "舌", "back" => "tonque"},
  {"front" => "升", "back" => "litre"},
  {"front" => "丸", "back" => "pill / (bottle of pills)"},
  {"front" => "卜", "back" => "divination / (divining rod / magic wand)"},
  {"front" => "占", "back" => "tell fortunes"},
  {"front" => "上", "back" => "above"},
  {"front" => "下", "back" => "below"},
  {"front" => "卡", "back" => "card"},
  {"front" => "卓", "back" => "eminent"},
  {"front" => "朝", "back" => "dynasty"},
  {"front" => "嘲", "back" => "ridicule [v]"},
  #Lesson 4
  {"front" => "只", "back" => "only"},
  {"front" => "贝", "back" => "shellfish"},
  {"front" => "贴", "back" => "paste [v]"},
  {"front" => "贞", "back" => "chaste"},
  {"front" => "员", "back" => "employee"},
  {"front" => "儿", "back" => "youngster / (human legs)"},
  {"front" => "几", "back" => "how many? / (wind / small table)"},
  {"front" => "见", "back" => "see"},
  {"front" => "元", "back" => "beginning"},
  {"front" => "页", "back" => "page / (head)"},
  {"front" => "顽", "back" => "stubborn"},
  {"front" => "凡", "back" => "ordinary"},
  {"front" => "肌", "back" => "muscle"},
  {"front" => "负", "back" => "defeated [adj]"},
  {"front" => "万", "back" => "ten thousand"},
  {"front" => "匀", "back" => "uniform [adj]"},
  {"front" => "句", "back" => "sentence [n]"},
  {"front" => "旬", "back" => "decameron"},
  {"front" => "勺", "back" => "ladle"},
  {"front" => "的", "back" => "bull's eye"},
  {"front" => "首", "back" => "heads"},

  #Lesson 5
  {"front" => "直", "back" => "straight"},
  {"front" => "置", "back" => "setup"},
  {"front" => "具", "back" => "tool"},
  {"front" => "真", "back" => "true"},
  {"front" => "工", "back" => "work [n]"},
  {"front" => "左", "back" => "left [n/adj]"},
  {"front" => "右", "back" => "right [n/adj]"},
  {"front" => "有", "back" => "possess"},
  {"front" => "贿", "back" => "bribe [n]"},
  {"front" => "贡", "back" => "tribute"},
  {"front" => "项", "back" => "item"},
  {"front" => "刀", "back" => "sword (dagger / saber)"},
  {"front" => "仞", "back" => "blade"},
  {"front" => "切", "back" => "cut [v]"},
  {"front" => "召", "back" => "summon"},
  {"front" => "昭", "back" => "evident"},
  {"front" => "则", "back" => "rule [n]"},
  {"front" => "副", "back" => "vice-"},
  {"front" => "丁", "back" => "fourth (nail / spike)"},
  {"front" => "叮", "back" => "sting [v]"},
  {"front" => "可", "back" => "can [ad.v]"},
  {"front" => "哥", "back" => "older brother"},
  {"front" => "顶", "back" => "crest"}

  #Lesson 6
#  {"back" => "second", "front" => "乙"},
#  {"back" => "fly", "front" => "飞"},
#  {"back" => "child", "front" => "子"},
#  {"back" => "cavity", "front" => "孔"},
#  {"back" => "roar", "front" => "吼"},
#  {"back" => "chaos", "front" => "乱"},
#  {"back" => "(-ed)", "front" => "了"},
#  {"back" => "woman", "front" => "奴(left only）"},
#  {"back" => "good", "front" => "好"},
#  {"back" => "be like", "front" => "如"},
#  {"back" => "mother", "front" => "母"},
#  {"back" => "pierce", "front" => "贯"},
#  {"back" => "elder brother", "front" => "兄"},
#  {"back" => "overcome", "front" => "克"},
#  {"back" => "small", "front" => "小"},
#  {"back" => "few", "front" => "少"},
#  {"back" => "noisy", "front" => "吵"},
#  {"back" => "grandchild", "front" => "孙"},
#  {"back" => "large", "front" => "大"},
#  {"back" => "tip", "front" => "尖"},
#  {"back" => "evening", "front" => "夕"},
#  {"back" => "many", "front" => "多"},
#  {"back" => "enough", "front" => "够"},
#  {"back" => "outside", "front" => "外"},
#  {"back" => "name", "front" => "名"},
#  {"back" => "silk gauze", "front" => "罗"},
#  {"back" => "factory", "front" => "厂"},
#  {"back" => "hall", "front" => "厅"},
#  {"back" => "stern", "front" => "历"},
#  {"back" => "thick", "front" => "厚"},
#  {"back" => "stone", "front" => "石"},
#  {"back" => "gravel", "front" => "砂"},
#  {"back" => "wonderful", "front" => "秒"},
#  {"back" => "resemble", "front" => "肖"},
#  {"back" => "peel", "front" => "削"},
#  {"back" => "ray", "front" => "光"},
#  {"back" => "overly", "front" => "太"},
#  {"back" => "economise", "front" => "省"},
#  {"back" => "strange", "front" => "奇"},
#  {"back" => "stream", "front" => "川"},
#  {"back" => "state", "front" => "州"},
#  {"back" => "obey", "front" => "顺"},
#  {"back" => "water", "front" => "水"},
#  {"back" => "eternity", "front" => "永"},
#  {"back" => "blood vessels", "front" => "脉"},
#  {"back" => "request", "front" => "求"},
#  {"back" => "spring", "front" => "泉"},
#  {"back" => "flatlands", "front" => "原"},
#  {"back" => "swim", "front" => "泳"},
#  {"back" => "continent", "front" => "洲"},
#  {"back" => "marsh", "front" => "沼"},
#  {"back" => "sand", "front" => "沙"},
#  {"back" => "Yangtze", "front" => "江"},
#  {"back" => "juice", "front" => "汁"},
#  {"back" => "tide", "front" => "潮"},
#  {"back" => "source", "front" => "源"},
#  {"back" => "extinguish", "front" => "消"},
#  {"back" => "river", "front" => "河"},
#  {"back" => "fish", "front" => "鱼"},
#  {"back" => "fishing", "front" => "渔"},
#  {"back" => "lake", "front" => "湖"},
#  {"back" => "fathom", "front" => "测"},
#  {"back" => "soil", "front" => "土"},
#  {"back" => "equal", "front" => "均"},
#  {"back" => "belly", "front" => "肚"},
#  {"back" => "dust", "front" => "尘"},
#  {"back" => "fill in", "front" => "填"},
#  {"back" => "spit", "front" => "吐"},
#  {"back" => "pressure", "front" => "压"},
#  {"back" => "waaah!", "front" => "哇"},
#  {"back" => "Chinese inch", "front" => "寸"},
#  {"back" => "seal", "front" => "封"},
#  {"back" => "time", "front" => "时"},
#  {"back" => "Buddhist temple", "front" => "寺"},
#  {"back" => "fire", "front" => "火"},
#  {"back" => "destroy", "front" => "灭"},
#  {"back" => "ashes", "front" => "灰"},
#  {"back" => "vexed", "front" => "烦"},
#  {"back" => "inflammation", "front" => "炎"},
#  {"back" => "thin", "front" => "淡"},
#  {"back" => "lamp", "front" => "灯"},
#  {"back" => "spot", "front" => "点"},
#  {"back" => "illuminate", "front" => "照"},
#  {"back" => "li (about 500m)", "front" => "里"},
#  {"back" => "quantity", "front" => "量"},
#  {"back" => "bury", "front" => "埋"},
#  {"back" => "black", "front" => "黑"},
#  {"back" => "black ink", "front" => "墨"},
#  {"back" => "risk", "front" => "冒"},
#  {"back" => "same", "front" => "同"},
#  {"back" => "cave", "front" => "洞"},
#  {"back" => "lovely", "front" => "丽"},
#  {"back" => "orientation", "front" => "向"},
#  {"back" => "echo", "front" => "响"},
#  {"back" => "esteem", "front" => "尚"},
#  {"back" => "character", "front" => "字"},
#  {"back" => "guard", "front" => "守"},
#  {"back" => "finish", "front" => "完"},
#  {"back" => "disaster", "front" => "灾"},
#  {"back" => "proclaim", "front" => "宣"},
#  {"back" => "nighttime", "front" => "宵"},
#  {"back" => "peaceful", "front" => "安"},
#  {"back" => "banquet", "front" => "宴"},
#  {"back" => "mail", "front" => "寄"},
#  {"back" => "wealthy", "front" => "富"},
#  {"back" => "store up", "front" => "贮"},
#  {"back" => "tree", "front" => "木"},
#  {"back" => "woods", "front" => "林"},
#  {"back" => "forest", "front" => "森"},
#  {"back" => "dreams", "front" => "梦"},
#  {"back" => "machine", "front" => "机"},
#  {"back" => "plant", "front" => "值"},
#  {"back" => "apricot", "front" => "杏"},
#  {"back" => "dim-witted", "front" => "呆"},
#  {"back" => "withered", "front" => "枯"},
#  {"back" => "village", "front" => "忖"},
#  {"back" => "one another", "front" => "相"},
#  {"back" => "notebook", "front" => "本"},
#  {"back" => "case", "front" => "案"},
#  {"back" => "not yet", "front" => "未"},
#  {"back" => "last", "front" => "末"},
#  {"back" => "foam", "front" => "沫"},
#  {"back" => "flavour", "front" => "味"},
#  {"back" => "younger sister", "front" => "妹"},
#  {"back" => "investigate", "front" => "查"},
#  {"back" => "sediment", "front" => "渣"},
#  {"back" => "dye", "front" => "染"},
#  {"back" => "plum", "front" => "李"},
#  {"back" => "table", "front" => "桌"},
#  {"back" => "miscellaneous", "front" => "杂"},
#  {"back" => "as if", "front" => "若"},
#  {"back" => "grass", "front" => "草"},
#  {"back" => "technique", "front" => "艺"},
#  {"back" => "suffering", "front" => "苦"},
#  {"back" => "wide", "front" => "宽"},
#  {"back" => "nobody", "front" => "莫"},
#  {"back" => "imitate", "front" => "摸"},
#  {"back" => "desert", "front" => "漠"},
#  {"back" => "grave", "front" => "幕"},
#  {"back" => "seedling", "front" => "苗"},
#  {"back" => "aim", "front" => "瞄"},
#  {"back" => "portent", "front" => "兆"},
#  {"back" => "peach", "front" => "桃"},
#  {"back" => "pooch", "front" => "犬"},
#  {"back" => "remarkable", "front" => "尤"},
#  {"back" => "detest", "front" => "厌"},
#  {"back" => "state of affairs", "front" => "状"},
#  {"back" => "put on makeup", "front" => "妆"},
#  {"back" => "general (military rank)", "front" => "将"},
#  {"back" => "seize", "front" => "获"},
#  {"back" => "silent", "front" => "默"},
#  {"back" => "sort of thing", "front" => "然"},
#  {"back" => "cry", "front" => "哭"},
#  {"back" => "utensil", "front" => "器"},
#  {"back" => "stinking (with drop）臭"},
#  {"back" => "dog", "front" => "狗"},
#  {"back" => "cow", "front" => "牛"},
#  {"back" => "special", "front" => "特"},
#  {"back" => "declare", "front" => "告"},
#  {"back" => "vast", "front" => "浩"},
#  {"back" => "before", "front" => "先"},
#  {"back" => "wash", "front" => "洗"},
#  {"back" => "individual", "front" => "个"},
#  {"back" => "introduce", "front" => "介"},
#  {"back" => "world", "front" => "界"},
#  {"back" => "tea", "front" => "茶"},
#  {"back" => "fit", "front" => "合"},
#  {"back" => "ha!", "front" => "哈"},
#  {"back" => "pagoda", "front" => "塔"},
#  {"back" => "king", "front" => "王"},
#  {"back" => "jade", "front" => "玉"},
#  {"back" => "treasure", "front" => "宝"},
#  {"back" => "ball", "front" => "球"},
#  {"back" => "present", "front" => "现"},
#  {"back" => "play", "front" => "玩"},
#  {"back" => "crazy", "front" => "狂"},
#  {"back" => "emperor", "front" => "皇"},
#  {"back" => "resplendent", "front" => "煌"},
#  {"back" => "submit", "front" => "呈"},
#  {"back" => "whole", "front" => "全"},
#  {"back" => "logic", "front" => "理"},
#  {"back" => "lord", "front" => "主"},
#  {"back" => "pour", "front" => "住"},
#  {"back" => "gold", "front" => "金"},
#  {"back" => "bell", "front" => "钟"},
#  {"back" => "copper", "front" => "铜"},
#  {"back" => "go fishing", "front" => "钓"},
#  {"back" => "needle", "front" => "针"},
#  {"back" => "nail", "front" => "钉"},
#  {"back" => "inscription", "front" => "铭"},
#  {"back" => "at ease", "front" => "镇"},
#  {"back" => "way", "front" => "道"},
#  {"back" => "reach", "front" => "达"},
#  {"back" => "distant", "front" => "远"},
#  {"back" => "suitable (less one drop) 适"},
#  {"back" => "cross", "front" => "过"},
#  {"back" => "stride", "front" => "迈"},
#  {"back" => "speedy", "front" => "讯"},
#  {"back" => "create", "front" => "造"},
#  {"back" => "escape", "front" => "逃"},
#  {"back" => "patrol", "front" => "巡"},
#  {"back" => "choose", "front" => "选"},
#  {"back" => "modest", "front" => "逊"},
#  {"back" => "stroll", "front" => "逛"},
#  {"back" => "car", "front" => "车"},
#  {"back" => "one after another", "front" => "连"},
#  {"back" => "lotus", "front" => "莲"},
#  {"back" => "in front", "front" => "前"},
#  {"back" => "shears", "front" => "剪"},
#  {"back" => "transport", "front" => "输"},
#  {"back" => "exceed", "front" => "谕"},
#  {"back" => "strip", "front" => "条"},
#  {"back" => "location", "front" => "处"},
#  {"back" => "each", "front" => "各"},
#  {"back" => "pattern", "front" => "格"},
#  {"back" => "abbreviation", "front" => "略"},
#  {"back" => "guest", "front" => "客"},
#  {"back" => "forehead", "front" => "额"},
#  {"back" => "summer", "front" => "夏"},
#  {"back" => "L.A.", "front" => "洛"},
#  {"back" => "fall", "front" => "落"},
#  {"back" => "prepare", "front" => "备"}
  ]

cards.each do |card|
  exists = Card.where(:front => card["front"], :deck_id => forward_deck.id)
  if exists.empty?
    card = Card.new(:front => card["front"], :back => card["back"], :pronunciation => card["pronunciation"])
    card.deck = forward_deck
    card.save!
  else
    exists.first.back = card["back"]
    exists.first.pronunciation = card["pronunciation"]
    exists.first.save!
  end
end

cards.each do |card|
  exists = Card.where(:front => card["back"], :deck_id => reverse_deck.id)
  if exists.empty?
    card = Card.new(:front => card["back"], :back => card["front"], :pronunciation => card["pronunciation"])
    card.deck = reverse_deck
    card.save!
  else
    exists.first.back = card["front"]
    exists.first.pronunciation = card["pronunciation"]
    exists.first.save!
  end
end





forward_deck = Deck.where(:name => 'ACCS - Twers (reading practice)', :user_id => user.id)
reverse_deck = Deck.where(:name => 'ACCS - Twers (writing practice)', :user_id => user.id)
typing_deck = Deck.where(:name => 'ACCS - Twers (typing practice)', :user_id => user.id)
if forward_deck.empty?
  forward_deck = Deck.new(:name => 'ACCS - Twers (reading practice)', :shared => true)
  forward_deck.user = user
  forward_deck.save!
else
  forward_deck = forward_deck.first
end
if reverse_deck.empty?
  reverse_deck = Deck.new(:name => 'ACCS - Twers (writing practice)', :shared => true)
  reverse_deck.user = user
  reverse_deck.save!
else
  reverse_deck = reverse_deck.first
end
if typing_deck.empty?
  typing_deck = Deck.new(:name => 'ACCS - Twers (typing practice)', :shared => true, :supports_written_answer => true, :pronunciation_side => 'back')
  typing_deck.user = user
  typing_deck.save!
else
  typing_deck = typing_deck.first
end

cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1", "pronunciation" => "yī", "new" => "no"},
  {"front" => "二", "back" => "2", "pronunciation" => "èr", "new" => "no"},
  {"front" => "三", "back" => "3", "pronunciation" => "sān", "new" => "no"},
  {"front" => "四", "back" => "4", "pronunciation" => "sì", "new" => "no"},
  {"front" => "五", "back" => "5", "pronunciation" => "wŭ", "new" => "no"},
  {"front" => "六", "back" => "6", "pronunciation" => "liù", "new" => "no"},
  {"front" => "七", "back" => "7", "pronunciation" => "qī", "new" => "no"},
  {"front" => "八", "back" => "8", "pronunciation" => "bā", "new" => "no"},
  {"front" => "九", "back" => "9", "pronunciation" => "jiŭ", "new" => "no"},
  {"front" => "十", "back" => "10", "pronunciation" => "shí", "new" => "no"},
  {"front" => "女", "back" => "female", "pronunciation" => "nǚ", "new" => "no"},
  {"front" => "安", "back" => "peace", "pronunciation" => "ān", "new" => "no"},
  {"front" => "子", "back" => "child", "pronunciation" => "zǐ", "new" => "no"},
  {"front" => "好", "back" => "good", "pronunciation" => "hăo", "new" => "no"},
  {"front" => "人", "back" => "Man / mankind", "pronunciation" => "rén", "new" => "no"},
  {"front" => "大", "back" => "big", "pronunciation" => "dà", "new" => "no"},
  {"front" => "太", "back" => "excessive", "pronunciation" => "tài", "new" => "no"},
  {"front" => "天", "back" => "sky", "pronunciation" => "tiān", "new" => "no"},
  {"front" => "日", "back" => "sun", "pronunciation" => "rì", "new" => "no"},
  {"front" => "月", "back" => "moon", "pronunciation" => "yuè", "new" => "no"},
  {"front" => "明", "back" => "bright", "pronunciation" => "míng", "new" => "no"},
  {"front" => "白", "back" => "clear", "pronunciation" => "bái", "new" => "no"},
  {"front" => "明白", "back" => "understand", "pronunciation" => "míng bái", "new" => "no"},
  {"front" => "晶", "back" => "crystal", "pronunciation" => "jīng", "new" => "no"},
  {"front" => "旦", "back" => "dawn", "pronunciation" => "dàn", "new" => "no"},
  {"front" => "字", "back" => "word", "pronunciation" => "zì", "new" => "no"},
  {"front" => "早", "back" => "early", "pronunciation" => "zăo", "new" => "no"},
  {"front" => "百", "back" => "hundred", "pronunciation" => "băi", "new" => "no"},
  {"front" => "千", "back" => "thousand", "pronunciation" => "qiān", "new" => "no"},
  {"front" => "万", "back" => "ten thousand", "pronunciation" => "wàn", "new" => "no"},
  {"front" => "亿", "back" => "hundred million", "pronunciation" => "yì", "new" => "no"},
  {"front" => "女人", "back" => "woman", "pronunciation" => "nǚ rén", "new" => "no"},
  {"front" => "早安", "back" => "good morning", "pronunciation" => "zăo ān", "new" => "no"},
  {"front" => "大人", "back" => "adult / big man", "pronunciation" => "dà rén", "new" => "no"},
  {"front" => "太太", "back" => "Mrs", "pronunciation" => "tài tài", "new" => "no"},
  {"front" => "白天", "back" => "daytime", "pronunciation" => "bái tiān", "new" => "no"},
  {"front" => "明天", "back" => "tomorrow", "pronunciation" => "míng tiān", "new" => "no"},
  {"front" => "天天", "back" => "everyday", "pronunciation" => "tiān tiān", "new" => "no"},
  {"front" => "太大", "back" => "too big", "pronunciation" => "tài dà", "new" => "no"},
  {"front" => "好人", "back" => "good person", "pronunciation" => "hăo rén", "new" => "no"},
  {"front" => "零", "back" => "zero", "pronunciation" => "lìng", "new" => "no"},
  #Lesson 2
  {"front" => "小", "back" => "small", "pronunciation" => "xiăo", "new" => "no"},
  {"front" => "也", "back" => "also[adv]", "pronunciation" => "yĕ", "new" => "no"},
  {"front" => "他", "back" => "he/him", "pronunciation" => "tā", "new" => "no"},
  {"front" => "她", "back" => "she/her", "pronunciation" => "tā", "new" => "no"},
  {"front" => "心", "back" => "heart", "pronunciation" => "xīn", "new" => "no"},
  {"front" => "目", "back" => "eyes", "pronunciation" => "mù", "new" => "no"},
  {"front" => "见", "back" => "see[v]", "pronunciation" => "jiàn", "new" => "no"},
  {"front" => "门", "back" => "door", "pronunciation" => "mén", "new" => "no"},
  {"front" => "们", "back" => "plural", "pronunciation" => "men", "new" => "no"},
  {"front" => "人们", "back" => "people", "pronunciation" => "rén men", "new" => "no"},
  {"front" => "手", "back" => "hand", "pronunciation" => "shǒu", "new" => "no"},
  {"front" => "戈", "back" => "spear", "pronunciation" => "gē", "new" => "no"},
  {"front" => "我", "back" => "I/me[pron]", "pronunciation" => "wǒ", "new" => "no"},
  {"front" => "看", "back" => "look", "pronunciation" => "kàn", "new" => "no"},
  {"front" => "你", "back" => "you", "pronunciation" => "nǐ", "new" => "no"},
  {"front" => "不", "back" => "not[adj]", "pronunciation" => "bù", "new" => "no"},
  {"front" => "了", "back" => "[a modal participle]", "pronunciation" => "le", "new" => "no"},
  {"front" => "吗", "back" => "[an interrogative participle]", "pronunciation" => "ma", "new" => "no"},
  {"front" => "很", "back" => "very[adv]", "pronunciation" => "hěn", "new" => "no"},
  {"front" => "小心", "back" => "be careful", "pronunciation" => "xiăo xīn", "new" => "no"},
  {"front" => "谢谢", "back" => "thank you[v]", "pronunciation" => "xiè xie", "new" => "no"},
  {"front" => "问好", "back" => "to greet[v]; greeting[n]", "pronunciation" => "wèn hòu", "new" => "no"},
  {"front" => "你好", "back" => "hello", "pronunciation" => "nǐ hǎo", "new" => "no"},
  {"front" => "好久", "back" => "long time[adj]", "pronunciation" => "hǎo jiŭ", "new" => "no"},
  {"front" => "心目", "back" => "mood, memory", "pronunciation" => "xīn mù", "new" => "no"},
  {"front" => "安心", "back" => "feel at ease / not worried", "pronunciation" => "ān xīn", "new" => "no"},
  {"front" => "好心人", "back" => "kind-hearted person", "pronunciation" => "hǎo xīn rén", "new" => "no"},
  {"front" => "看见", "back" => "see", "pronunciation" => "kàn jiàn", "new" => "no"},
  {"front" => "明天见", "back" => "see you tomorrow", "pronunciation" => "míng tiān jiàn", "new" => "no"},
  {"front" => "太小", "back" => "too small", "pronunciation" => "tāi xiăo", "new" => "no"},
  {"front" => "你们", "back" => "all of you", "pronunciation" => "nǐ men", "new" => "no"},
  {"front" => "他们", "back" => "they / them", "pronunciation" => "tā men", "new" => "no"},
  {"front" => "她们", "back" => "(female) they", "pronunciation" => "tā men", "new" => "no"},
  {"front" => "我们", "back" => "we / us", "pronunciation" => "wǒ men", "new" => "no"},
  {"front" => "你早", "back" => "good mornǐng", "pronunciation" => "nǐ zǎo", "new" => "no"},
  {"front" => "你们好", "back" => "how do you do, hello", "pronunciation" => "nǐ men hǎo", "new" => "no"},
  {"front" => "您好", "back" => "how do you do, hello (polite)", "pronunciation" => "nǐn hǎo", "new" => "no"},
  {"front" => "好久不见了", "back" => "Long time no see", "pronunciation" => "hǎo jiǔ bú jiàn le", "new" => "no"},
  {"front" => "你好吗？", "back" => "How are you?", "pronunciation" => "nǐ hǎo ma?", "new" => "no"},
  {"front" => "我很好", "back" => "I am fine", "pronunciation" => "Wǒ hěn hǎo", "new" => "no"},
  {"front" => "我也很好", "back" => "I'm also fine", "pronunciation" => "Wǒ yě hěn hǎo", "new" => "no"},
  {"front" => "她太太好吗", "back" => "How is your wife?", "pronunciation" => "nǐ tāi tāi hǎo ma?", "new" => "no"},
  {"front" => "她也很好", "back" => "She is also fine", "pronunciation" => "tā yě hěn hǎo", "new" => "no"},

  #Lesson 3
  {"front" => "开", "back" => "opens", "pronunciation" => "kāi", "new" => "yes"},
  {"front" => "口", "back" => "mouth", "pronunciation" => "kǒu", "new" => "yes"},
  {"front" => "叫", "back" => "to call", "pronunciation" => "jiào [v]", "new" => "yes"},
  {"front" => "马", "back" => "horse", "pronunciation" => "mǎ", "new" => "yes"},
  {"front" => "闯", "back" => "rush", "pronunciation" => "chuǎng", "new" => "yes"},
  {"front" => "问", "back" => "to ask[v]", "pronunciation" => "wèn", "new" => "yes"},
  {"front" => "妈", "back" => "mother", "pronunciation" => "mā", "new" => "yes"},
  {"front" => "唱", "back" => "sings", "pronunciation" => "chàng", "new" => "yes"},
  {"front" => "门口", "back" => "passage way", "pronunciation" => "mén kǒu", "new" => "yes"},
  {"front" => "大门", "back" => "front door", "pronunciation" => "dà mén", "new" => "yes"},
  {"front" => "开门", "back" => "open the door", "pronunciation" => "kāi mén", "new" => "yes"},
  {"front" => "开口", "back" => "open one's mouth to speak", "pronunciation" => "kāi kǒu", "new" => "yes"},
  {"front" => "开心", "back" => "feel happy", "pronunciation" => "kāi xīn", "new" => "yes"},
  {"front" => "请问", "back" => "excuse me， may I ask", "pronunciation" => "qǐng wèn", "new" => "yes"},
  {"front" => "问题", "back" => "question  / problem", "pronunciation" => "wèn tí", "new" => "yes"},
  {"front" => "吗上", "back" => "at once", "pronunciation" => "mǎ shàng", "new" => "yes"},
  {"front" => "妈妈", "back" => "mother", "pronunciation" => "māma", "new" => "yes"},
  {"front" => "大妈", "back" => "aunty", "pronunciation" => "dà mā", "new" => "yes"},
  {"front" => "人口", "back" => "population", "pronunciation" => "rén kǒu", "new" => "yes"},
  {"front" => "入口", "back" => "entrance", "pronunciation" => "rù kǒu", "new" => "yes"},
  {"front" => "出口", "back" => "exit;export", "pronunciation" => "chū kǒu", "new" => "yes"},
  {"front" => "进口", "back" => "entrance;import", "pronunciation" => "jìn kǒu", "new" => "yes"},
  {"front" => "姓名", "back" => "fullname [n.]", "pronunciation" => "xìng míng", "new" => "yes"},
  {"front" => "贵姓", "back" => "Your honourable surname", "pronunciation" => "guì xìng", "new" => "yes"},
  {"front" => "姓", "back" => "surname[v;n]", "pronunciation" => "xìng", "new" => "yes"},
  {"front" => "什么", "back" => "what[pron]", "pronunciation" => "shén me", "new" => "yes"},
  {"front" => "名字", "back" => "name[n]", "pronunciation" => "míng zi", "new" => "yes"},
  {"front" => "见到", "back" => "to see; to have seen", "pronunciation" => "jiàn dào", "new" => "yes"},
  {"front" => "您", "back" => "you(polite)", "pronunciation" => "nín", "new" => "yes"},
  {"front" => "高兴", "back" => "happy glad[adj]", "pronunciation" => "gāo xìng", "new" => "yes"},
  {"front" => "请问， 您贵姓", "back" => "Excuse me, may I know your surname?", "pronunciation" => "qǐng wèn, nín guì xìng", "new" => "yes"},
  {"front" => "我姓?， 叫?", "back" => "My surname is ?, my given name is ?", "pronunciation" => "míng, wǒ xìng ?, jiào ?", "new" => "yes"},
  {"front" => "您叫什么名字", "back" => "What is your name?", "pronunciation" => "nín jiào shén me míng zi", "new" => "yes"},
  {"front" => "我叫。。。", "back" => "My name is...", "pronunciation" => "wǒ jiào...", "new" => "yes"},
  {"front" => "见到您， 我很高兴。", "back" => "I am pleased to meet you.", "pronunciation" => "jiàn dào nín, wǒ hěn gāo xìng", "new" => "yes"},
  {"front" => "见到您， 我也很高兴。", "back" => "I am also please to meet you.", "pronunciation" => "jiàn dào nín, wǒ yě hěn gāo xìng", "new" => "yes"}
  ]

cards.each do |card|
  next if card["new"].nil?
  next if card["new"] == "no"

  exists = Card.where(:front => card["front"], :deck_id => forward_deck.id)
  if card["new"] == "yes"
    card = Card.new(:front => card["front"], :back => card["back"], :pronunciation => card["pronunciation"])
    card.deck = forward_deck
    card.save!
  else
    exists.first.back = card["back"]
    exists.first.pronunciation = card["pronunciation"]
    exists.first.save!
  end
end

cards.each do |card|
  next if card["new"].nil?
  next if card["new"] == "no"

  exists = Card.where(:front => card["back"], :deck_id => reverse_deck.id)
  if card["new"] == "yes"
    card = Card.new(:front => card["back"], :back => card["front"], :pronunciation => card["pronunciation"])
    card.deck = reverse_deck
    card.save!
  else
    exists.first.back = card["front"]
    exists.first.pronunciation = card["pronunciation"]
    exists.first.save!
  end
end

cards.each do |card|
  next if card["new"].nil?
  
  exists = Card.where(:front => card["back"], :deck_id => typing_deck.id)
  if card["new"] == "yes" || card["new"] == "no"
    card = Card.new(:front => card["back"], :back => card["front"], :pronunciation => card["pronunciation"])
    card.deck = typing_deck
    card.save!
  else
    exists.first.back = card["front"]
    exists.first.pronunciation = card["pronunciation"]
    exists.first.save!
  end
end
