run:
	bundle install --local --deployment > /dev/null 2>&1
	@echo "Running the application..."
	@if [ -z "$(file)" ]; then \
		echo "Usage: make run file=path/to/your/file.dtr"; \
  		exit 1; \
  fi; \
	bundle exec ruby lib/digicus_web_backend.rb $(file)

version:
	@./digicus_web_backend version
