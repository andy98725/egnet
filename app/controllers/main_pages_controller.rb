class MainPagesController < ApplicationController
  def home
    redirect_to base_wars_url
  end
  def index
    @OS = helpers.get_operating_system
  end
  def discord
    redirect_to 'https://discord.gg/HzDVS69'
  end
  def patchNotes
  end
  def patchRaw
    render :inline => "<%= render 'components/base_wars/patchNotes' %>"
  end

  def installerWindows
    helpers.reportDownload(1)
    redirect_to helpers.getS3File('launcher/win/Base Wars.zip')
  end
  def installerMac
    helpers.reportDownload(2)
    redirect_to helpers.getS3File('launcher/mac/Base Wars.zip')
  end
  def installerLinux
    helpers.reportDownload(3)
    redirect_to helpers.getS3File('launcher/lin/Base Wars.zip')
  end

  def installerNum
    render plain: "0.1"
  end
  def download
    helpers.reportDownload(0)
    if params['branch'] == 'beta'
      redirect_to helpers.getS3File('beta/Base_Wars.zip')
    else
      redirect_to helpers.getS3File('stable/Base_Wars.zip')
    end

  end
  def versionNum
    if params['branch'] == 'beta'
      redirect_to helpers.getS3File('beta/version.txt')
    else
      redirect_to helpers.getS3File('stable/version.txt')
    end
  end

end
