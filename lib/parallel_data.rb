require 'fiber'


def in_batches_scheduler
end

def in_batches
  Fiber.set_scheduler(FiberScheduler.new)
  # Una lista de elementos para procesar
  elements = (1..20).to_a

  # El número de elementos a procesar en paralelo
  batch_size = 5

  fiber_list = []
  # Divide los elementos en lotes
  elements.each_slice(batch_size).with_index do |batch, index|
    # Inicializa una nueva instancia de la fibra para cada lote
    puts "Lote de datos a procesar #{batch} "
    fiber_list << group_batch_processor_2(batch)

  end
  p "Cantidad de fibras: #{fiber_list.size}"
  # Esperar hasta que todas las fibras terminen
  # loop do
  #   fiber_list.shuffle!
  #   alive_fibers = fiber_list.select do |fiber|
  #     p "#{fiber.object_id} alive: #{fiber.alive?}"
  #     fiber.resume if fiber.alive?
  #     fiber.alive?
  #   end
  #   puts "empty: #{alive_fibers.empty?}"
  #   break if alive_fibers.empty?
  # end

  puts "Procesamiento de lotes completado"
end

def batch_processor(batch)
  Fiber.new do
    batch.each do |element|
      # Simulación de procesamiento de un elemento
      puts ">>>>> Procesando elemento #{element} en fibra #{Fiber.current.object_id}"
      if rand(0..1) == 0
        Fiber.yield element
        sleep(1)
      end
    end
  end
end

def group_batch_processor(batch)
  Fiber.new do
      # Simulación de procesamiento de un elemento
      puts ">>>>> Procesando batch #{batch} en fibra #{Fiber.current.object_id}"
      sleep(1)
  end
end

def group_batch_processor_2(batch)
  Fiber.schedule do
    begin
      Timeout.timeout(5) do
        # Simulación de procesamiento de un elemento
        puts ">>>>> Procesando batch #{batch} en fibra #{Fiber.current.object_id}"
        sleep(10)
        puts ">>>>> Finalizando fibra #{Fiber.current.object_id}"
      end
    rescue Timeout::Error
      puts "El tiempo de ejecución ha superado el límite de #{5} segundos."
    end
  end
end
