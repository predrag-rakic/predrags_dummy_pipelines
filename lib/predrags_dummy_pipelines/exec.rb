module PredragsDummyPipelines

  class Exec
    attr_reader :name
    attr_reader :cmd
    attr_reader :test

    def initialize(actions, name)
      @name = name
      @cmd  = actions["cmd"]  || []
      @test = actions["test"] || []
      @cmd_results = []
      @test_results = []
    end

    def run
      run_cmd(@cmd, @cmd_results, true)
      return if @cmd_results.last.last != 0
      run_cmd(@test, @test_results, false)
    end

    def run_cmd(commands, results, should_break)
      commands.each {|c|
        begin
          results << [c, %x[#{c}] || "", $?.exitstatus]
          break if should_break and $?.exitstatus != 0
        rescue => e
          results << [c, e.inspect, $?.exitstatus]
          break if should_break
        end
      }
      @results
    end

    def show
      [{exec_name: @name, cmd: @cmd, test: @test}, @cmd_results, @test_results]
    end

    def results
      [@cmd_results, @test_results]
    end
  end
end
