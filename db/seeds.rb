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
  forward_deck = Deck.new(:name => 'Simplified Hanzi to English (reading)', :lang => 'cn', :country=> 'cn', :shared => true)
  forward_deck.user = user
  forward_deck.save!
else
  forward_deck = forward_deck.first
end
if reverse_deck.empty?
  reverse_deck = Deck.new(:name => 'English to Simplified Hanzi (writing)', :lang => 'cn', :country=> 'cn', :shared => true)
  reverse_deck.user = user
  reverse_deck.save!
else
  reverse_deck = reverse_deck.first
end

cards = []
#cards = [
#  #Lesson 1
#  {"front" => "一", "back" => "1 / (floor, ceiling)"},
#  {"front" => "二", "back" => "2"},
#  {"front" => "三", "back" => "3"},
#  {"front" => "四", "back" => "4"},
#  {"front" => "五", "back" => "5"},
#  {"front" => "六", "back" => "6"},
#  {"front" => "七", "back" => "7 / (diced)"},
#  {"front" => "八", "back" => "8"},
#  {"front" => "九", "back" => "9 / (baseball)"},
#  {"front" => "十", "back" => "10"},
#  {"front" => "目", "back" => "eye"},
#  {"front" => "月", "back" => "month / (moon, flesh, part of body)"},
#  {"front" => "口", "back" => "mouth"},
#  {"front" => "田", "back" => "rice field / (brains)"},
#  {"front" => "日", "back" => "day / (sun, tonque wagging)"},
#  #Lesson 2
#  {"front" => "古", "back" => "ancient"},
#  {"front" => "胡", "back" => "recklessly"},
#  {"front" => "叶", "back" => "leaf"},
#  {"front" => "吾", "back" => "I (literary)"},
#  {"front" => "朋", "back" => "companion"},
#  {"front" => "明", "back" => "bright"},
#  {"front" => "唱", "back" => "sing"},
#  {"front" => "晶", "back" => "sparkling"},
#  {"front" => "品", "back" => "goods"},
#  {"front" => "昌", "back" => "prosperous"},
#  {"front" => "早", "back" => "early / (sunflower)"},
#  {"front" => "旭", "back" => "rising sun"},
#  {"front" => "世", "back" => "generation"},
#  {"front" => "胃", "back" => "stomach"},
#  {"front" => "旦", "back" => "daybreak"},
#  {"front" => "凹", "back" => "concave"},
#  {"front" => "凸", "back" => "convex"},
#  #Lesson 3
#  {"front" => "自", "back" => "oneself / (nose)"},
#  {"front" => "白", "back" => "white"},
#  {"front" => "百", "back" => "hundred"},
#  {"front" => "皂", "back" => "soap"},
#  {"front" => "旧", "back" => "old"},
#  {"front" => "中", "back" => "middle (n/adj)"},
#  {"front" => "千", "back" => "thousand"},
#  {"front" => "舌", "back" => "tonque"},
#  {"front" => "升", "back" => "litre"},
#  {"front" => "丸", "back" => "pill / (bottle of pills)"},
#  {"front" => "卜", "back" => "divination / (divining rod / magic wand)"},
#  {"front" => "占", "back" => "tell fortunes"},
#  {"front" => "上", "back" => "above"},
#  {"front" => "下", "back" => "below"},
#  {"front" => "卡", "back" => "card"},
#  {"front" => "卓", "back" => "eminent"},
#  {"front" => "朝", "back" => "dynasty"},
#  {"front" => "嘲", "back" => "ridicule (v)"},
#  #Lesson 4
#  {"front" => "只", "back" => "only"},
#  {"front" => "贝", "back" => "shellfish"},
#  {"front" => "贴", "back" => "paste (v)"},
#  {"front" => "贞", "back" => "chaste"},
#  {"front" => "员", "back" => "employee"},
#  {"front" => "儿", "back" => "youngster / (human legs)"},
#  {"front" => "几", "back" => "how many? / (wind / small table)"},
#  {"front" => "见", "back" => "see"},
#  {"front" => "元", "back" => "beginning"},
#  {"front" => "页", "back" => "page / (head)"},
#  {"front" => "顽", "back" => "stubborn"},
#  {"front" => "凡", "back" => "ordinary"},
#  {"front" => "肌", "back" => "muscle"},
#  {"front" => "负", "back" => "defeated (adj)"},
#  {"front" => "万", "back" => "ten thousand"},
#  {"front" => "匀", "back" => "uniform (adj)"},
#  {"front" => "句", "back" => "sentence (n)"},
#  {"front" => "旬", "back" => "decameron"},
#  {"front" => "勺", "back" => "ladle"},
#  {"front" => "的", "back" => "bull's eye"},
#  {"front" => "首", "back" => "heads"},
#
#  #Lesson 5
#  {"front" => "直", "back" => "straight"},
#  {"front" => "置", "back" => "setup"},
#  {"front" => "具", "back" => "tool"},
#  {"front" => "真", "back" => "true"},
#  {"front" => "工", "back" => "work (n)"},
#  {"front" => "左", "back" => "left (n/adj)"},
#  {"front" => "右", "back" => "right (n/adj) "},
#  {"front" => "有", "back" => "possess"},
#  {"front" => "贿", "back" => "bribe (n) "},
#  {"front" => "贡", "back" => "tribute"},
#  {"front" => "项", "back" => "item"},
#  {"front" => "刀", "back" => "sword (dagger / saber)"},
#  {"front" => "仞", "back" => "blade"},
#  {"front" => "切", "back" => "cut (v) "},
#  {"front" => "召", "back" => "summon"},
#  {"front" => "昭", "back" => "evident"},
#  {"front" => "则", "back" => "rule (n) "},
#  {"front" => "副", "back" => "vice-"},
#  {"front" => "丁", "back" => "fourth (nail / spike)"},
#  {"front" => "叮", "back" => "sting (v)"},
#  {"front" => "可", "back" => "can (ad.v)"},
#  {"front" => "哥", "back" => "older brother"},
#  {"front" => "顶", "back" => "crest"}
#  ]

