# The Program automates some standard inputs on to the Chrome/Firefox/Safari
# browsers. For those unhappy souls using IE, I apologize. Honestly man, it's not worth it.
#
# Author::    Rakib Amin  (mailto:rakib.amin@therapservices.net)
# License::   GPL V 2.0
#
# Rubygem Info:: watir-webdriver
# API doc::      http://www.rubydoc.info/gems/watir-webdriver
# Copyright::    Copyright (c) 2009-2015 Jari Bakken.
# License::      MIT


require 'watir-webdriver'


# This class is used as a template for some common
# browser input automation patterns using watir
# Constructor @param1 uri     'address for intended form'
#             @param2 browser 'values can only be :chrome/:firefox/:safari'

class Automator
  def initialize(uri, browser)
    @browser = Watir::Browser.new browser
    @browser.goto uri
  end
  public

  def automate_form
    @browser.text_field(:name => 'entry.1000000').set 'Watir'
    @browser.text_field(:id => 'entry_1000001').set "I come here from Australia."
    @browser.radio(:value => 'Watir').set
    @browser.checkbox(:id, 'group_1000003_1').set
    @browser.select_list(:id, 'entry_1000004').select 'Chrome'
    @browser.radio(:value => '5').set
    @browser.radio(:id => 'group_1000006_3').set
    @browser.radio(:id => 'group_1000007_5').set
    @browser.form(:id => 'ss-form').submit
    @browser.link(:class, 'ss-bottom-link').click
    @browser.table(:id => 'table_id')
    # close the browser
    # @browser.close
  end

  def access_attr
    # Retrieve a single word attribute
    @browser.text_field.id
    # Retrieve a multi-word attribute
    @browser.text_field.max_length
    # Retrieve a boolean attribute
    @browser.text_field.required?
    @browser.text_field.disabled?
    # Retrieve a data attribute
    @browser.div.data_field
    # Retrieve an aria attribute
    @browser.input.aria_labelledby
    # Retrieve a class attribute
    @browser.div(id: 'tp1').class_name
    # No of divs
    @browser.divs.size
  end

  def access_fields
    # text field
    @text_field_1 = browser.text_field(:name, "username")
    # button
    @button_1 = browser.button(:value, "Click Here")
    # <ul><li option></li></ul>
    @dropdown_1 = browser.select_list(:name, "month")
    # <input type='checkbox'></input>
    @checkbox_1 = browser.checkbox(:name, "enabled")
    # <input type='radio'></input>
    @radio_1 = browser.radio(:name, "payment type")
    # <form name='address'></form>
    @form_1 = browser.form(:name, "address")
    # <form></form>
    @form_act = browser.form(:action, "submit")
    # <a href='http://google.com'></a>
    @link_1 = browser.link(:href, "http://google.com")
    # table cell in a table (2nd row, 1st column)
    @td = browser.table(:name, 'recent_records')[2][1]
  end

  def parse_data
    # @parsed_html = @browser.html
    @parsed_html = @browser.title
    puts @parsed_html

    # DOM
    puts @browser.div.text
    # Return the contents of a table as an array
    @browser.table(:id, 'recent_records').to_a

    # Return true if the specified text appears on the page
    @browser.text.include? 'llama'
  end

  def manipulate_fields
    # Click a button or link
    @button_1.click
    @link_1.click
    # Enter text in a text box
    @text_field_1.set("mickey mouse")
    # Enter multiple lines in a multi-line text box
    @text_field_1.set("line 1\nline2")
    # Set radio button or check box
    @radio_1.set
    @radio_1.set
    # Clear an element
    @text_field_1.clear
    @radio_1.clear
    # Select an option in a drop down list
    @dropdown_1.select "cash"
    @dropdown_1.set "cash"
    # Clear a drop down list
    @dropdown_1.clearSelection
    # Submit a form
    @form_1.submit
    # Flash any element (useful from the watir-console)
    @form_1.flash
  end

end

# automate = Automator.new('http://bit.ly/watir-example', :chrome)
# automate.automate_form

automate = Automator.new('https://url', :chrome)