require 'spec_helper'

describe PredragsDummyPipelines::Exec do
  it 'creates object - empty arrays' do
    actions = {"cmd" => [], "test" => []}
    e = PredragsDummyPipelines::Exec.new(actions, "foo")
    expect(e).not_to be nil
    expect(e.cmd).to eq([])
    expect(e.test).to eq([])
  end

  it 'creates object - no commands' do
    actions = {"cmd" => nil, "test" => nil}
    e = PredragsDummyPipelines::Exec.new(actions, "name")
    expect(e).not_to be nil
    expect(e.cmd).to eq([])
    expect(e.test).to eq([])
  end

  it 'creates object - with commands and tests' do
    actions = {"cmd" => ["ls", "df"], "test" => ["free"]}
    e = PredragsDummyPipelines::Exec.new(actions, "name")
    expect(e).not_to be nil
    expect(e.cmd).to eq(["ls", "df"])
    expect(e.test).to eq(["free"])
  end

  it 'creates object - run commands' do
    actions = {"cmd" => ["echo foo"]}
    e = PredragsDummyPipelines::Exec.new(actions, "name")
    expect(e).not_to be nil
    expect(e.cmd).to eq(["echo foo"])
    e.run
    expect(e.results[:cmd]).to eq([{input: "echo foo", output: "foo\n", estatus: 0}])
    expect(e.results[:test]).to eq([])
  end
end
