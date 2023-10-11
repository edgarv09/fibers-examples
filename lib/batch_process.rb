require 'fiber'

def round_robin_scheduler(elements, batch_size, time_slice)
  fibers = build_fibers(elements, batch_size, rand(1..10), time_slice)

  loop do
    fibers.each do |fiber|
      fiber.resume if fiber.alive?
      fibers.rotate  # Rotamos las fibras para el siguiente ciclo
    end

    break if !fibers.all?(&:alive?)
  end
end

def build_fibers(elements, batch_size, burst_time, time_slice)
  # Divide los elementos en lotes
  fibers = []
  elements.each_slice(batch_size).with_index do |batch, index|
    puts "Lote de datos a procesar #{batch}, burst_time: #{burst_time}"
    fibers << batch_processor(batch, burst_time, time_slice)
  end
  fibers
end

def burst_time(burst_time, time_slice)
  return 0 if burst_time < 0
  execution_time = [burst_time, time_slice].min
  burst_time -= execution_time
end

def batch_processor(batch, burst_time, time_slice)
  Fiber.new do |window|
    loop do
      window = burst_time(burst_time, time_slice)
      p window
      break if batch.empty?
      # Procesa elementos según el tamaño de la ventana
      current_window = batch.shift(window)
      p current_window
      Fiber.yield
      sleep(5)
    end
  end
end


# Prueba con algunos datos de ejemplo
# elements = (1..20).to_a
# batch_size = 5
# in_batches(elements, batch_size)
