require 'spec_helper'

describe PredragsDummyPipelines do
  it 'has a version number' do
    expect(PredragsDummyPipelines::VERSION).not_to be nil
  end

  it 'creates Pipeline object from text' do
    actions = "build: \n  cmd: []\n  test: []"
    pip = PredragsDummyPipelines.new(actions)
    expect(pip).not_to be nil
    expect(pip.build_results).to eq({cmd: [], test: [], name: "build"})
  end
end
