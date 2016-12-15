require "predrags_dummy_pipelines/version"
require "predrags_dummy_pipelines/exec"
require "psych"

module PredragsDummyPipelines
  # Your code goes here...

  def new(file)
      actions = parse(file)
      #Pipelines::Pipeline.new(actions)
      Pipeline.new(actions)
  end

  def self.build
    Exec.new(parse_["build"])
  end
  def self.parse_
    parse("project/simple.yml")
  end
  def self.parse(file)
    project = Psych.load_file(file)
  end


  class Pipeline
    def initialize(actions)
      @build   = Exec.new(actions["build"], "build")
      deploys  = actions.select {|a,b| a != "build"}
      @deploys = deploys.map {|key, value| Exec.new(value, key)}
    end

    def run
      @build.run
      @deploys.map {|deploy|  deploy.run  }
    end

    def show
      puts @build.show
      @deploys.map {|deploy| puts deploy.show }
    end
  end
end

a = PredragsDummyPipelines.parse_
e = PredragsDummyPipelines::Pipeline.new a
e.run
e.show
