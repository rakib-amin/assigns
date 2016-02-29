require 'watir-webdriver'
browser = Watir::Browser.new :Chrome # should open a new Firefox window
browser.goto 'http://nitrowriters.com/form/form.html' # or type the local path to your downloaded copy

browser.text_field(:id => 'my_text_field').set 'Yes!'
browser.textarea(:class => 'element textarea medium').set 'It was a long time ago, I do not remember'

browser.radio(:name => 'familiar_rails', :value => '1').click # yes, I'm very familiar
sleep 2 # puts the entire program to sleep for 2 seconds, so you can see the change
browser.radio(:name => 'familiar_rails', :value => '3').click # actually, just a bit...

browser.text_field(:name => 'favorite_1').set 'Yukihiro' # the creator of Ruby
browser.text_field(:id => 'favorite_2').set 'Matsumoto' # is my favorite Ruby person!

browser.checkbox(:index => 1).click # I like the TDD culture
browser.checkbox(:index => 2).click # And Matz!
sleep 2 # puts the entire program to sleep for 2 seconds, so you can see the change
browser.checkbox(:index => 1).click # Oh well, I like only Matz..

browser.select_list(:id => 'usage').select 'Less than a year'
browser.select_list(:id => 'usage').select_value '2' # Changed my mind

# Here I entered C:/watir.txt because I had such a file inside my C: directory. Please be sure
# to enter a valid path to a file, or your script will report 'No such file or directory' error
browser.file_field.set 'C:/watir.txt' # Change this path to any path to a local file on your computer
puts browser.p(:id => 'my_description').text