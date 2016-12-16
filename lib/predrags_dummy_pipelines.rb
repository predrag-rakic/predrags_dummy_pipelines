require "predrags_dummy_pipelines/version"
require "predrags_dummy_pipelines/exec"
require "predrags_dummy_pipelines/pipeline"
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


  def self.test
    a = PredragsDummyPipelines.parse_
    e = PredragsDummyPipelines::Pipeline.new a
    e.run
    e.show
  end
end
