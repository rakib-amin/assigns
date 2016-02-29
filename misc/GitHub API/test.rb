require 'octokit'
require 'openssl'
require 'open-uri'

# Personal Token : a2b74f8f7f510be60d318a45fbfba1ea893098d5
# Get all commits: curl -i https://api.github.com/repos/rakib-sqa-amin/therap-assigns/commits

# output in a html file
$html = File.new('GiHub_Details.html', 'w+')
$html.write("<!DOCTYPE html>
<html>
<body>
");
# overrides stdout to write in a file
$stdout = $html; 
$stdout.sync = true

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

client = Octokit::Client.new(:access_token => "a2b74f8f7f510be60d318a45fbfba1ea893098d5")
user = client.user
puts user.login

# get user
user = Octokit.user 'rakib-sqa-amin'

puts '<p>' << user.name << '</p>'
puts '<p>' << user[:company] << '</p>'

$html.write("</body>
</html>")
$html.close
