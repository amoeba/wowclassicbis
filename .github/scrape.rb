require 'stringio'
require "google_drive"
require "base64"

CREDENTIALS = ENV["CREDENTIALS"]
DECODED = Base64.decode64(CREDENTIALS)
DECODED_IO = StringIO.new(DECODED)

SESSION = GoogleDrive::Session.from_service_account_key(
  DECODED_IO)

# "mysheetid1,mysheetid2"
SHEET_IDS = ENV["SHEET_IDS"].split(",")

SHEET_IDS.each do |id|
  file = SESSION.file_by_id(id)
  puts file.title

  file.worksheets.each do |ws|
    puts ws.title

    begin
      ws.export_as_file("#{ws.title}.csv")
    rescue
      puts "FAILED"
    end
  end
end
