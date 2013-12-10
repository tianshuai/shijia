# encoding: utf-8
module PublicShowHelper

  #网站域名路径
  def domain_base
	CONF['domain_base']
  end

  #图片地址
  def asset_path(path)
	File.join(domain_image, path)
  end

  ##
  # 定义某些元素的class是否是active  或　current
  def css_active?(css)
	"active" if css
  end

  def css_current?(css)
	"current" if css
  end

  def css_on?(css)
    "on" if css
  end

  #自动跳转(可直接在action中调用此方法)
  def auto_redirect(arg={})
     sec = arg[:sec] || 3
     url = arg[:url] || '/'
     msg = arg[:msg] || ''
     msg += " Redirect to '#{url}' after #{sec} sec"
     eval("render :text=>\"<meta http-equiv='refresh' content='#{sec}; url=#{url}'>#{msg}\"")
  end

  # 网站时间显示格式
  # Time.now.to_i可转换时间为integer
  def format_time(integer)
    Time.at(integer).strftime("%Y-%m-%d %H:%M:%S")
  end

  #封装asset属性
  def collect_asset(result={})
    hash = {
      relateable_id: result[:relateable_id], 
      relateable_type: result[:relateable_type],
	  name: result[:name],
      file_name: result[:file_name],
	  file_path: result[:file_path],
      size: result[:size],
      format_type: result[:format],
      width: result[:width],
      height: result[:height],
	  kind: result[:kind]
    }
  end

  #截取中英文统一长度
  def truncate_u(text, length = 30, truncate_string = "...")
    l=0
    char_array=text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l+ (c<127 ? 0.5 : 1)
      if l>=length
        return char_array[0..i].pack("U*")+(i<char_array.length-1 ? truncate_string : "")
      end
    end
    return text
  end

  #用正则统一中英文长度（还不知道和上边方法哪个更准确）
  def truncate_f(text, length = 30, truncate_string = "...")  
      if r = Regexp.new("(?:(?:[^\xe0-\xef\x80-\xbf]{1,2})|(?:[\xe0-\xef][\x80-\xbf][\x80-\xbf])){#{length}}", true, 'n').match(text)  
          r[0].length < text.length ? r[0] + truncate_string : r[0]  
      else  
          text  
      end  
  end 

  # sha1 加密
  def pwd_sha1(pass)
      Digest::SHA1.hexdigest(pass)
  end

  # md5 加密
  def pwd_md5(pass)
     Digest::MD5.hexdigest(pass)
  end

  # hash 加密
  def pwd_hash(pass)
    Digest::SHA256.hexdigest(pass)
  end

  # 随机产生字符串
  def random_string(len)
    randstring = ""
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a 
    1.upto(len) { |i| randstring << chars[rand(chars.size-1)] }
    return randstring
  end

end
