# frozen_string_literal: true

s = <<-INDENTED_HEREDOC
test-all   16890 tests, 2236639 assertions, 0 failures, 0 errors, 117 skips

test-spec  3551 files, 26041 examples, 203539 expectations, 0 failures, 0 errors, 0 tagged
mspec      3551 files, 26041 examples, 203469 expectations, 0 failures, 0 errors, 0 tagged

test-basic test succeeded
btest      PASS all 1194 tests

Total Failures/Errors 0

ruby 2.5.0dev (2017-09-26 trunk 60035) [x64-mingw32]
INDENTED_HEREDOC

s = "<code>#{s.gsub(/\n/, "<br/>")}</code>"

`appveyor AddMessage \"#{s}\"`
exit 0
