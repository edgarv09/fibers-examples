require 'fiber'
module Chat
  extend self
# Número de elementos que se pueden procesar al mismo tiempo
WINDOW_SIZE = 5

def in_batches
  fibers = [] # Almacenar todas las fibras
  elements = (1..20).to_a # Lista de elementos para procesar
  condition = FiberCondition.new(WINDOW_SIZE)

  elements.each_slice(WINDOW_SIZE) do |batch|
    fibers << batch_processor(batch, condition)
  end

  # Proceso de Round Robin
  until fibers.empty?
    fiber = fibers.first
    p fiber.alive?
    fiber.resume if fiber.alive?
    fibers.delete(fiber) unless fiber.alive?
    fibers.rotate!(1) # Cambio de Round Robin
  end

  puts "Procesamiento de lotes completado"
end

def batch_processor(batch, condition)
  Fiber.new do
    batch.each do |element|
      process_element(element)
      # Esperar hasta que se pueda procesar otro elemento
      condition.wait element
    end
  end
end

def process_element(element)
  # Simulación de procesamiento de un elemento
  puts "Procesando elemento #{element} en fibra #{Fiber.current.object_id}"  
end

class FiberCondition
  def initialize(max_count)
    @max_count = max_count
    @count = 0
  end

  def wait(element)
    signal
    Fiber.yield element if @count >= @max_count
    sleep(1)
     # Simulación de procesamiento
  end

  def signal
    @count -= 1 if @count > 0
  end

  def increment
    @count += 1
  end
end
end
