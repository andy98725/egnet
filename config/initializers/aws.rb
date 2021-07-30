BWRawLoc = '#{RAILS_ROOT}/lib/assets/downloads/stable/Base_Wars.zip'
BWVerLoc = '#{RAILS_ROOT}/lib/assets/downloads/stable/version.txt'

BWDownloads = Aws::S3::Resource.new(
  region: 'us-east-2',
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
).bucket(ENV['S3_BUCKET'])
