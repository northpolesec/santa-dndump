.PHONY: clean

santa-dndump: santa-dndump.m
	clang "$<" -Ofast -fobjc-arc -framework AppKit -o "$@"

install: santa-dndump
	sudo rm -f "/usr/local/bin/$<"
	sudo cp "$<" "/usr/local/bin/$<"

clean:
	rm -f ./santa-dndump
