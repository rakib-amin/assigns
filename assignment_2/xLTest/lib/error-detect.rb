=begin
@input config files
@output console.txt
=end

# pretty print for Hashes
require 'pp'

# roo rubygems for .ods parsing
require 'rubygems'
require 'roo'

def is_leap(year)
   return year%400==0 || (year%4==0 && year%100!=0)
end

# class for extracting data from a given file
class Extractor
  $global_conf = {}
  
  def initialize(filepath)
    @filepath = filepath
    @i = 0
    @@data = []
    @arr = IO.readlines(@filepath)
    @arr.each do |x|
      if !x.include? "#"
        if  !x.chomp.empty?
          @rhs = x.chomp.split("=")
          @@data[@i] = @rhs[1]    
          @i += 1
          @rhs.clear  
        end
      end
    end
  end

  public
 
  def save_conf_data
    @@local_conf = {}
    @@local_conf[:data_source_type] = @@data[0]
    @@local_conf[:source_file_name] = @@data[1]
    @@local_conf[:start_from_line_no] = @@data[2]
    pp @@local_conf
    puts "<br />"
  end
  
  def save_exp_data
    @@exp_data = []
    @@j = 0
    @@data.map do |x|
      @@exp_data[@@j] = x
      puts "Column #{(@@j+65).chr}: #{@@exp_data[@@j]}"
      puts "<br />"
      @@j += 1
    end
  end
  
end

