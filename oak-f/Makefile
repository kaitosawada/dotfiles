REMOTE := oak-f.co.jp
SRC := src
OPTS := --transfers 1 --checkers 1 --retries 3 -v

.PHONY: copy sync clean

copy:
	rclone copy $(REMOTE):/ $(SRC)/ $(OPTS)

sync:
	rclone sync $(SRC)/ $(REMOTE):/ $(OPTS)

clean:
	rm -rf $(SRC)