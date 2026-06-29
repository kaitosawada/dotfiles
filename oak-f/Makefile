REMOTE := oak-f.co.jp
SRC := src
OPTS := --transfers 1 --checkers 1 --retries 3 -v
EXCLUDE := --exclude "/log/**" --exclude "/asusage/**" --exclude "/asstats/**" --exclude "/public_html/@/AppData/**"

.PHONY: copy sync clean

copy:
	rclone copy $(REMOTE):/ $(SRC)/ $(OPTS) $(EXCLUDE)

sync:
	rclone sync $(SRC)/ $(REMOTE):/ $(OPTS) $(EXCLUDE)

clean:
	rm -rf $(SRC)