cards.each do |card|
  if Card.where(:front => card["front"], "back" => card["back"], :deck_id => forward_deck.id).empty?
    card = Card.new(:front => card["front"], "back" => card["back"])
    card.deck = forward_deck
    card.save!
  end
  if Card.where(:front => card["back"], "back" => card["front"], :deck_id => reverse_deck.id).empty?
    card = Card.new(:front => card["back"], "back" => card["front"])
    card.deck = reverse_deck
    card.save!
  end
end





forward_deck = Deck.where(:name => 'ACCS - Twers (reading practice)', :user_id => user.id)
reverse_deck = Deck.where(:name => 'ACCS - Twers (writing practice)', :user_id => user.id)
if forward_deck.empty?
  forward_deck = Deck.new(:name => 'ACCS - Twers (reading practice)', :lang => 'cn', :country=> 'cn', :shared => true)
  forward_deck.user = user
  forward_deck.save!
else
  forward_deck = forward_deck.first
end
if reverse_deck.empty?
  reverse_deck = Deck.new(:name => 'ACCS - Twers (writing practice)', :lang => 'cn', :country=> 'cn', :shared => true)
  reverse_deck.user = user
  reverse_deck.save!
else
  reverse_deck = reverse_deck.first
end

cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1 (yī)"},
  {"front" => "二", "back" => "2 (èr)"},
  {"front" => "三", "back" => "3 (sān)"},
  {"front" => "四", "back" => "4 (sì)"},
  {"front" => "五", "back" => "5 (wŭ)"},
  {"front" => "六", "back" => "6 (liù)"},
  {"front" => "七", "back" => "7 (qī)"},
  {"front" => "八", "back" => "8 (bā)"},
  {"front" => "九", "back" => "9 (jiŭ)"},
  {"front" => "十", "back" => "10 (shí)"},
  {"front" => "女", "back" => "female (nǚ)"},
  {"front" => "安", "back" => "peace (ān)"},
  {"front" => "子", "back" => "child (zǐ)"},
  {"front" => "好", "back" => "good (hăo)"},
  {"front" => "人", "back" => "Man / mankind (rén)"},
  {"front" => "大", "back" => "big (dà)"},
  {"front" => "太", "back" => "excessive (tài)"},
  {"front" => "天", "back" => "sky (tiān)"},
  {"front" => "日", "back" => "sun (rì)"},
  {"front" => "月", "back" => "moon (yuè)"},
  {"front" => "明", "back" => "bright (míng)"},
  {"front" => "白", "back" => "clear (bái)"},
  {"front" => "明白", "back" => "understand (míng bái)"},
  {"front" => "晶", "back" => "crystal (jīng)"},
  {"front" => "旦", "back" => "dawn (dàn)"},
  {"front" => "字", "back" => "word (zì)"},
  {"front" => "早", "back" => "early (zăo)"},
  {"front" => "百", "back" => "hundred (băi)"},
  {"front" => "千", "back" => "thousand (qiān)"},
  {"front" => "万", "back" => "ten thousand (wàn)"},
  {"front" => "亿", "back" => "hundred million (yì)"},
  {"front" => "奴人", "back" => "woman (nǚ rén)"},  
  {"front" => "早安", "back" => "good morning (zăo ān)"},
  {"front" => "大人", "back" => "adult / big man (dà rén)"},
  {"front" => "太太", "back" => "Mrs (tài tài)"},
  {"front" => "白天", "back" => "daytime (bái tiān)"},
  {"front" => "明天", "back" => "tomorrow (míng tiān)"},
  {"front" => "天天", "back" => "everyday (tiān tiān)"},
  {"front" => "太大", "back" => "too big (tài dà)"},
  {"front" => "好人", "back" => "good person (hăo rén)"},
  {"front" => "零", "back" => "zero (lìng)"},
  #Lesson 2
  {"front" => "小", "back" => "small (xiăo)"},
  {"front" => "也", "back" => "also[adv] (yĕ)"},
  {"front" => "他", "back" => "he/him (tā)"},
  {"front" => "她", "back" => "she/her (tā)"},
  {"front" => "心", "back" => "heart (xīn)"},
  {"front" => "目", "back" => "eyes (mù)"},
  {"front" => "见", "back" => "see[v] (jiàn)"},
  {"front" => "门", "back" => "door (mén)"},
  {"front" => "们", "back" => "plural (men)"},
  {"front" => "人们", "back" => "(people)"},
  {"front" => "手", "back" => "hand (shǒu)"},
  {"front" => "戈", "back" => "spear (gē)"},
  {"front" => "我", "back" => "I/me[pron] (wǒ)"},
  {"front" => "看", "back" => "look (kàn)"},
  {"front" => "你", "back" => "you (nǐ)"},
  {"front" => "不", "back" => "not[adj] (bù)"},
  {"front" => "了", "back" => "[a modal participle] (le)"},
  {"front" => "吗", "back" => "[an interrogative participle] (ma)"},
  {"front" => "很", "back" => "very[adv] (hěn)"},
  {"front" => "小心", "back" => "be careful (xiăo xīn)"},
  {"front" => "谢谢", "back" => "thank you[v] (xièxie)"},
  {"front" => "问好", "back" => "to greet[v]; greeting[n] (wènhòu)"},
  {"front" => "你好", "back" => "hello (nǐ hǎo)"},
  {"front" => "好久", "back" => "long time[adj] (hǎojiŭ)"},
  {"front" => "心目", "back" => "mood, memory (xīn mù)"},
  {"front" => "安心", "back" => "feel at east (not worried) (ān xīn)"},
  {"front" => "好心人", "back" => "kind-hearted person (hǎo xīn rén)"},
  {"front" => "看见", "back" => "see (kàn jiàn)"},
  {"front" => "明天见", "back" => "see you tomorrow (míng tiān jiàn)"},
  {"front" => "太小", "back" => "too small (tāi xiăo)"},
  {"front" => "你们", "back" => "all of you (nǐ men)"},
  {"front" => "他们", "back" => "they / them (tā men)"},
  {"front" => "她们", "back" => "(female) they (tā men)"},
  {"front" => "我们", "back" => "we / us (wǒ men)"},
  {"front" => "你早", "back" => "good mornǐng (nǐ zǎo)"},
  {"front" => "你们好", "back" => "how do you do, hello (nǐ men hǎo)"},
  {"front" => "您好", "back" => "how do you do, hello (polite) (nǐn hǎo)"},
  {"front" => "好久不练了", "back" => "Long time no see (hǎojiǔ bú jiàn le)"},
  {"front" => "你好吗？", "back" => "How are you? (nǐ hǎo ma?)"},
  {"front" => "我很好", "back" => "I am fine (Wǒ hěn hǎo)"},
  {"front" => "我也很好", "back" => "I'm also fine (Wǒ yě hěn hǎo)"},
  {"front" => "她太太好吗", "back" => "How is your wife? (nǐ tāitāi hǎo ma?)"},
  {"front" => "她也很好", "back" => "She is also fine (tā yě hěn hǎo)"}
  ]

