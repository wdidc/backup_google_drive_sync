require 'google/api_client'
require 'google_drive'
require 'pry'
require './env' if File.exists?('env.rb')

BACKUP_DIR = File.dir('/bak/')

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


# Creates a session.
session = GoogleDrive.login_with_oauth(access_token)
