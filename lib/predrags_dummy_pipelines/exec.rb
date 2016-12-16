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
      return if not success_impl(@cmd_results)
      run_cmd(@test, @test_results, false)
    end

    def show
      [{exec_name: @name}, @cmd_results, @test_results]
    end

    def results
      {:cmd => @cmd_results, :test => @test_results, name: @name}
    end

    def success?
      success_impl(@cmd_results) and success_impl(@test_results)
    end

    def success_impl(results)
      return false if (results == [])
      results.each {|cmd| cmd[:estatus]}.all? {|status| status == 0}
    end

    private

    def run_cmd(commands, results, should_break)
      commands.each {|c|
        begin
          results << {:input => c, :output => %x[#{c}] || "", :estatus => $?.exitstatus}
          break if should_break and $?.exitstatus != 0
        rescue => e
          results << {:input => c, :output => e.inspect, :estatus => $?.exitstatus}
          break if should_break
        end
      }
      @results
    end
  end

end
