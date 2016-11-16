def basic_auth(user, pass)
  cred = "#{user}:#{pass}"
  header 'Authorization', "Basic #{Base64.encode64(cred)}"
end
