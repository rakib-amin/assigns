=begin
@input therap.log.ms-2.2013-10-21
@output console.txt
=end

# pretty print for Hashes
require 'pp' 

class String
  # source: http://stackoverflow.com/questions/9661478/ By sawa and Dominik Honnef 
  def string_between_markers(marker1, marker2)  
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/, 1] 
  end
  # regex match
  def string_contains(regex)
    /#{regex}/ =~ self
  end
end

# class for extracting data from a given file
class Extractor 
  $all_user_data = Hash.new { |h, k| h[k] = { } }
  $packet_count = 0
  @@i = 0
  @@worth_processing = {}
  @data = {}
  def initialize(filepath)
    @filepath = filepath
  end

  public
  # uses a 2-d Hash to store all packet data
  def create_global_report 
    @data = return_lines
    @data.each  do |x,y|
      timestamp = y.string_between_markers("","[[ACTIVE]")
      user = y.string_between_markers("U:","A:")
      uri = y.string_between_markers("URI=[","]")
      method = y.string_between_markers("],","time")
      time = y.string_between_markers("time=","ms")
      # eliminates invalid entries
      if !timestamp.nil? && !user.nil? && !uri.nil? && !method.nil? && !time.nil?
          $all_user_data[$packet_count][:timestamp] = timestamp.strip unless timestamp.strip.empty? 
          $all_user_data[$packet_count][:user] = user.strip unless user.strip.empty? 
          $all_user_data[$packet_count][:uri] = uri.strip unless uri.strip.empty? 
          $all_user_data[$packet_count][:method] = method.gsub(/,/,'').strip unless method.strip.empty? 
          $all_user_data[$packet_count][:time] = time.strip unless time.strip.empty?
          # extracts hour data
          time_t = $all_user_data[$packet_count][:timestamp].split(" ")
          time_t_2 = time_t[1].split(":")
          $all_user_data[$packet_count][:th_hour] = time_t_2[0].to_i + 1
          $packet_count += 1
       end 
    end 
    #pp $all_user_data   
  end

  private
  # reads line from a file
  def return_lines
    arr = IO.readlines(@filepath)
    arr.each do |x|
      @@worth_processing[@@i] = x if x.include? "PROFILER:132"  
      @@i += 1
    end
    @@worth_processing
  end
end

# class inherits Extractor, creates report
class Report < Extractor
  def initialize(filepath)
    super filepath
  end

  public 
  # call super class method to create the global Hash
  def create_global_report
    super
  end
  # creates summary for 24 hours 
  def create_hourly_report(url)
    @total_serv_time = 0
    @time_spent_g = 0
    @time_spent_p = 0
    @user_list = []
    @g_count = 0
    @p_count = 0
    @n = 1
    puts "24 Hour Report for #{url}"
    puts "---------------------------------------------------------------------------------------------"
    puts "TH HOUR---# USER---# GET---# POST---TOTAL_TIME_GET(ms)---TOTAL_TIME_POST(ms)---TOTAL_TIME(ms)"
    puts "---------------------------------------------------------------------------------------------"
    for n in 1..24
      $all_user_data.each do |k,v|
        if v[:th_hour] == n && !v[:uri].to_s.string_contains(url).nil? 
          @total_serv_time += v[:time].to_i
          if v[:method] == 'G'
            @time_spent_g += v[:time].to_i
            @g_count += 1 
          end
          if v[:method] == 'P'
            @time_spent_p += v[:time].to_i
            @p_count += 1  
          end
          @user_list << v[:user].to_s
        end   
      end
      #puts "#{n}TH HOUR---#{@user_list.uniq.length} users---#{@g_count} GET REQs---#{@p_count} POST REQs---#{@time_spent_g}ms in GET---#{@time_spent_p}ms in POST---#{@total_serv_time}ms in Total"
      puts "#{n}TH HOUR---#{@user_list.length} users---#{@g_count} GET REQs---#{@p_count} POST REQs---#{@time_spent_g}ms in GET---#{@time_spent_p}ms in POST---#{@total_serv_time}ms in Total"
      #pp @@user_list.uniq
      @total_serv_time = 0
      @time_spent_g = 0
      @time_spent_p = 0
      @g_count = 0
      @p_count = 0
      @user_list.clear
    end
  end
  # calculates given USER_ID's total spent time
  def calc_user_time(user_id)
    @time_spent_g = 0
    @time_spent_p = 0
    $all_user_data.each do |k,v| 
      if v[:user] == user_id
        @time_spent_g += v[:time].to_i if v[:method]=='G'
        @time_spent_p += v[:time].to_i if v[:method]=='P'  
      end
    end
    puts "User [#{user_id}] spent #{@time_spent_g} ms using GET method"
    puts "User [#{user_id}] spent #{@time_spent_p} ms using POST method"
  end
end

puts Time.now

# overrides stdout to write in a file
$stdout = File.new('console.txt', 'w+') 
$stdout.sync = true

my_report = Report.new("therap.log.ms-2.2013-10-21")
my_report.create_global_report
my_report.create_hourly_report("/ma/isp/singleForm")
my_report.calc_user_time("samanthaparks@LOI-OR")





