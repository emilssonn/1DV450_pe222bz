require 'oauth2'
callback = "urn:ietf:wg:oauth:2.0:oob"
app_id = "c7c93e084895a2b37c75f92a1691e4a91a9371d24b721ec737a914019cf802fd"
secret = "0bb29c4e1e48761e918640831f9499ceac44db552881f4a53fb5918699989f0f"
client = OAuth2::Client.new(app_id, secret, site: "http://lvh.me:3000/")
access = client.auth_code.get_token('6b51db7551d1964322f9c93fd28e8a109640b72ff0d03b1f80a3d0f5d1a4fd8f', redirect_uri: callback)
puts access.token