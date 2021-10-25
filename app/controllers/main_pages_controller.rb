class MainPagesController < ApplicationController
  def index
    @OS = helpers.get_operating_system
  end
  def discord
    redirect_to 'https://discord.gg/WuY6ZJR'
  end
  def steam
    redirect_to 'https://store.steampowered.com/app/1747110/Base_Wars/'
  end

  def patchNotes
  end
  def patchRaw
    render :inline => "<%= render 'components/base_wars/patchNotes' %>"
  end

  def demoWindows
    helpers.reportDownload(1)
    redirect_to helpers.getS3File('demo/win/Base Wars.zip')
  end
  def demoMac
    helpers.reportDownload(2)
    redirect_to helpers.getS3File('demo/mac/Base Wars.zip')
  end
  def demoLinux
    helpers.reportDownload(3)
    redirect_to helpers.getS3File('demo/lin/Base Wars.zip')
  end
  def installerNum
    render plain: "0.1"
  end

  def downloadRaw
    helpers.reportDownload(0)
    if params['branch'] == 'beta' || ENV['BASE_WARS_BRANCH'] == 'beta'
      redirect_to helpers.getS3File('beta/Base_Wars.zip')
    else
      redirect_to helpers.getS3File('stable/Base_Wars.zip')
    end
  end
  def versionNum
    if params['branch'] == 'beta' || ENV['BASE_WARS_BRANCH'] == 'beta'
      redirect_to helpers.getS3File('beta/version.txt')
    else
      redirect_to helpers.getS3File('stable/version.txt')
    end
  end

end