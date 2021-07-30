module MainPagesHelper
  def reportDownload(target = -1)
    #Download.create(IP: request.remote_ip, Target: target)
    Download.create(IP: request.remote_ip, System: request.env['HTTP_USER_AGENT'], Target: target)
  end

  def getS3File(fileloc)
    BWDownloads.object(fileloc).presigned_url(:get, expires_in: 3600)
  end
  
  def get_operating_system
    if !request.env['HTTP_USER_AGENT']
      "Unknown"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/windows/i)
      "Windows"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/mac/i)
      "Mac"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/linux/i)
      "Linux"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/unix/i)
      "Linux"
    else
      "Unknown"
    end
  end

end
