module PredragsDummyPipelines

  class Exec
    def initialize(actions, name)
      @name = name
      @cmd  = actions.select {|a| a.key? "cmd"}.first["cmd"]
      @test = actions.select {|a| a.key? "test"}.first["test"]
      @cmd_results = []
      @test_results = []
    end

    def cmd
      @cmd
    end

    def run
      run_cmd(@cmd, @cmd_results, true)
      return if @cmd_results.last.last != 0
      run_cmd(@test, @test_results, false)
    end

    def run_cmd(commands, results, should_break)
      commands.each {|c|
        begin
          results << [%x[#{c}], $?.exitstatus]
          break if should_break and $?.exitstatus != 0
        rescue => e
          results << [e, $?.exitstatus]
          break if should_break
        end
      }
      @results
    end

    def show
      [{exec_name: @name, cmd: @cmd, test: @test}, @cmd_results, @test_results]
    end
  end
end
