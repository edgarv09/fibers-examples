require "fiber_scheduler"
require "open-uri"
require "httparty"
require "redis"
require "sequel"
require 'benchmark'
require 'sequel'

class SchedulerExample
  # DB = Sequel.connect('sqlite://Chinook.db')

  class << self
    def basic
      Fiber.set_scheduler(FiberScheduler.new)

      Fiber.schedule do
        URI.open("https://httpbin.org/delay/2")
      end

      Fiber.schedule do
        URI.open("https://httpbin.org/delay/2")
      end
    end

    def sequential
      puts "Fiber 1 - example with Uri - 2s deleay "
      URI.open("https://httpbin.org/delay/2")
        puts "Fiber 2 - example with HTTP library - 2s deleay"
      HTTParty.get("https://httpbin.org/delay/2")
        puts "Fiber 3 - example with Redis - 2s deleay "
      REDIS.blpop("abc123", timeout: 2)
        puts "Fiber 4 - example with PG Sleep  - 2s deleay "
      Database.db_instance.run("SELECT pg_sleep(2)")
        puts "Fiber 5 - example with sleep ruby - 2s deleay"
      sleep 2
        puts "Fiber 6 - example with system sleep  - 2s deleay"
      # `sleep 2`
    end

    def time_sequential
      Benchmark.realtime do
        sequential
      end
    end

    def advance
      Sequel.extension(:fiber_concurrency)

      Fiber.set_scheduler(FiberScheduler.new)

      Fiber.schedule do
        puts "Fiber 1 - example with Uri - 2s deleay "
        URI.open("https://httpbin.org/delay/2")
      end

      Fiber.schedule do
        # Use any HTTP library
        puts "Fiber 2 - example with HTTP library - 2s deleay"
        HTTParty.get("https://httpbin.org/delay/2")
      end

      Fiber.schedule do
        # Works with any TCP protocol library
        puts "Fiber 3 - example with Redis - 2s deleay "
        REDIS.blpop("abc123", timeout: 2)
      end

      Fiber.schedule do
        # Make database queries
        puts "Fiber 4 - example with PG Sleep  - 2s deleay "
        Database.db_instance.run("SELECT pg_sleep(2)")
      end

      Fiber.schedule do
        puts "Fiber 5 - example with sleep ruby - 2s deleay"
        sleep 2
      end

      Fiber.schedule do
        puts "Fiber 6 - example with system sleep  - 2s deleay"
        # Run system commands
        `sleep 2`
      end
    end

    def time_advance
      Benchmark.realtime do
        self.advance
      end
    end
  end
end
