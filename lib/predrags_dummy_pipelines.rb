require "predrags_dummy_pipelines/version"
require "predrags_dummy_pipelines/exec"
require "psych"

module PredragsDummyPipelines
  # Your code goes here...

  def self.new(yaml)
      actions = parse(yaml)
      Pipeline.new(actions)
  end

  def self.build
    Exec.new(parse_["build"])
  end
  def self.parse_
    parse_file("project/simple.yml")
  end
  def self.parse_file(file)
    project = Psych.load_file(file)
  end
  def self.parse(actions)
    Psych.load(actions)
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

    def build_results
      @build.results
    end
  end

  def self.test
    a = PredragsDummyPipelines.parse_
    e = PredragsDummyPipelines::Pipeline.new a
    e.run
    e.show
  end
end
