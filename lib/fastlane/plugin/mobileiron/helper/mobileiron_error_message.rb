module ErrorMessage
  MISSING_BASE_URL = "Missing base URL! Please check that the app parameter is set and try again"
  MISSING_CREDENTIALS_USERNAME = "Missing authentication credentials! Check that your username is set and try again"
  MISSING_CREDENTIALS_PASSWORD = "Missing authentication credentials! Check that your password is set and try again"
  FILE_NOT_FOUND = "File ont found! Please check that the file exists and try again"
  FILE_EXTNAME_NOT_VALID = "File not found! Please check that the file exists and try again"
  INVALID_PATH = "Could not read content from"

  def self.artifact_not_found(artifact_path)
    "Artifact(s) not found in path: #{artifact_path}. Please check that the file exists and try again"
  end

 def self.url_not_available(url)
    "URL not available: #{url}. Please check the network connection and try again"
  end

  def self.artifact_extname_not_valid(extname)
    "The artifact ext '#{extname}' not valid! Make sure that file extname *.apk or *.ipa and try again"
  end

end
