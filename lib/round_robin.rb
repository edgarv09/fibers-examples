module RoundRobin
  extend self

  def round_robin_scheduler(processes, time_slice)
    fibers = processes.map { |name, burst_time| Fiber.new { execute_process(name, burst_time, time_slice) } }

    loop do
      fibers.each do |fiber|
        fiber.resume if fiber.alive?
        fibers.rotate  # Rotamos las fibras para el siguiente ciclo
      end

      break if !fibers.all?(&:alive?)
    end
  end

  def execute_process(name, burst_time, time_slice)
    puts "Proceso #{name} completado." if burst_time <= 0
    while burst_time > 0
      execution_time = [burst_time, time_slice].min
      puts "Ejecutando proceso #{name} por #{execution_time} unidades de tiempo."
      burst_time -= execution_time
      puts "Tiempo restante #{burst_time}"
      Fiber.yield burst_time
      sleep(execution_time)
    end
  end
end



# # Ejemplo de uso
# processes = [
#   ["P1", 8],
#   ["P2", 6],
#   ["P3", 4],
#   ["P4", 2]
# ]

# time_slice = 3

# RoundRobin.round_robin_scheduler(processes, time_slice)
