require 'stringio'
require "google_drive"
require "base64"

CREDENTIALS = ENV["CREDENTIALS"]
DECODED = Base64.decode64(CREDENTIALS)
DECODED_IO = StringIO.new(DECODED)

SESSION = GoogleDrive::Session.from_service_account_key(
  DECODED_IO)

file = SESSION.file_by_url(ENV["SHEET_URL"])

file.worksheets.each do |ws|
  ws.export_as_file("#{ws.title}.csv")
end