class ODSParser < Extractor
  def initialize
    $file = File.expand_path(File.dirname(File.dirname(__FILE__))) << "/test-data/module_1/"
    @columns = @@exp_data
    @config = @@local_conf
    $file << @config[:source_file_name]
    @ods = Roo::Spreadsheet.open($file) if(@config[:data_source_type].to_s=="file_system")
  end
  
  public
    
  def valid_cell(r,c,data_type,reqd,regex)
    puts "Row: #{r} Column: #{(c+65-1).chr}"
    puts "Value: <u>#{@ods.cell(r,c)}</u>"
    # puts data_type
    # puts reqd
    # puts regex
    puts "<strong style='color:red'>" 
    if !@ods.cell(r,c).nil?
      case data_type
      when "boolean"
        if @ods.cell(r,c).is_a?(TrueClass) || @ods.cell(r,c).is_a?(FalseClass)
          @try_regex = Regexp.new('^'+ regex + '+$')
          if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
            # puts 'Valid'
          else
            puts 'Regex Mismatch'   
          end 
        else
          puts "Not a Boolean"
        end 
      when "number"
        if @ods.cell(r,c).to_s.gsub(/^0+/, "").to_i.to_s == @ods.cell(r,c).to_s.gsub(/^0+/, "") 
          @try_regex = Regexp.new('^'+ regex + '+$')
          if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
            # puts 'Valid'
          else
            puts 'Regex Mismatch'   
          end 
        else
          puts "Not a Number"
        end 
      when "string"
        if @ods.cell(r,c).is_a?(String)
          @try_regex = Regexp.new('^'+ regex + '+$')
          if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
            # puts 'Valid'
          else
            puts 'Regex Mismatch'   
          end 
        else
          puts "Not a String"
        end 
      when "date"
        begin
          @conv_date = Time.parse(@ods.cell(r,c))
          # convert format to regex
          case regex
          when "dd-mm-yyyy" || "dd.mm.yyyy" || "dd/mm/yyyy" #31/12/1992
            @try_regex = Regexp.new('^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
            if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
              # puts 'Valid Regex'
            else
              puts 'Regex Mismatch'   
            end
          when "dd-mm-yy" || "dd.mm.yy" || "dd/mm/yy" #31-12-92 
            @try_regex = Regexp.new('^(?:(?:31(\/|-|\.)(?:(?:0?[13578]|1[02])))\1|(?:(?:29|30)(\/|-|\.)(?:(?:0?[13456789]|1[012]))\2))(?:(?:[0-9])?\d{1})$|^(?:29(\/|-|\.)(?:0?2)\3(?:(?:0[048]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26]))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:(?:0?[12345678]))|(?:(?:1[012])))\4(?:(?:[0-9])?\d{1})$')
            if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
              # puts 'Valid Regex'
            else
              puts 'Regex Mismatch'   
            end
          when "mm-dd-yyyy" || "mm.dd.yyyy" || "mm/dd/yyyy" #12-31-1992
            @try_regex = Regexp.new('^(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
            if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
              # puts 'Valid Regex'
            else
              puts 'Regex Mismatch'   
            end
          when "dd-mmm-yyyy" || "dd.mmm.yyyy" || "dd/mmm/yyyy" # 12-Dec-1992
            @try_regex = Regexp.new('^(?:(?:31(\/|-|\.)(?:(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
            if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
              # puts 'Valid Regex'
            else
              puts 'Regex Mismatch'   
            end
          when "dd-mmm-yy" || "dd.mmm.yy" || "dd/mmm/yy" # 12-Dec-92
            @try_regex = Regexp.new('^(?:(?:31(\/|-|\.)(?:(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:[0-9])?\d{1})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:0[048]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26]))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:(?:Oct|Nov|Dec)))\4(?:(?:[0-9])?\d{1})$')
            if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
              # puts 'Valid Regex'
            else
              puts 'Regex Mismatch'   
            end
          when "mmm-dd-yyyy" || "mmm.dd.yyyy" || "mmm/dd/yyyy" # Dec-12-1992
            @try_regex = Regexp.new('^(?:(?:(?:(?:Jan|Mar|May|Jul|Aug|Oct|Dec))(\/|-|\.)31)\1|(?:(?:(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:(?:(?:Feb))(\/|-|\.)(?:29)\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:(?:(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:(?:Oct|Nov|Dec)))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
            if !(@ods.cell(r,c).to_s =~ /#{@try_regex}/).nil?
              # puts 'Valid Regex'
            else
              puts 'Regex Mismatch'   
            end
          else
            puts "Date Format Unknown. Correct Config file"
          end
        rescue Exception
          puts "Not a Valid Date. Ruby has raised ArgumentError"
        end
      else
        puts "Unknown Data Type. Correct Config File"
      end
     else
      puts "Data Absent: Was a Required Cell" if reqd=="true"   
     end
     puts "</strong>"
  end
  
  def process_ods
    @rules = []
    @count = 0
    for @j in 1..@columns.length
      @rules = @columns[@count].split(",")
      for @i in @config[:start_from_line_no].to_i..@ods.last_row
        puts valid_cell(@i,@j,@rules[0],@rules[1],@rules[2])
        puts "<br />"
        @i += 1
      end
      puts "<br />"
      @j += 1
      @count += 1
      @rules.clear 
    end
  end
  
end

$html = File.new(File.expand_path(File.dirname(File.dirname(__FILE__))) << '/test-report/module_1/console.html', 'w+')
$html.write("<!DOCTYPE html>
<html>
<body>
");

# overrides stdout to write in a file
$stdout = $html; 
$stdout.sync = true

puts "File Created: "
puts Time.now
puts "<br />"
puts "<strong><emph>Config</emph></strong>"
puts "<br />"
my_extractor1 = Extractor.new(File.expand_path(File.dirname(File.dirname(__FILE__))) << "/test-data/module_1/conf")
my_extractor1.save_conf_data
puts "<strong><emph>Expected Data</emph></strong>"
puts "<br />"
my_extractor2 = Extractor.new(File.expand_path(File.dirname(File.dirname(__FILE__))) << "/test-data/module_1/expected_data")
my_extractor2.save_exp_data
puts "<strong><emph>Spreadsheet</emph></strong>"
puts "<br />"
my_ods_parser = ODSParser.new
my_ods_parser.process_ods

$html.write("</body>
</html>")
$html.close