cards.each do |card|
  if Card.where(:front => card["front"], "back" => card["back"], :deck_id => forward_deck.id).empty?
    card = Card.new(:front => card["front"], "back" => card["back"])
    card.deck = forward_deck
    card.save!
  end
end

cards = []
cards = [
  #Lesson 1
  {"front" => "一 (yī)", "back" => "1"},
  {"front" => "二 (èr)", "back" => "2"},
  {"front" => "三 (sān)", "back" => "3"},
  {"front" => "四 (sì)", "back" => "4"},
  {"front" => "五 (wŭ)", "back" => "5"},
  {"front" => "六 (liù)", "back" => "6"},
  {"front" => "七 (qī)", "back" => "7"},
  {"front" => "八 (bā)", "back" => "8"},
  {"front" => "九 (jiŭ)", "back" => "9"},
  {"front" => "十 (shí)", "back" => "10"},
  {"front" => "女 (nǚ)", "back" => "female"},
  {"front" => "安 (ān)", "back" => "peace"},
  {"front" => "子 (zǐ)", "back" => "child"},
  {"front" => "好 (hăo)", "back" => "good"},
  {"front" => "人 (rén)", "back" => "Man / mankind"},
  {"front" => "大 (dà)", "back" => "big"},
  {"front" => "太 (tài)", "back" => "excessive"},
  {"front" => "天 (tiān)", "back" => "sky"},
  {"front" => "日 (rì)", "back" => "sun"},
  {"front" => "月 (yuè)", "back" => "moon"},
  {"front" => "明 (míng)", "back" => "bright"},
  {"front" => "白 (bái)", "back" => "clear"},
  {"front" => "明白 (míng bái)", "back" => "understand"},
  {"front" => "晶 (jīng)", "back" => "crystal"},
  {"front" => "旦 (dàn)", "back" => "dawn"},
  {"front" => "字 (zì)", "back" => "word"},
  {"front" => "早 (zăo)", "back" => "early"},
  {"front" => "百 (băi)", "back" => "hundred"},
  {"front" => "千 (qiān)", "back" => "thousand"},
  {"front" => "万 (wàn)", "back" => "ten thousand"},
  {"front" => "亿 (yì)", "back" => "hundred million"},
  {"front" => "奴人 (nǚ rén)", "back" => "woman"},
  {"front" => "早安 (zăo ān)", "back" => "good morning"},
  {"front" => "大人 (dà rén)", "back" => "adult / big man"},
  {"front" => "太太 (tài tài)", "back" => "Mrs"},
  {"front" => "白天 (bái tiān)", "back" => "daytime"},
  {"front" => "明天 (míng tiān)", "back" => "tomorrow"},
  {"front" => "天天 (tiān tiān)", "back" => "everyday"},
  {"front" => "太大 (tài dà)", "back" => "too big"},
  {"front" => "好人 (hăo rén)", "back" => "good person"},
  {"front" => "零 (lìng)", "back" => "zero"}
  #Lesson 2
  ]

cards.each do |card|
  if Card.where(:front => card["back"], "back" => card["front"], :deck_id => reverse_deck.id).empty?
    card = Card.new(:front => card["back"], "back" => card["front"])
    card.deck = reverse_deck
    card.save!
  end
end
