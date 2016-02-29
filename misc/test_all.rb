r1 = Regexp.new('^a-z+:\s+\w+') #=> /^a-z+:\s+\w+/
r2 = Regexp.new('cat', true)     #=> /cat/i
r3 = Regexp.new(r2)              #=> /cat/i
r4 = Regexp.new('dog', Regexp::EXTENDED | Regexp::IGNORECASE) #=> /dog/ix

# hello ='dd-mmm-yyyy'
# #hello ='mm-dd-yyyy'
# #hello ='mmm-dd-yyyy'
# #hello ='mmm dd, yyyy'
# #hello ='dd-mm-yyyy'
# i = hello.count 'm'
# if i == 3
  # puts hello.gsub!(/d/,'[0-9]') 
  # puts hello.gsub!(/mmm/,'(Jan|Mar|Apr|Jun|Jul|Aug|Sep|Oct|Nov|Dec)')
  # puts hello.gsub!(/y/,'[0-9]')
  # reg1 = Regexp.new(hello)
  # puts '30-Jan-2009' =~ /\A#{reg1}\Z/.nil?
# else
  # puts hello.gsub!(/d/,'[0-9]')
  # puts hello.gsub!(/m/,'[0-9]')
  # puts hello.gsub!(/y/,'[0-9]')
  # reg1 = Regexp.new(hello)
  # #puts '99-12-2009' =~ /\A#{reg1}\Z/  
# end
# 
# reg_mega = Regexp.new('^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');
# puts '29-Feb-2009' =~ /#{reg_mega}/

# m = []
# m << "123".scan(/^[0-9]+$/)
# m << "456".scan(/^[0-9]+$/)
# m << "789s".scan(/^[0-9]+$/)
# m << "s147".scan(/^[0-9]+$/)
# m << "2s35".scan(/^[0-9]+$/)
# puts m
# require 'Time'
# puts "31-12-2009"[/[^0-9]/]

# puts __dir__
puts File.expand_path(File.dirname(File.dirname(__FILE__)))



