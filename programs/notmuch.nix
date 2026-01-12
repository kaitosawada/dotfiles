{ ... }:
{
  programs.notmuch = {
    enable = true;

    new = {
      tags = [
        "new"
        "inbox"
        "unread"
      ];
      ignore = [ ];
    };

    search = {
      excludeTags = [
        "deleted"
        "spam"
      ];
    };

    maildir = {
      synchronizeFlags = true;
    };

    hooks = {
      preNew = "mbsync -a";
      postNew = "";
    };
  };
}
