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

cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1", "pronunciation" => "yī"},
  {"front" => "二", "back" => "2", "pronunciation" => "èr"},
  {"front" => "三", "back" => "3", "pronunciation" => "sān"},
  {"front" => "四", "back" => "4", "pronunciation" => "sì"},
  {"front" => "五", "back" => "5", "pronunciation" => "wŭ"},
  {"front" => "六", "back" => "6", "pronunciation" => "liù"},
  {"front" => "七", "back" => "7", "pronunciation" => "qī"},
  {"front" => "八", "back" => "8", "pronunciation" => "bā"},
  {"front" => "九", "back" => "9", "pronunciation" => "jiŭ"},
  {"front" => "十", "back" => "10", "pronunciation" => "shí"},
  {"front" => "女", "back" => "female", "pronunciation" => "nǚ"},
  {"front" => "安", "back" => "peace", "pronunciation" => "ān"},
  {"front" => "子", "back" => "child", "pronunciation" => "zǐ"},
  {"front" => "好", "back" => "good", "pronunciation" => "hăo"},
  {"front" => "人", "back" => "Man / mankind", "pronunciation" => "rén"},
  {"front" => "大", "back" => "big", "pronunciation" => "dà"},
  {"front" => "太", "back" => "excessive", "pronunciation" => "tài"},
  {"front" => "天", "back" => "sky", "pronunciation" => "tiān"},
  {"front" => "日", "back" => "sun", "pronunciation" => "rì"},
  {"front" => "月", "back" => "moon", "pronunciation" => "yuè"},
  {"front" => "明", "back" => "bright", "pronunciation" => "míng"},
  {"front" => "白", "back" => "clear", "pronunciation" => "bái"},
  {"front" => "明白", "back" => "understand", "pronunciation" => "míng bái"},
  {"front" => "晶", "back" => "crystal", "pronunciation" => "jīng"},
  {"front" => "旦", "back" => "dawn", "pronunciation" => "dàn"},
  {"front" => "字", "back" => "word", "pronunciation" => "zì"},
  {"front" => "早", "back" => "early", "pronunciation" => "zăo"},
  {"front" => "百", "back" => "hundred", "pronunciation" => "băi"},
  {"front" => "千", "back" => "thousand", "pronunciation" => "qiān"},
  {"front" => "万", "back" => "ten thousand", "pronunciation" => "wàn"},
  {"front" => "亿", "back" => "hundred million", "pronunciation" => "yì"},
  {"front" => "奴人", "back" => "woman", "pronunciation" => "nǚ rén"},
  {"front" => "早安", "back" => "good morning", "pronunciation" => "zăo ān"},
  {"front" => "大人", "back" => "adult / big man", "pronunciation" => "dà rén"},
  {"front" => "太太", "back" => "Mrs", "pronunciation" => "tài tài"},
  {"front" => "白天", "back" => "daytime", "pronunciation" => "bái tiān"},
  {"front" => "明天", "back" => "tomorrow", "pronunciation" => "míng tiān"},
  {"front" => "天天", "back" => "everyday", "pronunciation" => "tiān tiān"},
  {"front" => "太大", "back" => "too big", "pronunciation" => "tài dà"},
  {"front" => "好人", "back" => "good person", "pronunciation" => "hăo rén"},
  {"front" => "零", "back" => "zero", "pronunciation" => "lìng"},
  #Lesson 2
  {"front" => "小", "back" => "small", "pronunciation" => "xiăo"},
  {"front" => "也", "back" => "also[adv]", "pronunciation" => "yĕ"},
  {"front" => "他", "back" => "he/him", "pronunciation" => "tā"},
  {"front" => "她", "back" => "she/her", "pronunciation" => "tā"},
  {"front" => "心", "back" => "heart", "pronunciation" => "xīn"},
  {"front" => "目", "back" => "eyes", "pronunciation" => "mù"},
  {"front" => "见", "back" => "see[v]", "pronunciation" => "jiàn"},
  {"front" => "门", "back" => "door", "pronunciation" => "mén"},
  {"front" => "们", "back" => "plural", "pronunciation" => "men"},
  {"front" => "人们", "back" => "people", "pronunciation" => ""},
  {"front" => "手", "back" => "hand", "pronunciation" => "shǒu"},
  {"front" => "戈", "back" => "spear", "pronunciation" => "gē"},
  {"front" => "我", "back" => "I/me[pron]", "pronunciation" => "wǒ"},
  {"front" => "看", "back" => "look", "pronunciation" => "kàn"},
  {"front" => "你", "back" => "you", "pronunciation" => "nǐ"},
  {"front" => "不", "back" => "not[adj]", "pronunciation" => "bù"},
  {"front" => "了", "back" => "[a modal participle]", "pronunciation" => "le"},
  {"front" => "吗", "back" => "[an interrogative participle]", "pronunciation" => "ma"},
  {"front" => "很", "back" => "very[adv]", "pronunciation" => "hěn"},
  {"front" => "小心", "back" => "be careful", "pronunciation" => "xiăo xīn"},
  {"front" => "谢谢", "back" => "thank you[v]", "pronunciation" => "xièxie"},
  {"front" => "问好", "back" => "to greet[v]; greeting[n]", "pronunciation" => "wènhòu"},
  {"front" => "你好", "back" => "hello", "pronunciation" => "nǐ hǎo"},
  {"front" => "好久", "back" => "long time[adj]", "pronunciation" => "hǎojiŭ"},
  {"front" => "心目", "back" => "mood, memory", "pronunciation" => "xīn mù"},
  {"front" => "安心", "back" => "feel at ease / not worried", "pronunciation" => "ān xīn"},
  {"front" => "好心人", "back" => "kind-hearted person", "pronunciation" => "hǎo xīn rén"},
  {"front" => "看见", "back" => "see", "pronunciation" => "kàn jiàn"},
  {"front" => "明天见", "back" => "see you tomorrow", "pronunciation" => "míng tiān jiàn"},
  {"front" => "太小", "back" => "too small", "pronunciation" => "tāi xiăo"},
  {"front" => "你们", "back" => "all of you", "pronunciation" => "nǐ men"},
  {"front" => "他们", "back" => "they / them", "pronunciation" => "tā men"},
  {"front" => "她们", "back" => "(female) they", "pronunciation" => "tā men"},
  {"front" => "我们", "back" => "we / us", "pronunciation" => "wǒ men"},
  {"front" => "你早", "back" => "good mornǐng", "pronunciation" => "nǐ zǎo"},
  {"front" => "你们好", "back" => "how do you do, hello", "pronunciation" => "nǐ men hǎo"},
  {"front" => "您好", "back" => "how do you do, hello (polite)", "pronunciation" => "nǐn hǎo"},
  {"front" => "好久不练了", "back" => "Long time no see", "pronunciation" => "hǎojiǔ bú jiàn le"},
  {"front" => "你好吗？", "back" => "How are you?", "pronunciation" => "nǐ hǎo ma?"},
  {"front" => "我很好", "back" => "I am fine", "pronunciation" => "Wǒ hěn hǎo"},
  {"front" => "我也很好", "back" => "I'm also fine", "pronunciation" => "Wǒ yě hěn hǎo"},
  {"front" => "她太太好吗", "back" => "How is your wife?", "pronunciation" => "nǐ tāitāi hǎo ma?"},
  {"front" => "她也很好", "back" => "She is also fine", "pronunciation" => "tā yě hěn hǎo)"}
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
