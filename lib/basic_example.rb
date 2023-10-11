def self.basic_example
begin
  puts "1: #{Time.now} Start program."
  f = Fiber.new do
    puts "3: #{Time.now} Entered fiber."
    Fiber.yield
    sleep 1
    puts "4: #{Time.now} Yield to main."
    Fiber.yield  # Aquí se pausa la ejecución y se devuelve al main.
    sleep 1
    puts "6: #{Time.now} Exited fiber."
  end

  sleep 1
  puts "2: #{Time.now} Resume fiber first time."
  f.resume

  sleep 1
  puts "5: #{Time.now} Resume fiber second time."
  f.resume

  sleep 1
  puts "7: #{Time.now} Finished."
end

end
