require 'stringio'
require "google_drive"
require "base64"

CREDENTIALS = ENV["CREDENTIALS"]
DECODED = Base64.decode64(CREDENTIALS)
DECODED_IO = StringIO.new(DECODED)

SESSION = GoogleDrive::Session.from_service_account_key(
  DECODED_IO)

SESSION.files.each do |file|
  file.export_as_file("#{file.title}.csv", "text/csv")
end
