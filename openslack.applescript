tell application "Arc"
  activate
  set slackURL to "https://app.slack.com/client/TFP6DH37A/CFQ4LRHL5"

  tell front window
    try
      select (first tab whose location is "topApp" and URL starts with "https://app.slack.com/client/TFP6DH37A")
    on error
      open location slackURL
    end try
  end tell
end tell
