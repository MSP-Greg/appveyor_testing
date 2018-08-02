io = IO.popen("ruby -W0 -e 'Thread.new(\"foo\", &Object.method(:class_eval)).join'")
pid = io.pid
th = Thread.new {
  io_read = io.read
  io.close
  $?
}
Process.kill(:KILL, pid) unless th.join
status = th.value
puts "\nstatus.signaled? #{status.signaled?}"
puts status
