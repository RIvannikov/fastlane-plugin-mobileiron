RSpec.describe Fastlane::Client::MobileironApiClient do

  BASE_URL = "TODO"
  USERNAME = "TODO"
  PASSWORD = "TODO"

  it "test" do
    puts " strip ".strip
    puts "strip strip".strip
    expect(true).to be true
  end

  it "Mobileiron GET /ping" do
    client = Fastlane::Client::MobileironApiClient.new(BASE_URL, USERNAME, PASSWORD)
    response = client.ping

    expect(response).not_to be nil
  end

  it "Mobileiron GET /labels/label_summary" do
    client = Fastlane::Client::MobileironApiClient.new(BASE_URL, USERNAME, PASSWORD)
    response = client.get_labels_summary

    expect(response.results).not_to be nil
  end

  it "Mobileiron label info" do
    client = Fastlane::Client::MobileironApiClient.new(BASE_URL, USERNAME, PASSWORD)
    test_label="Shops Test prepare Global"
    response = client.get_label_summary(test_label)

    expect(response.id).not_to be nil
  end

  it "Upload artefact to Mobileiron" do
    client = Fastlane::Client::MobileironApiClient.new(BASE_URL, USERNAME, PASSWORD)
    artefact="/Users/rivannikov/Downloads/Denso-dev-4.5.0.ipa"
    response = client.appstore_inhouse(artefact)

    @@app_id = response.results.id

    expect(response).not_to be nil
  end

  it "Add App version to Label on Mobileiron" do
    client = Fastlane::Client::MobileironApiClient.new(BASE_URL, USERNAME, PASSWORD)
    label_id = 85
    space_id = 1
    response = client.appstore_apps_labels(@@app_id, label_id, space_id)

    success = response.messages.first().is_success
    expect(success).to be true
  end

  it "Send message to update App on Mobileiron" do
    client = Fastlane::Client::MobileironApiClient.new(BASE_URL, USERNAME, PASSWORD)
    response = client.appstore_apps_message(@@app_id)

    success = response.messages.first().is_success
    expect(success).to be true
  end

end
