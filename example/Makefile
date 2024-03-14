.PHONY: clean

FUNCTION_TARGET = function
PORT = 8080

clean:
	dart run build_runner clean

run:
	make gen_all
	dart run bin/server.dart --port=$(PORT) --target=$(FUNCTION_TARGET)

# Fetch dependencies for all packages
get_all:
	dart pub get
	cd packages/ai_assistant && dart pub get
	cd packages/database && dart pub get

gen_all:
	dart run build_runner build --delete-conflicting-outputs

update_webhook_url:
	@chmod +x ./scripts/update_webhook_ngrok_url.sh
	./scripts/update_webhook_ngrok_url.sh
