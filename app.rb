require 'digest/sha1'
require 'nokogiri'
TOKEN = "your_token_here"

enable :inline_templates

before do
  halt 406 unless valid?(params)
end

get '/' do
  params[:echostr]
end

post '/' do
  content_type :xml
  root = Nokogiri::XML(request.body.string).root
  @receiver = root.xpath("ToUserName").children.text
  @sender = root.xpath("FromUserName").children.text
  @send_time = Time.at(root.xpath("CreateTime").text.to_i)
  @keyword = root.xpath("Content").children.text
  @message_type = root.xpath("MsgType").children.text
  @message_id = root.xpath("MsgId").text.to_i
  nokogiri :answer
end

def valid?(params)
  signature = params[:signature] || ''
  timestamp = params[:timestamp] || ''
  nonce = params[:nonce] || ''
  Digest::SHA1.hexdigest([TOKEN, timestamp, nonce].sort.join) == signature ? true : false
end

__END__
@@ answer
xml.xml do
  xml.ToUserName { xml.cdata @sender }
  xml.FromUserName { xml.cdata @receiver }
  xml.CreateTime Time.now.to_i
  xml.MsgType { xml.cdata "text" }
  xml.Content { xml.cdata "success!" }
  xml.FuncFlag 0
end