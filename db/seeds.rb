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

deck = Deck.where(:name => 'Simplified Hanzi to English', :user_id => user.id)
if deck.empty?
  deck = Deck.new(:name => 'Simplified Hanzi to English', :lang => 'cn', :country=> 'cn', :shared => true)
  deck.user = user
  deck.save!
else
  deck = deck.first
end

cards = []
cards = [
  #Lesson 1
  {"front" => "一", "back" => "1"},
  {"front" => "二", "back" => "2"},
  {"front" => "三", "back" => "3"},
  {"front" => "四", "back" => "4"},
  {"front" => "五", "back" => "5"},
  {"front" => "六", "back" => "6"},
  {"front" => "七", "back" => "7"},
  {"front" => "八", "back" => "8"},
  {"front" => "九", "back" => "9"},
  {"front" => "十", "back" => "10"},
  {"front" => "目", "back" => "eye"},
  {"front" => "月", "back" => "month"},
  {"front" => "口", "back" => "mouth"},
  {"front" => "田", "back" => "rice field"},
  {"front" => "日", "back" => "day"},
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
  {"front" => "早", "back" => "early"},
  {"front" => "旭", "back" => "rising sun"},
  {"front" => "世", "back" => "generation"},
  {"front" => "胃", "back" => "stomach"},
  {"front" => "旦", "back" => "daybreak"},
  {"front" => "凹", "back" => "concave"},
  {"front" => "凸", "back" => "convex"},
  #Lesson 3
  {"front" => "自", "back" => "oneself"},
  {"front" => "白", "back" => "white"},
  {"front" => "百", "back" => "hundred"},
  {"front" => "皂", "back" => "soap"},
  {"front" => "旧", "back" => "old"},
  {"front" => "中", "back" => "middle"},
  {"front" => "千", "back" => "thousand"},
  {"front" => "舌", "back" => "tonque"},
  {"front" => "升", "back" => "litre"},
  {"front" => "丸", "back" => "pill"},
  {"front" => "卜", "back" => "divination"},
  {"front" => "占", "back" => "tell fortunes"},
  {"front" => "上", "back" => "above"},
  {"front" => "下", "back" => "below"},
  {"front" => "卡", "back" => "card"},
  {"front" => "卓", "back" => "eminent"},
  {"front" => "朝", "back" => "dynasty"},
  {"front" => "嘲", "back" => "ridicule"},
  #Lesson 4
  {"front" => "只", "back" => "only"},
  {"front" => "贝", "back" => "shellfish"},
  {"front" => "贴", "back" => "paste"},
  {"front" => "贞", "back" => "chaste"},
  {"front" => "员", "back" => "employee"},
  {"front" => "儿", "back" => "youngster"},
  {"front" => "几", "back" => "how many?"},
  {"front" => "见", "back" => "see"},
  {"front" => "元", "back" => "beginning"},
  {"front" => "页", "back" => "page"},
  {"front" => "顽", "back" => "stubborn"},
  {"front" => "凡", "back" => "ordinary"},
  {"front" => "肌", "back" => "muscle"},
  {"front" => "负", "back" => "defeated"},
  {"front" => "万", "back" => "ten thousand"},
  {"front" => "匀", "back" => "uniform"},
  {"front" => "句", "back" => "sentence"},
  {"front" => "旬", "back" => "decameron"},
  {"front" => "勺", "back" => "ladle"},
  {"front" => "的", "back" => "bull's eye"},
  {"front" => "首", "back" => "heads"},

  #Lesson 5
  {"front" => "直", "back" => "straight"},
  {"front" => "置", "back" => "setup"},
  {"front" => "俱", "back" => "tool"},
  {"front" => "真", "back" => "true"},
  {"front" => "工", "back" => "work"},
  {"front" => "左", "back" => "left"},
  {"front" => "右", "back" => "right"},
  {"front" => "有", "back" => "possess"},
  {"front" => "贿", "back" => "bribe"},
  {"front" => "贡", "back" => "tribute"},
  {"front" => "项", "back" => "item"},
  {"front" => "刀", "back" => "sword"},
  {"front" => "仞", "back" => "blade"},
  {"front" => "切", "back" => "cut"},
  {"front" => "召", "back" => "summon"},
  {"front" => "昭", "back" => "evident"},
  {"front" => "则", "back" => "rule"},
  {"front" => "副", "back" => "vice-"},
  {"front" => "丁", "back" => "fourth"},
  {"front" => "叮", "back" => "sting"},
  {"front" => "可", "back" => "can"},
  {"front" => "哥", "back" => "older brother"},
  {"front" => "顶", "back" => "crest"}
  ]

cards.each do |card|
  if Card.where(:front => card["front"], "back" => card["back"], :deck_id => deck.id).empty?
    card = Card.new(:front => card["front"], "back" => card["back"])
    card.deck = deck
    card.save!
  end
end

