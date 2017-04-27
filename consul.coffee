# To register new ACL:
#   @hubot register nginx on nginx001
# Hubot will register ACL defined in #{data} and provide ACL Token via private message.


token = "Consul Master Token"
url = "http://consul_url:8500"

module.exports = (robot) ->
  robot.hear /@hubot register (.*) on (.*)/i, (res) ->
    res.reply "Registering `#{res.match[1]}` service for nodes that are starting with `#{res.match[2]}*`. Token will be sent to you via PM."
    sender = res.message.user.name.toLowerCase()
    data = JSON.stringify({
      "Name": "#{res.match[1]} - #{sender}",
      "Type": "client",
      "Rules": "agent \"#{res.match[2]}\" {\n  policy = \"write\"\n}\nservice \"#{res.match[1]}\" {\n  policy = \"write\"\n}\nnode \"#{res.match[2]}\" {\n  policy = \"write\"\n}"
    });
    robot.http("#{url}/v1/acl/create?token=#{token}")
      .put(data) (err, response, body) ->
        token = JSON.parse body
        robot.messageRoom("@#{sender}", "Your token for `#{res.match[1]}` service is `#{token.ID}`")
