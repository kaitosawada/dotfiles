tell application "Arc"
  activate
  set gmailURL to "https://mail.google.com/mail/u/0/#inbox"

  tell front window
    try
      select (first tab whose location is "topApp" and URL starts with "https://mail.google.com/mail/u/0/#inbox")
    on error
      open location gmailURL
    end try
  end tell
end tell
