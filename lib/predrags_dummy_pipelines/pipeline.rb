module PredragsDummyPipelines

  class Pipeline
    attr_reader :build

    def initialize(actions)
      @build   = Exec.new(actions["build"], "build")
      deploys  = actions.select {|a,b| a != "build"}
      @deploys = deploys.map {|key, value| Exec.new(value, key)}
    end

    def run
      @build.run
      @deploys.map {|deploy|  deploy.run if success? }
    end

    def show
      puts @build.show
      @deploys.map {|deploy| puts deploy.show }
    end

    def build_results
      @build.results
    end

    def deploy_results
      @deploys.map {|deploy| deploy.results}
    end

    def success?
      @build.success? and @deploys.map {|deploy| deploy.success?}.all? {|estat| estat == true}
    end
  end

end
