# frozen_string_literal: true

# Core logic for consuming Digicus Textual Representation (DTR) files.
module DigicusWebBackend
  autoload :Compiler, './lib/digicus_web_backend/compiler'
end

def silence_streams
  original_stdout = $stdout
  original_stderr = $stderr
  $stdout = File.new('/dev/null', 'w')
  $stderr = File.new('/dev/null', 'w')
  yield
ensure
  $stdout = original_stdout
  $stderr = original_stderr
end

if __FILE__ == $PROGRAM_NAME
  file_path = ARGV[0]

  if file_path.nil?
    puts 'Usage: ./digicus_web_backend <file_path>'
    exit(1)
  end

  json_for_web = silence_streams do
    DigicusWebBackend::Compiler.from_dtr(File.read(file_path))
  end

  puts json_for_web
end
