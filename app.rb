require 'google/api_client'
require 'google_drive'
require 'pry'
require './env' if File.exists?('env.rb')
require 'httparty'

BACKUP_DIR = "./bak"
FILES_TO_BACKUP = Dir.glob("#{BACKUP_DIR}/*#{Date.today}*").join(" ")
BACKUP_FILE_NAME = "wdidc_backup-set-#{Date.today}.tar"
BACKUP_FILE_PATH = "#{BACKUP_DIR}/#{BACKUP_FILE_NAME}"

# Authorizes with OAuth and gets an access token.
client = Google::APIClient.new
auth = client.authorization

auth.client_id =      ENV.fetch('GOOGLE_CLIENT_ID')
auth.client_secret =  ENV.fetch('GOOGLE_CLIENT_SECRET')
auth.refresh_token =  ENV.fetch('GOOGLE_REFRESH_TOKEN')

auth.scope = [
  'https://www.googleapis.com/auth/drive'
]

auth.fetch_access_token!
access_token = auth.access_token


`tar -cvf #{BACKUP_FILE_PATH} #{FILES_TO_BACKUP}`

session = GoogleDrive.login_with_oauth(access_token)
session.upload_from_file(BACKUP_FILE_PATH, BACKUP_FILE_NAME, convert: false)
